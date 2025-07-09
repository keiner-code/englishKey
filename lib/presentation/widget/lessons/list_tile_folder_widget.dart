import 'dart:io';

import 'package:englishkey/presentation/providers/lessons_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListTileFolderWidget extends ConsumerWidget {
  const ListTileFolderWidget({super.key, required this.directory});
  final Directory directory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        Icons.folder,
        size: 40,
        color: Theme.of(context).primaryColor,
      ),
      title: Text(directory.path.split('/').last),
      onTap: () {
        ref.read(lessonsProvider.notifier).readVideoToFolder(directory);
      },
    );
  }
}
