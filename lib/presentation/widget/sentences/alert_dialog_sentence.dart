import 'package:englishkey/core/constants/emojis.dart';
import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/presentation/providers/senteces_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertDialogSentence extends ConsumerStatefulWidget {
  const AlertDialogSentence({super.key});
  @override
  ConsumerState<AlertDialogSentence> createState() =>
      _AlertDialogSentenceState();
}

class _AlertDialogSentenceState extends ConsumerState<AlertDialogSentence> {
  bool isError = false;
  final sentenceController = TextEditingController();
  Icon? _selectedIcon;

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
                              icon: Icon(
                                _selectedIcon!.icon,
                                color: _selectedIcon!.color,
                                size: 60,
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
            final String iconString =
                '${_selectedIcon!.icon!.codePoint}|${_selectedIcon!.icon!.fontFamily}|${_selectedIcon!.color!.toARGB32()}';

            final text = sentenceController.text.trim();
            if (text.isEmpty) {
              setState(() => isError = true);
              return;
            }
            ref
                .read(sentencesProvider.notifier)
                .createOrUpdate(
                  Sentences(
                    sentence: text,
                    isItem: false,
                    iconString: iconString,
                  ),
                );
            sentenceController.text = '';
            setState(() {
              _selectedIcon = null;
            });
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

class AlertDialogIconWidget extends StatelessWidget {
  const AlertDialogIconWidget({
    super.key,
    required this.mediaQuery,
    required this.callbackSelectedIcon,
  });

  final Size mediaQuery;
  final void Function(Icon selectedIcon) callbackSelectedIcon;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        width: mediaQuery.width * 0.90,
        height: mediaQuery.height * 0.25,
        child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 5,
          children:
              Emojis().personalIcons.map((value) {
                return GestureDetector(
                  onTap: () {
                    callbackSelectedIcon(value);
                    Navigator.of(context).pop();
                    //iconData, color
                  },
                  child: value,
                );
              }).toList(),
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
