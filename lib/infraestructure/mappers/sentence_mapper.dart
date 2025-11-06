import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishkey/domain/entities/sentences.dart';

class SentenceMapper {
  static Sentences fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final sentence = snapshot.data();
    return Sentences(
      sentence: sentence?['sentence'],
      isItem: sentence?['isItem'],
      isAsync: sentence?['isAsync'],
      available: sentence?['available'],
      iconString: sentence?['iconString'],
      id: sentence?['id'],
      idPadre: sentence?['idPadre'],
      isSelected: sentence?['isSelected'],
      isUpdate:
          sentence?['isUpdate'] != null
              ? (sentence!['isUpdate'] as Timestamp).toDate()
              : null,
    );
  }

  static Map<String, dynamic> toFirestore(Sentences sentence) {
    return {
      'sentence': sentence.sentence,
      'isItem': sentence.isItem,
      'isAsync': sentence.isAsync,
      'available': sentence.available,
      'iconString': sentence.iconString,
      'id': sentence.id,
      'idPadre': sentence.idPadre,
      'isSelected': sentence.isSelected,
      'isUpdate':
          sentence.isUpdate != null
              ? Timestamp.fromDate(sentence.isUpdate!)
              : null,
    };
  }
}
