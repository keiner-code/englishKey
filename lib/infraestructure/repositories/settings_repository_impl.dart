import 'package:englishkey/domain/datasources/settings_datasource.dart';
import 'package:englishkey/domain/entities/settings.dart';
import 'package:englishkey/domain/repositories/settings_repository.dart';
import 'package:englishkey/infraestructure/datasources/settings_datasource_impl.dart';

class SettingsRepositoryImpl extends SettingsRepository {
  final SettingsDatasource datasource;

  SettingsRepositoryImpl({SettingsDatasource? datasource})
    : datasource = datasource ?? SettingsDatasourceImpl();

  @override
  Future<Settings> createOrUpdate(Settings setting) {
    return datasource.createOrUpdate(setting);
  }

  @override
  Future<Settings?> getSetting() {
    return datasource.getSetting();
  }
}
