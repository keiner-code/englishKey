import 'package:englishkey/domain/datasources/notes_datasource.dart';
import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/domain/repositories/notes_respository.dart';

class NotesRepositoryImpl extends NotesRespository {
  final NotesDatasource datasource;

  NotesRepositoryImpl({required this.datasource});

  @override
  Future<List<Note>> listNotes() {
    return datasource.listNotes();
  }

  @override
  Future<bool> removeNote({required String id}) {
    return datasource.removeNote(id: id);
  }

  @override
  Future<Note> addNoteOrUpdate({required Note note}) {
    return datasource.addNoteOrUpdate(note: note);
  }
}
