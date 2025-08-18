import 'package:englishkey/domain/entities/suggestion.dart';
import 'package:englishkey/infraestructure/repositories/suggestions_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SuggestionState {
  final List<Suggestion> suggestions;
  final String errorMessage;

  const SuggestionState({this.errorMessage = '', this.suggestions = const []});

  SuggestionState copyWith({
    String? errorMessage,
    List<Suggestion>? suggestions,
  }) => SuggestionState(
    errorMessage: errorMessage ?? this.errorMessage,
    suggestions: suggestions ?? this.suggestions,
  );
}

class SuggestionsNotifier extends StateNotifier<SuggestionState> {
  SuggestionsRepositoryImpl repository;
  SuggestionsNotifier({required this.repository}) : super(SuggestionState());

  void getAll() async {
    final response = await repository.getAll();
    state = state.copyWith(suggestions: response);
  }

  Future<bool> delete(int id) async {
    final isDelete = await repository.delete(id);
    state = state.copyWith(
      suggestions:
          state.suggestions.where((suggestion) => suggestion.id != id).toList(),
    );
    return isDelete;
  }

  void saveOrUpdate(Suggestion suggestion) async {
    state = state.copyWith(errorMessage: '');

    try {
      final wasNew = suggestion.id;

      final response = await repository.createOrUpdate(suggestion);

      if (wasNew == null) {
        state = state.copyWith(
          errorMessage: '',
          suggestions: [...state.suggestions, response],
        );
        return;
      }

      state = state.copyWith(
        errorMessage: '',
        suggestions:
            state.suggestions.map((item) {
              if (item.id == response.id) {
                return suggestion;
              }
              return item;
            }).toList(),
      );
    } catch (e) {
      state = state.copyWith(errorMessage: 'Error interno del servidor $e');
    }
  }
}

final suggestionProvider =
    StateNotifierProvider<SuggestionsNotifier, SuggestionState>((ref) {
      return SuggestionsNotifier(repository: SuggestionsRepositoryImpl())
        ..getAll();
    });
