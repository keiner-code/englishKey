import 'package:englishkey/domain/entities/notes.dart';
import 'package:englishkey/presentation/providers/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

class AlertDialogWidget extends StatefulWidget {
  const AlertDialogWidget({
    super.key,
    required this.noteCallback,
    required this.titleDialog,
    this.contentForm,
    this.titleForm,
    this.idNote,
  });
  final Function({required Note note}) noteCallback;
  final String titleDialog;
  final String? titleForm;
  final String? contentForm;
  final Id? idNote;
  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.titleForm);
    contentController = TextEditingController(text: widget.contentForm);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return Consumer(
      builder: (context, ref, _) {
        final noteState = ref.watch(notesProvider);
        return AlertDialog(
          //alignment: Alignment(0, -0.7),
          title: Text(
            widget.titleDialog == 'save' ? 'Agregar nota' : 'Actualizar nota',
          ),
          content: Form(
            key: _formKey,
            child: SizedBox(
              height: size.height * 0.24,
              width: size.width * 0.7,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: titleController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor agregar el titulo';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Título de la nota',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextFormField(
                    controller: contentController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Escribe tu nota aquí',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor agregar el Contenido';
                      }
                      return null;
                    },
                  ),
                  if (noteState.status == NotesStatus.loading)
                    Container(
                      margin: EdgeInsets.only(top: 5.0),
                      width: 20.0,
                      height: 20.0,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  if (noteState.status == NotesStatus.success)
                    Text(
                      widget.titleDialog == 'save'
                          ? 'Usuario Agregado Con exito'
                          : 'Usuario actualizado con exito',
                      style: TextStyle(color: Colors.blue[600], fontSize: 16),
                    ),
                  if (noteState.errorMessage != null)
                    Text(
                      noteState.errorMessage!,
                      style: TextStyle(color: Colors.red[600], fontSize: 16),
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.noteCallback(
                    note: Note(
                      title: titleController.text,
                      content: contentController.text,
                      priority: Priority.baja.name,
                      id: widget.idNote,
                    ),
                  );
                }
              },
              child: Text(
                widget.titleDialog == 'save' ? 'Agregar' : 'Actualizar',
                style: TextStyle(fontSize: textTheme.titleSmall!.fontSize),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cerrar',
                style: TextStyle(fontSize: textTheme.titleSmall!.fontSize),
              ),
            ),
          ],
        );
      },
    );
  }
}
