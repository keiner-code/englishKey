import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/presentation/providers/notes_provider.dart';
import 'package:englishkey/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PdfCardViewWidget extends ConsumerWidget {
  const PdfCardViewWidget({super.key, required this.note});
  final Note note;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = MediaQuery.of(context).size;
    final isDarkMode = ref.watch(isDarkModeProvider);
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          SizedBox(
            height: screen.height * 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  PDFView(filePath: note.content, nightMode: isDarkMode),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Row(
                      children: [Icon(Icons.star, color: Colors.yellow)],
                    ),
                  ),
                ],
              ),
            ),
          ),
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
              IconButton(
                onPressed:
                    () => showDialog(
                      context: context,
                      builder:
                          (_) => Dialog(
                            child: PDFView(
                              filePath: note.content,
                              nightMode: isDarkMode,
                            ),
                          ),
                    ),
                icon: Icon(Icons.remove_red_eye, color: Colors.blue[500]),
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
