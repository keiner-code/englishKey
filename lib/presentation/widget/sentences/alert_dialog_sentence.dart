import 'package:englishkey/core/constants/emojis.dart';
import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/presentation/providers/senteces_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertDialogSentence extends ConsumerStatefulWidget {
  const AlertDialogSentence({
    super.key,
    this.selectedIcon,
    this.textInput,
    this.id,
    required this.isUpdate,
    required this.isAsync,
  });

  final String? textInput;
  final String? selectedIcon;
  final int? id;
  final bool isUpdate;
  final bool isAsync;

  @override
  ConsumerState<AlertDialogSentence> createState() =>
      _AlertDialogSentenceState();
}

class _AlertDialogSentenceState extends ConsumerState<AlertDialogSentence> {
  bool isError = false;
  final sentenceController = TextEditingController();
  final personalIcons = Emojis().personalIcons;
  Map<String, Icon>? _selectedIcon;

  @override
  void initState() {
    super.initState();
    sentenceController.text = widget.textInput ?? '';

    if (sentenceController.text.isNotEmpty) {
      _selectedIcon = Emojis().personalIcons.firstWhere(
        (iconMap) => iconMap.entries.first.key == widget.selectedIcon,
        orElse: () => {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screen = MediaQuery.of(context).size;
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 15),
      title: Text('Escriba el tema'),
      content: SizedBox(
        width: screen.width * 0.90,
        child: Column(
          spacing: 20,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: sentenceController,
              decoration: InputDecoration(
                labelText: 'Escriba un tema',
                errorText: isError ? 'Por favor agregue el tema' : null,
              ),
              onChanged: (value) {
                if (isError && value.isNotEmpty) {
                  setState(() => isError = false);
                }
              },
            ),
            Row(
              children: [
                _selectedIcon == null
                    ? TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialogIconWidget(
                              mediaQuery: screen,
                              callbackSelectedIcon: (selectedIcon) {
                                setState(() {
                                  _selectedIcon = selectedIcon;
                                });
                              },
                            );
                          },
                        );
                      },
                      style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                      child: Text(
                        'Escoja un icono',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                    : SizedBox(),
                SizedBox(width: 10),
                _selectedIcon == null
                    ? SizedBox()
                    : Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).cardColor,
                      ),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      padding: EdgeInsets.all(0),
                      child: Center(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              top: 2,
                              right: 2,
                              child: Icon(Icons.close, size: 15),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedIcon = null;
                                });
                              },
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.all(0),
                              ),
                              icon: IconTheme(
                                data: const IconThemeData(size: 60),
                                child: _selectedIcon!.entries.first.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final String iconString = _selectedIcon!.entries.first.key;
            final text = sentenceController.text.trim();
            if (text.isEmpty) {
              setState(() => isError = true);
              return;
            }
            ref
                .read(sentencesProvider.notifier)
                .createOrUpdate(
                  Sentences(
                    id: widget.id,
                    sentence: text,
                    isItem: false,
                    iconString: iconString,
                    isAsync: widget.isUpdate ? widget.isAsync : false,
                    isUpdate: DateTime.now(),
                  ),
                );
            sentenceController.text = '';
            setState(() {
              _selectedIcon = null;
            });
          },
          child: Text(
            widget.isUpdate ? 'Actualizar' : 'Agregar',
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

class AlertDialogIconWidget extends StatelessWidget {
  const AlertDialogIconWidget({
    super.key,
    required this.mediaQuery,
    required this.callbackSelectedIcon,
  });

  final Size mediaQuery;
  final void Function(Map<String, Icon> selectedIcon) callbackSelectedIcon;

  List<Widget> showIcons(BuildContext context) {
    final personalIcons = Emojis().personalIcons;
    final List<Widget> listWidget = [];

    for (var map in personalIcons) {
      for (var entry in map.entries) {
        listWidget.add(
          GestureDetector(
            onTap: () {
              callbackSelectedIcon(map);
              Navigator.of(context).pop();
            },
            child: entry.value,
          ),
        );
      }
    }

    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: mediaQuery.width * 0.90,
        height: mediaQuery.height * 0.25,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 5,
          children: showIcons(context),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}
