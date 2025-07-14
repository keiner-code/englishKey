import 'package:isar/isar.dart';

part 'last_player.g.dart';

@collection
class LastPlayer {
  Id? id = Isar.autoIncrement;
  String videoPath;
  String thumbnail;

  LastPlayer({this.id, required this.videoPath, required this.thumbnail});
}
