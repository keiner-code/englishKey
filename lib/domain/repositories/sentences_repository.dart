import 'package:englishkey/domain/entities/sentences.dart';

abstract class SentencesRepository {
  Future<Sentences> createOrupdate({required Sentences sentence});
  Future<List<Sentences>> getAll({required bool isItem});
  Future<List<Sentences>> getAllItems({required int idSentence});
  Future<bool> remove({required int id});
}
