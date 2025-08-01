import 'package:englishkey/config/theme/theme_config.dart';
import 'package:englishkey/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:englishkey/config/router/router_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  runApp(ProviderScope(child: const MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsNotifier = ref.watch(settingProvider);
    final isDarkMode = settingsNotifier.settings?.darkMode ?? false;
    return MaterialApp.router(
      routerConfig: appRouterConfig,
      theme: AppThemeData.getThemeData(isDarkMode),
      debugShowCheckedModeBanner: false,
    );
  }
}
