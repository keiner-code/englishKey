import 'package:englishkey/domain/entities/settings.dart';
import 'package:englishkey/infraestructure/repositories/settings_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsNotifier extends ChangeNotifier {
  late SettingsRepositoryImpl repositoryImpl;
  Settings? settings;

  SettingsNotifier() {
    repositoryImpl = SettingsRepositoryImpl();
  }

  Future<void> getAllSetting() async {
    final response = await repositoryImpl.getSetting();

    if (response == null) {
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final newSetting = Settings(
        notifications: false,
        darkMode: brightness == Brightness.dark,
        sharedApp: 'www.keiner-code.com',
        contact: 'www.keiner-code.com',
      );
      await addOrUpdateSetting(newSetting);
      return;
    }
    settings = response;
    notifyListeners();
  }

  Future<void> addOrUpdateSetting(Settings newSetting) async {
    final response = await repositoryImpl.createOrUpdate(newSetting);
    settings = response;
    notifyListeners();
  }
}

final settingProvider = ChangeNotifierProvider<SettingsNotifier>((ref) {
  return SettingsNotifier()..getAllSetting();
});
