import 'package:englishkey/domain/entities/settings.dart';

abstract class SettingsDatasource {
  Future<Settings> createOrUpdate(Settings setting);
  Future<Settings?> getSetting();
}
