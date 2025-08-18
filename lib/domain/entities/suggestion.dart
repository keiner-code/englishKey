import 'package:isar/isar.dart';

part 'suggestion.g.dart';

@collection
class Suggestion {
  Id? id = Isar.autoIncrement;
  String? icon;
  String text;
  String? status;

  Suggestion({this.id, this.icon, required this.text, this.status});
}
