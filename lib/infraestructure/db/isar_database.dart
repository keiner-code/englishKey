import 'package:englishkey/domain/entities/directories.dart';
import 'package:englishkey/domain/entities/last_player.dart';
import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/domain/entities/settings.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatabase {
  static Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open([
        NoteSchema,
        DirectoriesSchema,
        LastPlayerSchema,
        SettingsSchema,
      ], directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }
}
