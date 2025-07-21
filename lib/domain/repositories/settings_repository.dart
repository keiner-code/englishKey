import 'package:englishkey/domain/entities/settings.dart';

abstract class SettingsRepository {
  Future<Settings> createOrUpdate(Settings setting);
  Future<Settings?> getSetting();
}
