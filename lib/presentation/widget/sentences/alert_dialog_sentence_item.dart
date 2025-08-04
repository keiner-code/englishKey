import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/presentation/providers/senteces_provider.dart';
import 'package:englishkey/presentation/widget/sentences/alert_dialog_sentence.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertDialogSentenceItem extends ConsumerStatefulWidget {
  const AlertDialogSentenceItem({super.key});

  @override
  ConsumerState<AlertDialogSentenceItem> createState() =>
      _AlertDialogSentenceItemState();
}

class _AlertDialogSentenceItemState
    extends ConsumerState<AlertDialogSentenceItem> {
  final _formKey = GlobalKey<FormState>();
  final _sentenceController = TextEditingController();
  Sentences? _selectedSentence;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AlertDialog(
      title: Row(
        children: [
          Text('Agregar Oración'),
          Spacer(),
          IconButton(
            padding: EdgeInsets.all(0),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialogSentence(),
              );
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.90,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _sentenceController,
                    decoration: InputDecoration(
                      labelText: 'Escriba una oración',
                    ),
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor agrege una oración';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<Sentences>(
                    value: _selectedSentence,
                    decoration: InputDecoration(labelText: 'Escoja una opcion'),
                    isExpanded: true,
                    items:
                        ref
                            .read(sentencesProvider)
                            .sentences
                            .map(
                              (item) => DropdownMenuItem(
                                value: item,
                                child: Text(
                                  item.sentence,
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            )
                            .toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSentence = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isItem) {
                        return 'Por favor selecione una oración';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate() &&
                _selectedSentence != null) {
              ref
                  .read(sentencesProvider.notifier)
                  .createOrUpdate(
                    Sentences(
                      sentence: _sentenceController.text.trim(),
                      isItem: true,
                      idPadre: _selectedSentence!.id,
                    ),
                  );
              _sentenceController.text = "";
              setState(() {
                _selectedSentence = null;
              });
            }
          },
          child: Text(
            'Agregar',
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
  }
}
