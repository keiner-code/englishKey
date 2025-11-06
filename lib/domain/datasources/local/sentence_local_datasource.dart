import 'package:englishkey/domain/entities/sentences.dart';

abstract class SentenceLocalDatasource {
  Future<Sentences> createOrupdate({required Sentences sentence});
  Future<List<Sentences>> getFindAll();
  Future<List<Sentences>> getAll({required bool isItem});
  Future<List<Sentences>> getAllItems({required int idSentence});
  Future<bool> remove({required int id});
}
