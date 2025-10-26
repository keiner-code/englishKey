import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishkey/domain/entities/notes.dart';

class NoteMapper {
  static Note fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final note = snapshot.data();
    return Note(
      title: note?['title'],
      content: note?['content'],
      priority: note?['priority'],
      date: note?['date'],
      isAsync: note?['isAsync'],
      id: note?['id'],
      isUpdate:
          note?['isUpdate'] != null
              ? (note!['isUpdate'] as Timestamp).toDate()
              : null,
    );
  }

  static Map<String, dynamic> toFirestore(Note note) {
    return {
      'title': note.title,
      'content': note.content,
      'priority': note.priority,
      'date': note.date ?? '',
      'isAsync': note.isAsync ?? false,
      'id': note.id ?? '',
      'isUpdate':
          note.isUpdate != null ? Timestamp.fromDate(note.isUpdate!) : null,
    };
  }
}
