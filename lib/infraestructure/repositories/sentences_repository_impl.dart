import 'package:englishkey/domain/datasources/sentence_datasource.dart';
import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/domain/repositories/sentences_repository.dart';

class SentencesRepositoryImpl extends SentencesRepository {
  final SentenceDatasource datasource;

  SentencesRepositoryImpl({required this.datasource});
  @override
  Future<Sentences> createOrupdate({required Sentences sentence}) {
    return datasource.createOrupdate(sentence: sentence);
  }

  @override
  Future<List<Sentences>> getAll({required bool isItem}) {
    return datasource.getAll(isItem: isItem);
  }

  @override
  Future<bool> remove({required int id}) {
    return datasource.remove(id: id);
  }

  @override
  Future<List<Sentences>> getAllItems({required int idSentence}) {
    return datasource.getAllItems(idSentence: idSentence);
  }
}
