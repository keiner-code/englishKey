import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishkey/domain/datasources/cloud/notes_cloud_datasource.dart';
import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/infraestructure/mappers/note_mapper.dart';
import 'package:logger/web.dart';

class NotesCloudDatasourceImpl extends NotesCloudDatasource {
  late FirebaseFirestore firestoreDb;
  final _keyNote = "notes";
  final Logger _logger = Logger();

  NotesCloudDatasourceImpl() {
    firestoreDb = FirebaseFirestore.instance;
  }

  @override
  Future<List<Note>> listNotes() async {
    try {
      final List<Note> notes = [];
      final response = await firestoreDb.collection(_keyNote).get();
      for (var note in response.docs) {
        notes.add(NoteMapper.fromFirestore(note, null));
      }
      return notes;
    } catch (e) {
      _logger.e(e);
      return [];
    }
  }

  @override
  Future<bool> removeNote({required String id}) async {
    try {
      final querySnapshot =
          await firestoreDb
              .collection(_keyNote)
              .where("id", isEqualTo: int.tryParse(id))
              .get();

      if (querySnapshot.size == 0) return false;

      await firestoreDb
          .collection(_keyNote)
          .doc(querySnapshot.docs[0].id)
          .delete();
      return true;
    } catch (e) {
      _logger.e(e);
      return false;
    }
  }

  @override
  Future<void> create({required Note note}) async {
    final docRef =
        firestoreDb
            .collection(_keyNote)
            .withConverter(
              fromFirestore: NoteMapper.fromFirestore,
              toFirestore: (value, options) => NoteMapper.toFirestore(value),
            )
            .doc();
    await docRef.set(note);
  }

  @override
  Future<String?> update({required Note note}) async {
    try {
      final querySnapshot =
          await firestoreDb
              .collection(_keyNote)
              .where("id", isEqualTo: note.id)
              .get();

      if (querySnapshot.size == 0) {
        return "Error de actualizacion en linea";
      }

      final docRef = firestoreDb
          .collection(_keyNote)
          .doc(querySnapshot.docs[0].id);

      await docRef.update(NoteMapper.toFirestore(note));
      return null;
    } catch (e) {
      _logger.e(e);
      return null;
    }
  }

  @override
  Future<Note?> getOneNote(Note note) async {
    final querySnapshot =
        await firestoreDb
            .collection(_keyNote)
            .where("id", isEqualTo: note.id)
            .get();
    return NoteMapper.fromFirestore(querySnapshot.docs[0], null);
  }
}
