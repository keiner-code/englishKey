import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishkey/domain/datasources/cloud/sentence_cloud_datasource.dart';
import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/infraestructure/mappers/sentence_mapper.dart';
import 'package:logger/logger.dart';

class SentencesCloudDatasourceImpl extends SentenceCloudDatasource {
  SentencesCloudDatasourceImpl() {
    firestoreDb = FirebaseFirestore.instance;
  }

  late FirebaseFirestore firestoreDb;
  final _keySentence = "sentences";
  final Logger _logger = Logger();

  @override
  Future<void> create({required Sentences sentence}) async {
    final docRef =
        firestoreDb
            .collection(_keySentence)
            .withConverter(
              fromFirestore: SentenceMapper.fromFirestore,
              toFirestore:
                  (value, options) => SentenceMapper.toFirestore(value),
            )
            .doc();
    await docRef.set(sentence);
  }

  @override
  Future<List<Sentences>> getAll({required bool isItem}) async {
    try {
      final List<Sentences> sentences = [];
      final response =
          await firestoreDb
              .collection(_keySentence)
              .where('isItem', isEqualTo: isItem)
              .get();
      for (var sentence in response.docs) {
        sentences.add(SentenceMapper.fromFirestore(sentence, null));
      }
      return sentences;
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  @override
  Future<List<Sentences>> getAllItems({required int idSentence}) async {
    try {
      final List<Sentences> sentences = [];
      final response =
          await firestoreDb
              .collection(_keySentence)
              .where('idPadre', isEqualTo: idSentence)
              .get();
      for (var sentence in response.docs) {
        sentences.add(SentenceMapper.fromFirestore(sentence, null));
      }
      return sentences;
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  @override
  Future<bool> remove({required int id}) async {
    try {
      final querySnapshot =
          await firestoreDb
              .collection(_keySentence)
              .where("id", isEqualTo: id)
              .get();

      if (querySnapshot.size == 0) return false;

      await firestoreDb
          .collection(_keySentence)
          .doc(querySnapshot.docs[0].id)
          .delete();
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  @override
  Future<String?> update({required Sentences sentence}) async {
    try {
      final querySnapshot =
          await firestoreDb
              .collection(_keySentence)
              .where("id", isEqualTo: sentence.id)
              .get();

      if (querySnapshot.size == 0) {
        return "Error de actualizacion en linea";
      }

      final docRef = firestoreDb
          .collection(_keySentence)
          .doc(querySnapshot.docs[0].id);

      await docRef.update(SentenceMapper.toFirestore(sentence));
      return null;
    } catch (e) {
      _logger.e(e);
      return null;
    }
  }

  @override
  Future<List<Sentences>> getFindAll() async {
    final List<Sentences> sentences = [];
    final response = await firestoreDb.collection(_keySentence).get();
    for (var sentence in response.docs) {
      sentences.add(SentenceMapper.fromFirestore(sentence, null));
    }
    return sentences;
  }
}
