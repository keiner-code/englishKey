import 'dart:io';

import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/presentation/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ImageCardWidget extends ConsumerWidget {
  const ImageCardWidget({super.key, required this.note});
  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: Colors.transparent, width: 5.0),
      ),
      margin: const EdgeInsets.all(8.0),
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: screen.width * 0.9,
            height: screen.height * 0.3,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => Dialog(
                          backgroundColor: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(note.content),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                  );
                },
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    Image.file(File(note.content)),
                    Positioned(
                      top: 10,
                      right: 0,
                      child: Icon(Icons.star, color: Colors.yellow),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  ref
                      .read(notesProvider.notifier)
                      .removeNote(note.id.toString());
                },
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
              const Spacer(),
              Text(
                note.date ?? 'Error al cargar la hora',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall!.copyWith(fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
