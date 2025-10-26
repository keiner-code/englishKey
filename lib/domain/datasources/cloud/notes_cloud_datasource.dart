import 'package:englishkey/domain/entities/notes.dart';

abstract class NotesCloudDatasource {
  Future<void> create({required Note note});
  Future<String?> update({required Note note});
  Future<List<Note>> listNotes();
  Future<Note?> getOneNote(Note note);
  Future<bool> removeNote({required String id});
}
