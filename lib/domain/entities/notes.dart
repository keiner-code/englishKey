import 'package:isar/isar.dart';

part 'notes.g.dart';

@collection
class Note {
  Id? id = Isar.autoIncrement;
  String title;
  String content;
  String priority;
  String? date;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.priority,
    this.date,
  });
}
