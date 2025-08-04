import 'package:englishkey/domain/entities/sentences.dart';

abstract class SentenceDatasource {
  Future<Sentences> createOrupdate({required Sentences sentence});
  Future<List<Sentences>> getAll({required bool isItem});
  Future<List<Sentences>> getAllItems({required int idSentence});
  Future<bool> remove({required int id});
}
