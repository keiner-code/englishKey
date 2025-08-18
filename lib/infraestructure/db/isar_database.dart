import 'package:englishkey/domain/entities/directories.dart';
import 'package:englishkey/domain/entities/last_player.dart';
import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/domain/entities/settings.dart';
import 'package:englishkey/domain/entities/suggestion.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class IsarDatabase {
  static Future<Isar> openDB() async {
    var isar = Isar.getInstance();
    if (isar != null) return isar;
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      NoteSchema,
      DirectoriesSchema,
      LastPlayerSchema,
      SettingsSchema,
      SentencesSchema,
      SuggestionSchema,
    ], directory: dir.path);
    return isar;
  }
}
