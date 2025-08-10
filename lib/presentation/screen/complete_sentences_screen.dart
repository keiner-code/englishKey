import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:englishkey/core/constants/words_english.dart';
import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/presentation/providers/senteces_provider.dart';
import 'package:englishkey/presentation/widget/sentences/alert_dialog_sentence_Item.dart';
import 'package:englishkey/presentation/widget/shared/custom_drawer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompleteSentencesScreen extends ConsumerStatefulWidget {
  const CompleteSentencesScreen({super.key});

  @override
  ConsumerState<CompleteSentencesScreen> createState() =>
      _CompleteSentencesScreenState();
}

class _CompleteSentencesScreenState
    extends ConsumerState<CompleteSentencesScreen> {
  Sentences? _selectedSentence;
  List<String> _sentenceParts = [];
  List<String> _wordsRemoves = [];
  List<List<String>> _enablesOptions = [];
  final Map<int, String?> _selectedWords = {};
  int blankCounter = 0;
  late ConfettiController _confettiController;
  bool _failures = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void validateSentence(WidgetRef ref) async {
    final methods = ref.read(sentencesProvider.notifier);
    final state = ref.read(sentencesProvider);
    final isEqualsList = listEquals(
      List.from(_wordsRemoves)..sort(),
      List.from(_selectedWords.values)..sort(),
    );
    if (!isEqualsList) {
      methods.addFailures();
      setState(() {
        _failures = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _failures = false;
      });
      return;
    }
    _confettiController.play();
    methods.addSuccesses();
    await Future.delayed(const Duration(seconds: 2));
    _selectedSentenceMethod(state.items);
  }

  void _selectedSentenceMethod(List<Sentences> sentences) {
    if (sentences.isEmpty) return;
    final randomNumber = Random().nextInt(sentences.length);
    final sentence = sentences[randomNumber].sentence;

    setState(() {
      _selectedSentence = sentences[randomNumber];
      _sentenceParts = [];
      _wordsRemoves = [];
      _enablesOptions = [];
      _selectedWords.clear();

      _optionSelectedRemplazeSentence(sentence.split(' ').length, sentence);
      _createListOptionsWords();
    });
  }

  int _generateRandomValue(int length) {
    return Random().nextInt(length);
  }

  void _remplazeSentence(String sentence, int range) {
    final List<String> sentenceParts = sentence.split(' ');
    final usedIndexes = <int>{};

    for (var i = 0; i < range; i++) {
      int randowValue;
      do {
        randowValue = _generateRandomValue(sentenceParts.length);
      } while (usedIndexes.contains(randowValue));
      usedIndexes.add(randowValue);
    }

    final sortedIndexes = usedIndexes.toList()..sort();

    final wordsRemoves = <String>[];
    for (var idx in sortedIndexes) {
      wordsRemoves.add(sentenceParts[idx]);
      sentenceParts[idx] = '_';
    }

    _sentenceParts = sentenceParts;
    _wordsRemoves = wordsRemoves;
  }

  void _optionSelectedRemplazeSentence(int sentencesLength, String sentence) {
    switch (sentencesLength) {
      case 3:
        _remplazeSentence(sentence, 1);
        break;
      case 4:
        _remplazeSentence(sentence, 2);
        break;
      case 5:
        _remplazeSentence(sentence, 2);
        break;
      case 6:
        _remplazeSentence(sentence, 3);
        break;
      case 7:
        _remplazeSentence(sentence, 3);
        break;
      case 8:
        _remplazeSentence(sentence, 4);
        break;
      case 9:
        _remplazeSentence(sentence, 4);
        break;
      case 10:
        _remplazeSentence(sentence, 5);
        break;
      case 11:
        _remplazeSentence(sentence, 6);
        break;
    }
  }

  void _createListOptionsWords() {
    _enablesOptions = [];
    for (var i = 0; i < _wordsRemoves.length; i++) {
      List<String> wordList = [];
      for (var j = 0; j < 3; j++) {
        final wordEnglis =
            englishWords[_generateRandomValue(englishWords.length)];
        wordList.add(wordEnglis);
      }
      // Aseguramos que la palabra correcta esté entre las opciones
      wordList[_generateRandomValue(wordList.length)] = _wordsRemoves[i];
      _enablesOptions.add(wordList);
    }
  }

  Widget _showSentence() {
    blankCounter = 0;
    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: [
        ..._sentenceParts.map((value) {
          if (value == '_') {
            final widget = blankBox(_selectedWords[blankCounter], blankCounter);
            blankCounter++;
            return widget;
          }
          return Text(value, style: TextStyle(fontSize: 20));
        }),
      ],
    );
  }

  Widget blankBox(String? word, int index) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        word ?? "______",
        style: TextStyle(
          fontSize: 20,
          color: word == null ? Colors.grey : textTheme.titleSmall!.color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget buildOptions() {
    final themeText = Theme.of(context).textTheme;
    return Column(
      spacing: 10,
      children: List.generate(_enablesOptions.length, (blankIdx) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children:
              _enablesOptions[blankIdx].map((word) {
                final isSelected = _selectedWords[blankIdx] == word;
                return ChoiceChip(
                  label: Text(
                    word,
                    style: TextStyle(
                      fontSize: themeText.titleSmall!.fontSize,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedWords[blankIdx] = word;
                    });
                  },
                  selectedColor: Colors.transparent,
                  checkmarkColor: Colors.blueAccent,
                  labelStyle: TextStyle(
                    color:
                        isSelected
                            ? Colors.blueAccent
                            : themeText.titleSmall!.color,
                  ),
                );
              }).toList(),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final sentenceState = ref.watch(sentencesProvider);
    final sentenceMethods = ref.read(sentencesProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text('Completa las oracionés', style: textTheme.titleSmall),
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
        actions: [
          IconButton(
            onPressed:
                () => showDialog(
                  context: context,
                  builder: (context) => AlertDialogSentenceItem(),
                ),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            heightFactor: 0.9,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('Aciertos: ${sentenceState.successes}'),
                      Spacer(),
                      Text('Fallas: ${sentenceState.failures}'),
                    ],
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Toca la palabra correcta para completar la oración',
                    style: TextStyle(fontSize: textTheme.titleSmall!.fontSize),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  _selectedSentence != null ? _showSentence() : SizedBox(),
                  const SizedBox(height: 30),
                  buildOptions(),
                  const SizedBox(height: 20),
                  _failures
                      ? Text(
                        '😭 Respuesta Incorrecta',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall!.fontSize,
                        ),
                      )
                      : SizedBox(height: 26),
                  const SizedBox(height: 10),
                  (_selectedWords.length == blankCounter &&
                          _wordsRemoves.isNotEmpty)
                      ? ElevatedButtonWidget(
                        submit: () => validateSentence(ref),
                        isSelectedSentence: true,
                        fontSize: textTheme.titleSmall!.fontSize,
                        isEnabled:
                            sentenceState.sentences.isNotEmpty &&
                            sentenceState.items.isNotEmpty,
                      )
                      : ElevatedButtonWidget(
                        submit: () {
                          _selectedSentenceMethod(sentenceState.items);
                        },
                        fontSize: textTheme.titleSmall!.fontSize,
                        isEnabled:
                            sentenceState.sentences.isNotEmpty &&
                            sentenceState.items.isNotEmpty,
                      ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        sentenceState.sentences.isNotEmpty
                            ? sentenceState.sentences.length == 1
                                ? 'Escoja el tema'
                                : 'Escoja los temas'
                            : 'Agregar los temas',
                        style: textTheme.titleSmall,
                      ),
                      Spacer(),
                      sentenceState.sentences.isEmpty
                          ? IconButton(
                            onPressed:
                                () => showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialogSentenceItem(),
                                ),
                            icon: Icon(Icons.add),
                          )
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(height: 10),
                  ...sentenceState.sentences.map((item) {
                    Icon? leadingIcon;
                    final partIcon = item.iconString?.split('|');

                    if (partIcon != null) {
                      leadingIcon = Icon(
                        IconData(
                          int.parse(partIcon[0]),
                          fontFamily: partIcon[1],
                        ),
                        color: Color(int.parse(partIcon[2])),
                        size: 30,
                      );
                    }

                    return ListTile(
                      title: Text(item.sentence),
                      selected: item.isSelected,
                      selectedColor: Colors.lightBlue,
                      leading: leadingIcon,
                      trailing: Icon(Icons.check),
                      onTap: () {
                        sentenceMethods.createOrUpdate(
                          Sentences(
                            sentence: item.sentence,
                            isItem: false,
                            id: item.id,
                            isSelected: !item.isSelected,
                            available: true,
                            iconString: item.iconString,
                          ),
                        );
                        sentenceMethods.loadItemsFromMainSentence(
                          item.id!,
                          !item.isSelected,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              numberOfParticles: 40,
              colors: [
                Colors.blue,
                Colors.red,
                Colors.green,
                Colors.purple,
                Colors.orange,
              ],
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
    );
  }
}

class ElevatedButtonWidget extends StatelessWidget {
  const ElevatedButtonWidget({
    super.key,
    required this.submit,
    this.fontSize,
    this.isSelectedSentence = false,
    this.isEnabled = true,
  });
  final Function() submit;
  final double? fontSize;
  final bool isSelectedSentence;
  final bool isEnabled;
  @override
  Widget build(BuildContext context) {
    final btnTheme = Theme.of(context).buttonTheme;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? submit : () {},
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isEnabled
                  ? isSelectedSentence
                      ? btnTheme.colorScheme!.primary
                      : btnTheme.colorScheme!.onSurfaceVariant
                  : Colors.grey[400],
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isSelectedSentence
              ? 'Verificar'.toUpperCase()
              : 'Generar oracion'.toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
      ),
    );
  }
}
