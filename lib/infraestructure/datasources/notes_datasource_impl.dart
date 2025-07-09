import 'package:englishkey/domain/datasources/notes_datasource.dart';
import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/infraestructure/db/isar_database.dart';
import 'package:isar/isar.dart';

class NotesDatasourceImpl extends NotesDatasource {
  late Future<Isar> dbIsar;

  NotesDatasourceImpl() {
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
