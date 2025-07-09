import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/presentation/providers/notes_provider.dart';
import 'package:englishkey/presentation/widget/helpers/start_priority.dart';
import 'package:englishkey/presentation/widget/shared/alert_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextCardWidget extends ConsumerWidget {
  const TextCardWidget({super.key, this.color, required this.note});
  final Note note;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = MediaQuery.of(context).size;
    return GestureDetector(
      onDoubleTap: () => ref.read(notesProvider.notifier).changePriority(note),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: Colors.transparent, width: 5.0),
        ),
        margin: const EdgeInsets.all(8.0),
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: screen.width * 0.9,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color:
                      color ??
                      Theme.of(context).cardColor.withValues(
                        red: 0,
                        green: 0,
                        blue: 0,
                        alpha: 0.1,
                      ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          note.title,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Spacer(),
                        Row(
                          children: StartPriority.amountPriority(note.priority),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      child: Text(
                        note.content,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialogWidget(
                            titleDialog: 'update',
                            noteCallback: ({required note}) {
                              ref
                                  .read(notesProvider.notifier)
                                  .addOrUpdateNote(note);
                            },
                            titleForm: note.title,
                            contentForm: note.content,
                            idNote: note.id,
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
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
        ),
      ),
    );
  }
}
