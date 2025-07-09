import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.transparent),
            child: Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://static.vecteezy.com/system/resources/thumbnails/027/951/137/small_2x/stylish-spectacles-guy-3d-avatar-character-illustrations-png.png',
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Keiner jesus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: textTheme.titleSmall!.fontSize,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.summarize_outlined),
            title: const Text('Resumen de las lecciones'),
            onTap: () {
              context.go('/');
            },
          ),
          ListTile(
            leading: Icon(Icons.video_library_outlined),
            title: const Text('Lecciones'),
            onTap: () {
              context.go('/lessons');
            },
          ),
          ListTile(
            leading: Icon(Icons.videogame_asset_outlined),
            title: const Text('Estudios adicionales'),
            onTap: () {
              context.go('');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.account_circle_outlined),
            title: const Text('Sugerencias'),
            onTap: () {
              context.go('');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: const Text('Configuración'),
            onTap: () {
              context.go('/settings');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout_outlined, color: Colors.red),
            title: const Text(
              'Cerrar sessión',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              // Implement settings navigation
            },
          ),
          Spacer(),
          Center(
            child: Column(
              children: [
                Text(
                  'Keiner-Code',
                  style: TextStyle(color: Colors.grey, fontSize: 11),
                ),
                Text(
                  '© Todos los derechos reservados',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
