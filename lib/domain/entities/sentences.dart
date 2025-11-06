import 'package:isar/isar.dart';

part 'sentences.g.dart';

@collection
class Sentences {
  Id? id = Isar.autoIncrement;
  String sentence;
  String? iconString;
  bool available; // si esta disponible
  bool isItem; //si es principal o no
  bool isSelected; // si esta selecionada solo para principal
  int? idPadre; //si es hijo o item se le agrega el id del padre
  bool isAsync;
  DateTime? isUpdate;

  Sentences({
    this.id,
    this.idPadre,
    this.iconString,
    required this.sentence,
    required this.isItem,
    required this.isAsync,
    this.isUpdate,
    this.isSelected = false,
    this.available = true,
  });
}
