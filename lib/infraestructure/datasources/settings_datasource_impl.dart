import 'package:englishkey/domain/datasources/settings_datasource.dart';
import 'package:englishkey/domain/entities/settings.dart';
import 'package:englishkey/infraestructure/db/isar_database.dart';
import 'package:isar/isar.dart';

class SettingsDatasourceImpl extends SettingsDatasource {
  late Future<Isar> dbIsar;

  SettingsDatasourceImpl() {
    dbIsar = IsarDatabase.openDB();
  }

  @override
  Future<Settings> createOrUpdate(Settings setting) async {
    try {
      final db = await dbIsar;
      final id = await db.writeTxn(() async => await db.settings.put(setting));

      if (setting.id != null) return setting;

      final newNote = await db.settings.get(id);
      return newNote!;
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<Settings?> getSetting() async {
    try {
      final db = await dbIsar;
      return await db.settings.where().findFirst();
    } catch (e) {
      throw Exception('$e');
    }
  }
}
