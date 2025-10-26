import 'package:englishkey/domain/datasources/local/notes_local_datasource.dart';
import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/domain/repositories/local/notes_local_respository.dart';

class NotesLocalRepositoryImpl extends NotesLocalRespository {
  final NotesLocalDatasource datasource;

  NotesLocalRepositoryImpl({required this.datasource});

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
