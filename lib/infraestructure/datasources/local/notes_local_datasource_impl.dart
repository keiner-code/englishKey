import 'package:englishkey/domain/datasources/local/notes_local_datasource.dart';
import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/infraestructure/db/isar_database.dart';
import 'package:isar/isar.dart';

class NotesLocalDatasourceImpl extends NotesLocalDatasource {
  late Future<Isar> dbIsar;

  NotesLocalDatasourceImpl() {
    dbIsar = IsarDatabase.openDB();
  }

  @override
  Future<Note> addNoteOrUpdate({required Note note}) async {
    try {
      final db = await dbIsar;
      final id = await db.writeTxn(() async => await db.notes.put(note));

      if (note.id != null) return note;

      final newNote = await db.notes.get(id);
      return newNote!;
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<List<Note>> listNotes() async {
    try {
      final db = await dbIsar;
      return await db.notes.where().findAll();
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<bool> removeNote({required String id}) async {
    final db = await dbIsar;
    try {
      return await db.writeTxn(
        () async => await db.notes.delete(int.parse(id)),
      );
    } catch (e) {
      throw Exception('$e');
    }
  }
}
