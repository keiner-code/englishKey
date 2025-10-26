import 'package:englishkey/domain/datasources/cloud/notes_cloud_datasource.dart';
import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/domain/repositories/cloud/notes_cloud_respository.dart';

class NotesCloudRepositoryImpl extends NotesCloudRespository {
  final NotesCloudDatasource datasource;

  NotesCloudRepositoryImpl({required this.datasource});

  @override
  Future<List<Note>> listNotes() {
    return datasource.listNotes();
  }

  @override
  Future<bool> removeNote({required String id}) {
    return datasource.removeNote(id: id);
  }

  @override
  Future<void> create({required Note note}) {
    return datasource.create(note: note);
  }

  @override
  Future<String?> update({required Note note}) {
    return datasource.update(note: note);
  }

  @override
  Future<Note?> getOneNote(Note note) {
    return datasource.getOneNote(note);
  }
}
