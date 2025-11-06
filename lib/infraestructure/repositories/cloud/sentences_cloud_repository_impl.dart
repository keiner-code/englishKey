import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/domain/repositories/cloud/sentence_cloud_repository.dart';
import 'package:englishkey/infraestructure/datasources/cloud/sentences_cloud_datasource_impl.dart';

class SentencesCloudRepositoryImpl extends SentenceCloudRepository {
  final SentencesCloudDatasourceImpl _datasource;

  SentencesCloudRepositoryImpl({datasource})
    : _datasource = datasource ?? SentencesCloudDatasourceImpl();

  @override
  Future<void> create({required Sentences sentence}) {
    return _datasource.create(sentence: sentence);
  }

  @override
  Future<List<Sentences>> getAll({required bool isItem}) {
    return _datasource.getAll(isItem: isItem);
  }

  @override
  Future<List<Sentences>> getAllItems({required int idSentence}) {
    return _datasource.getAllItems(idSentence: idSentence);
  }

  @override
  Future<bool> remove({required int id}) {
    return _datasource.remove(id: id);
  }

  @override
  Future<String?> update({required Sentences sentence}) {
    return _datasource.update(sentence: sentence);
  }

  @override
  Future<List<Sentences>> getFindAll() {
    return _datasource.getFindAll();
  }
}
