import 'package:englishkey/domain/datasources/suggestions_datasource.dart';
import 'package:englishkey/domain/entities/suggestion.dart';
import 'package:englishkey/infraestructure/db/isar_database.dart';
import 'package:isar/isar.dart';

class SuggestionsDatasourceImpl extends SuggestionsDatasource {
  late Future<Isar> dbIsar;

  SuggestionsDatasourceImpl() {
    dbIsar = IsarDatabase.openDB();
  }

  @override
  Future<Suggestion> createOrUpdate(Suggestion suggestion) async {
    try {
      final db = await dbIsar;
      final id = await db.writeTxn(
        () async => await db.suggestions.put(suggestion),
      );

      if (suggestion.id != null) return suggestion;

      final newSuggestion = await db.suggestions.get(id);
      return newSuggestion!;
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<bool> delete(int id) async {
    final db = await dbIsar;
    try {
      return await db.writeTxn(() async => await db.suggestions.delete(id));
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<List<Suggestion>> getAll() async {
    try {
      final db = await dbIsar;
      return await db.suggestions.where().findAll();
    } catch (e) {
      throw Exception('$e');
    }
  }
}
