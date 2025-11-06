import 'package:englishkey/domain/entities/sentences.dart';

abstract class SentenceCloudRepository {
  Future<void> create({required Sentences sentence});
  Future<String?> update({required Sentences sentence});
  Future<List<Sentences>> getAll({required bool isItem});
  Future<List<Sentences>> getAllItems({required int idSentence});
  Future<List<Sentences>> getFindAll();
  Future<bool> remove({required int id});
}
