import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/infraestructure/datasources/cloud/sentences_cloud_datasource_impl.dart';
import 'package:englishkey/infraestructure/datasources/local/sentences_local_datasource_impl.dart';
import 'package:englishkey/infraestructure/repositories/cloud/sentences_cloud_repository_impl.dart';
import 'package:englishkey/infraestructure/repositories/local/sentences_local_repository_impl.dart';
import 'package:englishkey/presentation/providers/connection_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SentenceStatus { initial, loading, success }

class SentenceState {
  final List<Sentences> sentences;
  final List<Sentences> items;
  final String errorMessage;
  final SentenceStatus status;
  final int failures;
  final int successes;
  final int countFailures;
  final List<Map<String, List<Sentences>>> mapSentenceList;

  const SentenceState({
    required this.sentences,
    required this.items,
    required this.errorMessage,
    required this.status,
    required this.failures,
    required this.successes,
    required this.countFailures,
    required this.mapSentenceList,
  });

  SentenceState copyWith({
    List<Sentences>? sentences,
    List<Sentences>? items,
    String? errorMessage,
    SentenceStatus? status,
    int? successes,
    int? failures,
    int? countFailures,
    List<Map<String, List<Sentences>>>? mapSentenceList,
  }) => SentenceState(
    sentences: sentences ?? this.sentences,
    items: items ?? this.items,
    errorMessage: errorMessage ?? this.errorMessage,
    status: status ?? this.status,
    failures: failures ?? this.failures,
    successes: successes ?? this.successes,
    countFailures: countFailures ?? this.countFailures,
    mapSentenceList: mapSentenceList ?? this.mapSentenceList,
  );
}

class SentenceNotifier extends StateNotifier<SentenceState> {
  final SentencesLocalRepositoryImpl repositoryLocalImpl;
  final SentencesCloudRepositoryImpl repositoryCloudImpl;
  final Ref ref;
  SentenceNotifier({
    required this.repositoryLocalImpl,
    required this.repositoryCloudImpl,
    required this.ref,
  }) : super(
         SentenceState(
           sentences: [],
           items: [],
           errorMessage: '',
           status: SentenceStatus.initial,
           failures: 0,
           successes: 0,
           countFailures: 0,
           mapSentenceList: [],
         ),
       );

  void addSuccesses() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'success_key';
    final successAdd = state.successes + 1;
    await prefs.setInt(key, successAdd);
    state = state.copyWith(successes: successAdd, countFailures: 0);
  }

  void resetCounterFailures() async {
    state = state.copyWith(countFailures: 0);
  }

  void addFailures() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'failures_key';
    final failuresAdd = state.failures + 1;
    await prefs.setInt(key, failuresAdd);
    state = state.copyWith(
      failures: failuresAdd,
      countFailures: state.countFailures + 1,
    );
  }

  Future<void> createOrUpdate(Sentences sentence) async {
    state = state.copyWith(errorMessage: '', status: SentenceStatus.loading);

    try {
      final wasNew = sentence.id == null;

      final hasInternet = ref
          .read(connectionProvider)
          .maybeWhen(data: (has) => has, orElse: () => false);

      final user = hasInternet ? FirebaseAuth.instance.currentUser : null;

      final response = await repositoryLocalImpl.createOrupdate(
        sentence: sentence,
      );
      //Create
      if (wasNew) {
        state = state.copyWith(
          errorMessage: '',
          status: SentenceStatus.success,
          sentences: [...state.sentences, response],
        );

        if (user != null) {
          response.isAsync = true;
          await repositoryCloudImpl.create(sentence: response);
          await repositoryLocalImpl.createOrupdate(sentence: response);
        }
        return;
      }

      //Update
      state = state.copyWith(
        errorMessage: '',
        status: SentenceStatus.success,
        sentences:
            state.sentences.map((item) {
              if (item.id == response.id) {
                return sentence;
              }
              return item;
            }).toList(),
      );

      if (user != null) {
        final response = await repositoryCloudImpl.update(sentence: sentence);
        if (response != null) {
          state = state.copyWith(errorMessage: response);
        }
      }

      await getAllSentencesItems(state.sentences);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error interno del servidor $e');
    }
  }

  Future<List<Sentences>> localFindAll() async {
    return await repositoryLocalImpl.getFindAll();
  }

  Future<void> loadItemsFromMainSentence(int id, bool isSelected) async {
    state = state.copyWith(errorMessage: '', status: SentenceStatus.loading);
    try {
      if (isSelected) {
        final response = await repositoryLocalImpl.getAllItems(idSentence: id);
        state = state.copyWith(
          errorMessage: '',
          status: SentenceStatus.success,
          items: [...state.items, ...response],
        );
        return;
      }

      state.items.removeWhere((item) => item.idPadre == id);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error interno en el servidor $e');
    }
  }

  Future<void> getAllSentences() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(errorMessage: '', status: SentenceStatus.loading);
    try {
      final response = await repositoryLocalImpl.getAll(isItem: false);
      state = state.copyWith(
        errorMessage: '',
        status: SentenceStatus.success,
        sentences: response,
      );
      if (response.isNotEmpty) {
        getAllSentencesItems(response);
      }
      final selectedSentence = response.where(
        (value) => value.isSelected == true,
      );

      for (final item in selectedSentence) {
        await loadItemsFromMainSentence(item.id!, true);
      }

      final successCached = prefs.getInt('success_key');
      final failuresCached = prefs.getInt('failures_key');
      if (successCached == null) return;
      state = state.copyWith(successes: successCached);
      if (failuresCached == null) return;
      state = state.copyWith(failures: failuresCached);
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error interno en el servidor');
    }
  }

  Future<void> getAllSentencesItems(List<Sentences> senteces) async {
    state = state.copyWith(errorMessage: '', status: SentenceStatus.loading);
    final List<Map<String, List<Sentences>>> sentenceListMap = [];
    try {
      for (var sentence in senteces) {
        final response = await repositoryLocalImpl.getAllItems(
          idSentence: sentence.id!,
        );
        sentenceListMap.add({sentence.sentence: response});
      }
      state = state.copyWith(
        errorMessage: '',
        status: SentenceStatus.success,
        mapSentenceList: sentenceListMap,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error interno $e',
        status: SentenceStatus.initial,
        mapSentenceList: [],
      );
    }
  }

  removeSentence(int id) {}
}

final sentencesProvider =
    StateNotifierProvider<SentenceNotifier, SentenceState>((ref) {
      return SentenceNotifier(
        ref: ref,
        repositoryLocalImpl: SentencesLocalRepositoryImpl(
          datasource: SentencesLocalDatasourceImpl(),
        ),
        repositoryCloudImpl: SentencesCloudRepositoryImpl(
          datasource: SentencesCloudDatasourceImpl(),
        ),
      )..getAllSentences();
    });
