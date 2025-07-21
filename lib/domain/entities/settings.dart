import 'package:isar/isar.dart';

part 'settings.g.dart';

@collection
class Settings {
  Id? id = Isar.autoIncrement;
  bool notifications;
  bool darkMode;
  String sharedApp;
  String contact;

  Settings({
    this.id,
    required this.notifications,
    required this.darkMode,
    required this.sharedApp,
    required this.contact,
  });
}
