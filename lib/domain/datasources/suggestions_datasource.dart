import 'package:englishkey/domain/entities/suggestion.dart';

abstract class SuggestionsDatasource {
  Future<Suggestion> createOrUpdate(Suggestion suggestion);
  Future<bool> delete(int id);
  Future<List<Suggestion>> getAll();
}
