import 'package:englishkey/presentation/providers/settings_provider.dart';
import 'package:englishkey/presentation/widget/shared/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                value: ref.watch(isDarkModeProvider),
                onChanged: (value) {
                  ref.read(isDarkModeProvider.notifier).state = value;
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
            leading: Icon(Icons.cookie_outlined, size: 30),
            title: Text('Politica de cookies', style: TextStyle(fontSize: 20)),
            subtitle: Text(
              'Leer la politica de cookies',
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
