import 'package:isar/isar.dart';

part 'directories.g.dart';

@collection
class Directories {
  Id? id = Isar.autoIncrement;
  String? directoryPath;

  Directories({this.id, required this.directoryPath});
}
