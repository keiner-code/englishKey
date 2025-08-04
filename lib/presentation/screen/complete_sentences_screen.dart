import 'dart:math';

import 'package:englishkey/core/constants/words_english.dart';
import 'package:englishkey/domain/entities/sentences.dart';
import 'package:englishkey/presentation/providers/senteces_provider.dart';
import 'package:englishkey/presentation/widget/sentences/alert_dialog_sentence_Item.dart';
import 'package:englishkey/presentation/widget/shared/custom_drawer.dart';
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
  //--------------

  Sentences? _selectedSentence;
  List<String> _sentenceParts = [];
  List<String> _wordsRemoves = [];
  List<List<String>> _enablesOptions = [];
  final Map<int, String?> selectedWords = {};

  void _selectedSentenceMethod(List<Sentences> sentences) {
    final randomNumber = Random().nextInt(sentences.length);
    setState(() {
      _selectedSentence = sentences[randomNumber];
    });
  }

  int _generateRandomValue(int length) {
    return Random().nextInt(length);
  }

  void _remplazeSentence(String sentence, int range) {
    final List<String> wordsRemoves = [];
    final List<String> sentenceParts = sentence.split(' ');

    for (var i = 0; i < range; i++) {
      final randowValue = _generateRandomValue(sentenceParts.length);
      final wordSelected = sentenceParts[randowValue];
      wordsRemoves.add(wordSelected);
      sentenceParts.replaceRange(randowValue, randowValue + 1, ['_']);
    }

    setState(() {
      _sentenceParts = sentenceParts;
      _wordsRemoves = wordsRemoves;
    });
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
    List<String> wordList = [];
    for (var i = 0; i < _wordsRemoves.length; i++) {
      for (var j = 0; j < 3; j++) {
        final wordEnglis =
            englishWords[_generateRandomValue(englishWords.length)];
        wordList.add(wordEnglis);
      }
      wordList[_generateRandomValue(wordList.length)] = _wordsRemoves[i];
      _enablesOptions.add(wordList);
      wordList = [];
    }
  }

  Widget _showSentence() {
    final String sentence = _selectedSentence!.sentence;
    final List<String> sentenceParts = sentence.split(' ');

    //Remplaza palabras aleatorias por _
    _optionSelectedRemplazeSentence(sentenceParts.length, sentence);

    //crea un listado de posibles palabras incluyendo las verdaderas
    if (_enablesOptions.isEmpty) {
      _createListOptionsWords();
    }

    return Wrap(
      spacing: 8,
      runSpacing: 12,
      children: [
        ..._sentenceParts.map((value) {
          if (value == '_') {
            return blankBox(selectedWords[0], 0);
          }
          return Text(value, style: TextStyle(fontSize: 20));
        }),
      ],
    );
  }

  //-------------

  /* void _submit() {
    final isCorrect =
        selected[0] == correctAnswers[0] &&
        selected[1] == correctAnswers[1] &&
        selected[2] == correctAnswers[2];

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(isCorrect ? '✅ Correct!' : '❌ Try Again'),
            content: Text(
              isCorrect
                  ? 'Well done!'
                  : 'One or more answers are incorrect. Try again.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  } */

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
      children: List.generate(_enablesOptions.length, (i) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children:
              _enablesOptions[i].map((word) {
                //!Quedo aqui debo validar el map este para que guarde las selecionadas
                final isSelected = selectedWords[i] == word;
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
                      selectedWords[i] = word;
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
      body: Center(
        heightFactor: 0.9,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [Text('Aciertos: 12'), Spacer(), Text('Fallas: 20')],
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
              const SizedBox(height: 40),
              ElevatedButtonWidget(
                submit: () {
                  _selectedSentenceMethod(sentenceState.items);
                  //_submit();
                },
                fontSize: textTheme.titleSmall!.fontSize,
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
                              builder: (context) => AlertDialogSentenceItem(),
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
                    IconData(int.parse(partIcon[0]), fontFamily: partIcon[1]),
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
  });
  final Function() submit;
  final double? fontSize;
  final bool isSelectedSentence;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: submit,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Theme.of(context).buttonTheme.colorScheme!.onSurfaceVariant,
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          isSelectedSentence ? 'Verificar' : 'Generar oracion'.toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: fontSize),
        ),
      ),
    );
  }
}
