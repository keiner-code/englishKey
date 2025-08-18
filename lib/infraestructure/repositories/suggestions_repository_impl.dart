import 'package:englishkey/domain/datasources/suggestions_datasource.dart';
import 'package:englishkey/domain/entities/suggestion.dart';
import 'package:englishkey/domain/repositories/suggestions_repository.dart';
import 'package:englishkey/infraestructure/datasources/suggestions_datasource_impl.dart';

class SuggestionsRepositoryImpl extends SuggestionsRepository {
  final SuggestionsDatasource suggestionsDatasource;
  SuggestionsRepositoryImpl({SuggestionsDatasource? suggestionsDatasource})
    : suggestionsDatasource =
          suggestionsDatasource ?? SuggestionsDatasourceImpl();
  @override
  Future<Suggestion> createOrUpdate(Suggestion suggestion) {
    return suggestionsDatasource.createOrUpdate(suggestion);
  }

  @override
  Future<bool> delete(int id) {
    return suggestionsDatasource.delete(id);
  }

  @override
  Future<List<Suggestion>> getAll() {
    return suggestionsDatasource.getAll();
  }
}
