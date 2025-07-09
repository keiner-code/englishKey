import 'dart:io';

import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/presentation/providers/notes_provider.dart';
import 'package:englishkey/presentation/widget/home/image_card_widget.dart';
import 'package:englishkey/presentation/widget/home/pdf_card_view_widget.dart';
import 'package:englishkey/presentation/widget/shared/custom_drawer.dart';
import 'package:englishkey/presentation/widget/home/text_card_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:englishkey/presentation/widget/shared/alert_dialog_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

const List<Color> cardColors = [
  Color.fromARGB(130, 131, 187, 103),
  Color.fromARGB(130, 103, 131, 187),
  Color.fromARGB(130, 187, 103, 131),
  Color.fromARGB(130, 187, 131, 103),
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void chargeFile(WidgetRef ref, FileType type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type,
      allowedExtensions: type == FileType.custom ? ['pdf'] : [],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      final appDir = await getApplicationDocumentsDirectory();
      final newPath = '${appDir.path}/${result.files.single.name}';
      final savedFile = await file.copy(newPath);

      if (savedFile.path.isNotEmpty) {
        ref
            .read(notesProvider.notifier)
            .addOrUpdateNote(
              Note(title: type.name, content: savedFile.path, priority: 'baja'),
            );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme.titleSmall;
    final noteState = ref.watch(notesProvider);

    if (noteState.errorMessage != null && noteState.errorMessage!.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(noteState.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resumen de lo aprendido',
          style: TextStyle(fontSize: textTheme!.fontSize),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialogWidget(
                      titleDialog: 'save',
                      noteCallback: ({required note}) {
                        ref.read(notesProvider.notifier).addOrUpdateNote(note);
                      },
                    ),
              );
            },
            icon: Icon(Icons.add_comment_outlined, size: 25),
          ),
          IconButton(
            onPressed: () => chargeFile(ref, FileType.image),
            icon: Icon(Icons.add_photo_alternate_outlined, size: 25),
          ),
          IconButton(
            onPressed: () => chargeFile(ref, FileType.custom),
            icon: Icon(Icons.picture_as_pdf_outlined),
          ),
          SizedBox(width: 5),
        ],
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
      ),
      body: ListView.builder(
        itemCount: noteState.notes.length,
        itemBuilder: (context, index) {
          final currentNote = noteState.notes[index];
          if (currentNote.title == 'image') {
            return ImageCardWidget(note: currentNote);
          }

          if (currentNote.title == 'custom') {
            return PdfCardViewWidget(note: currentNote);
          }

          return TextCardWidget(
            color: cardColors[index % cardColors.length],
            note: currentNote,
          );
        },
      ),
      drawer: CustomDrawer(),
    );
  }
}
