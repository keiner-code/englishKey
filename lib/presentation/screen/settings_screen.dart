import 'package:englishkey/core/constants/cache_policy.dart';
import 'package:englishkey/core/constants/privacy_policy.dart';
import 'package:englishkey/core/constants/terms_and_conditions.dart';
import 'package:englishkey/domain/entities/settings.dart';
import 'package:englishkey/presentation/providers/settings_provider.dart';
import 'package:englishkey/presentation/widget/shared/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final settingState = ref.watch(settingProvider);
    final sizeTitle = Theme.of(context).textTheme.titleSmall;
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        title: Text(
          'Configuraciónes',
          style: TextStyle(
            color: sizeTitle?.color,
            fontSize: sizeTitle?.fontSize,
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 15),
          SizedBox(
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    'assets/images/user-avatar.png',
                    width: 150,
                    height: 150,
                  ),
                ),
                Text('Camila Rua Perez', style: TextStyle(fontSize: 22)),
                SizedBox(height: 5),
                Divider(color: Colors.grey[500], height: 3, thickness: 0.4),
              ],
            ),
          ),
          SizedBox(height: 15),
          ListTile(
            leading: Icon(Icons.notifications_outlined, size: 35),
            title: Text('Notificaciones', style: TextStyle(fontSize: 20)),
            subtitle: Text(
              'Recibir notificaciones de novedades',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Transform.scale(
              scale: 0.9,
              child: Switch(
                value: false,
                onChanged: (value) {},
                padding: EdgeInsets.all(0),
              ),
            ),
          ),
          SizedBox(height: 14),
          ListTile(
            leading: Icon(Icons.dark_mode_outlined, size: 35),
            title: Text('Dark Mode', style: TextStyle(fontSize: 20)),
            subtitle: Text(
              'Cambiar entre modo claro y oscuro',
              style: TextStyle(fontSize: 16),
            ),
            trailing: Transform.scale(
              scale: 0.9,
              child: Switch(
                value: ref.watch(settingProvider).settings!.darkMode,
                onChanged: (value) {
                  final settingState = ref.read(settingProvider).settings;
                  ref
                      .read(settingProvider.notifier)
                      .addOrUpdateSetting(
                        Settings(
                          id: settingState!.id,
                          notifications: settingState.notifications,
                          darkMode: value,
                          sharedApp: settingState.sharedApp,
                          contact: settingState.contact,
                        ),
                      );
                },
                padding: EdgeInsets.all(0),
              ),
            ),
          ),
          SizedBox(height: 14),
          ListTile(
            leading: Icon(Icons.share_outlined, size: 30),
            title: Text('Compartir aplicación', style: TextStyle(fontSize: 20)),
            subtitle: Text(
              'Compartir la aplicación con amigos',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 14),
          ListTile(
            onTap:
                () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      scrollable: true,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            privacyPolicy.map((section) {
                              final title = section.keys.first;
                              final lines = section.values.first;

                              return PoliceSettingWidget(
                                title: title,
                                lines: lines,
                              );
                            }).toList(),
                      ),

                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cerrar',
                            style: TextStyle(
                              fontSize:
                                  Theme.of(
                                    context,
                                  ).textTheme.titleSmall!.fontSize,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            leading: Icon(Icons.privacy_tip_outlined, size: 30),
            title: Text(
              'Politica de privacidad',
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              'Leer la politica de privacidad',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 14),
          ListTile(
            onTap:
                () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      scrollable: true,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            termsAndConditions.map((section) {
                              final title = section.keys.first;
                              final lines = section.values.first;

                              return PoliceSettingWidget(
                                title: title,
                                lines: lines,
                              );
                            }).toList(),
                      ),

                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cerrar',
                            style: TextStyle(
                              fontSize:
                                  Theme.of(
                                    context,
                                  ).textTheme.titleSmall!.fontSize,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            leading: Icon(Icons.terminal_outlined, size: 30),
            title: Text(
              'Terminos y condiciones',
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              'Leer los terminos y condiciones de uso',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 14),
          ListTile(
            onTap:
                () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      scrollable: true,
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            cachePolice.map((section) {
                              final title = section.keys.first;
                              final lines = section.values.first;

                              return PoliceSettingWidget(
                                title: title,
                                lines: lines,
                              );
                            }).toList(),
                      ),

                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cerrar',
                            style: TextStyle(
                              fontSize:
                                  Theme.of(
                                    context,
                                  ).textTheme.titleSmall!.fontSize,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
            leading: Icon(Icons.cookie_outlined, size: 30),
            title: Text('Politica de cache', style: TextStyle(fontSize: 20)),
            subtitle: Text(
              'Leer la politica de cache',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 14),
          ListTile(
            leading: Icon(Icons.message_outlined, size: 30),
            title: Text('Contacto', style: TextStyle(fontSize: 20)),
            subtitle: Text(
              'Contactar al equipo de soporte',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 14),
          ListTile(
            leading: Icon(Icons.feedback_outlined, size: 30),
            title: Text('Comentarios', style: TextStyle(fontSize: 20)),
            subtitle: Text(
              'Enviar comentarios y sugerencias',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
    );
  }
}

class PoliceSettingWidget extends StatelessWidget {
  const PoliceSettingWidget({
    super.key,
    required this.title,
    required this.lines,
  });

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 4),
              child: Text(
                line,
                style: const TextStyle(fontSize: 16, height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
