import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/infraestructure/datasources/sentences_datasource_impl.dart';
import 'package:englishkey/infraestructure/repositories/sentences_repository_impl.dart';
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

  const SentenceState({
    required this.sentences,
    required this.items,
    required this.errorMessage,
    required this.status,
    required this.failures,
    required this.successes,
    required this.countFailures,
  });

  SentenceState copyWith({
    List<Sentences>? sentences,
    List<Sentences>? items,
    String? errorMessage,
    SentenceStatus? status,
    int? successes,
    int? failures,
    int? countFailures,
  }) => SentenceState(
    sentences: sentences ?? this.sentences,
    items: items ?? this.items,
    errorMessage: errorMessage ?? this.errorMessage,
    status: status ?? this.status,
    failures: failures ?? this.failures,
    successes: successes ?? this.successes,
    countFailures: countFailures ?? this.countFailures,
  );
}

class SentenceNotifier extends StateNotifier<SentenceState> {
  final SentencesRepositoryImpl repositoryImpl;
  SentenceNotifier({required this.repositoryImpl})
    : super(
        SentenceState(
          sentences: [],
          items: [],
          errorMessage: '',
          status: SentenceStatus.initial,
          failures: 0,
          successes: 0,
          countFailures: 0,
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

  createOrUpdate(Sentences sentence) async {
    state = state.copyWith(errorMessage: '', status: SentenceStatus.loading);

    try {
      final wasNew = sentence.id;

      final response = await repositoryImpl.createOrupdate(sentence: sentence);

      if (response.isItem) return;

      if (wasNew == null) {
        state = state.copyWith(
          errorMessage: '',
          status: SentenceStatus.success,
          sentences: [...state.sentences, response],
        );
        return;
      }

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
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error interno del servidor $e');
    }
  }

  Future<void> loadItemsFromMainSentence(int id, bool isSelected) async {
    state = state.copyWith(errorMessage: '', status: SentenceStatus.loading);
    try {
      if (isSelected) {
        final response = await repositoryImpl.getAllItems(idSentence: id);
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

  getAllSentences() async {
    final prefs = await SharedPreferences.getInstance();
    state = state.copyWith(errorMessage: '', status: SentenceStatus.loading);
    try {
      final response = await repositoryImpl.getAll(isItem: false);
      state = state.copyWith(
        errorMessage: '',
        status: SentenceStatus.success,
        sentences: response,
      );

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

  getAllSentencesItems() {}
  removeSentence(int id) {}
}

final sentencesProvider =
    StateNotifierProvider<SentenceNotifier, SentenceState>((ref) {
      return SentenceNotifier(
        repositoryImpl: SentencesRepositoryImpl(
          datasource: SentencesDatasourceImpl(),
        ),
      )..getAllSentences();
    });
