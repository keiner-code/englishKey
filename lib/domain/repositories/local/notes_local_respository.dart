import 'package:englishkey/domain/entities/notes.dart';

abstract class NotesLocalRespository {
  Future<Note> addNoteOrUpdate({required Note note});
  Future<List<Note>> listNotes();
  Future<bool> removeNote({required String id});
}
