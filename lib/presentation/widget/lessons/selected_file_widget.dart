import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedFileWidget extends ConsumerWidget {
  const SelectedFileWidget({super.key, required this.selectFolder});
  final void Function(WidgetRef ref) selectFolder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: TextButton.icon(
        icon: Icon(
          Icons.add,
          size: 25,
          color: Theme.of(context).textTheme.titleSmall!.color,
        ),
        label: Text(
          'Selecione sus archivos',
          style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).textTheme.titleSmall!.color,
          ),
        ),
        onPressed: () => selectFolder(ref),
      ),
    );
  }
}
