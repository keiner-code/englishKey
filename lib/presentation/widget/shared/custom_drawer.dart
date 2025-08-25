import 'dart:io';
import 'package:englishkey/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final userState = ref.watch(userProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Contenido scrollable
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  userState.state.user == null
                      ? DrawerHeader(
                        child: Center(
                          child: TextButton.icon(
                            label: Text('Agregue Sus Datos'),
                            onPressed: () {},
                            icon: Icon(Icons.person, size: 20),
                          ),
                        ),
                      )
                      : DrawerHeader(
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            userState.state.user!.photo == null
                                ? Icon(Icons.person, size: 50)
                                : CircleAvatar(
                                  radius: 50,
                                  backgroundImage: FileImage(
                                    File(userState.state.user!.photo!),
                                  ),
                                ),
                            const SizedBox(height: 5),
                            Text(
                              userState.state.user!.firstName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: textTheme.titleSmall!.fontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ListTile(
                    leading: const Icon(Icons.summarize_outlined),
                    title: const Text('Resumen de las lecciones'),
                    onTap: () => context.go('/'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.video_library_outlined),
                    title: const Text('Lecciones'),
                    onTap: () => context.go('/lessons'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.videogame_asset_outlined),
                    title: const Text('Completa oraciones'),
                    onTap: () => context.go('/complete_sentence'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.text_snippet_sharp),
                    title: const Text('Oraciónes'),
                    onTap: () => context.go('/sentences'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.account_circle_outlined),
                    title: const Text('Sugerencias'),
                    onTap: () => context.go('/suggestion'),
                  ),
                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Configuración'),
                    onTap: () => context.go('/settings'),
                  ),
                  /* const Divider(),
                  ListTile(
                    leading: const Icon(
                      Icons.logout_outlined,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Cerrar sesión',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {},
                  ), */
                ],
              ),
            ),

            // Footer fijo
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: const [
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
          ],
        ),
      ),
    );
  }
}
