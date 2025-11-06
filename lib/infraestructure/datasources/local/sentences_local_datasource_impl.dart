import 'package:englishkey/domain/datasources/local/sentence_local_datasource.dart';
import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/infraestructure/db/isar_database.dart';
import 'package:isar/isar.dart';

class SentencesLocalDatasourceImpl extends SentenceLocalDatasource {
  late Future<Isar> dbIsar;

  SentencesLocalDatasourceImpl() {
    dbIsar = IsarDatabase.openDB();
  }
  @override
  Future<Sentences> createOrupdate({required Sentences sentence}) async {
    try {
      final db = await dbIsar;
      final id = await db.writeTxn(
        () async => await db.sentences.put(sentence),
      );

      if (sentence.id != null) return sentence;

      final newSentence = await db.sentences.get(id);
      return newSentence!;
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<List<Sentences>> getAll({required bool isItem}) async {
    try {
      final db = await dbIsar;
      return await db.sentences.filter().isItemEqualTo(isItem).findAll();
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<bool> remove({required int id}) async {
    final db = await dbIsar;
    try {
      return await db.writeTxn(() async => await db.sentences.delete(id));
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<List<Sentences>> getAllItems({required int idSentence}) async {
    try {
      final db = await dbIsar;
      return await db.sentences.filter().idPadreEqualTo(idSentence).findAll();
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<List<Sentences>> getFindAll() async {
    try {
      final db = await dbIsar;
      return await db.sentences.where().findAll();
    } catch (e) {
      throw Exception('$e');
    }
  }
}
