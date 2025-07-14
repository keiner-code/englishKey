import 'package:englishkey/domain/datasources/video_player_datasource.dart';
import 'package:englishkey/domain/entities/directories.dart';
import 'package:englishkey/domain/entities/last_player.dart';
import 'package:englishkey/infraestructure/db/isar_database.dart';
import 'package:isar/isar.dart';

class VideoPlayerDatasourceImpl extends VideoPlayerDatasource {
  late Future<Isar> dbIsar;

  VideoPlayerDatasourceImpl() {
    dbIsar = IsarDatabase.openDB();
  }

  @override
  Future<Directories> addDirectoryOrUpdate({
    required Directories directory,
  }) async {
    try {
      final db = await dbIsar;
      final id = await db.writeTxn(
        () async => await db.directories.put(directory),
      );

      if (directory.id != null) return directory;

      final newDirectory = await db.directories.get(id);
      return newDirectory!;
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<LastPlayer> addVideoOrUpdate({required LastPlayer video}) async {
    try {
      final db = await dbIsar;
      final id = await db.writeTxn(() async => await db.lastPlayers.put(video));

      if (video.id != null) return video;

      final newVideo = await db.lastPlayers.get(id);
      return newVideo!;
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<List<Directories>> listDirectories() async {
    try {
      final db = await dbIsar;
      return await db.directories.where().findAll();
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<List<LastPlayer>> listLastPlayer() async {
    try {
      final db = await dbIsar;
      return await db.lastPlayers.where().findAll();
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<bool> removeDirectory({required String id}) async {
    final db = await dbIsar;
    try {
      return await db.writeTxn(
        () async => await db.directories.delete(int.parse(id)),
      );
    } catch (e) {
      throw Exception('$e');
    }
  }

  @override
  Future<bool> removeVideo({required String id}) async {
    final db = await dbIsar;
    try {
      return await db.writeTxn(
        () async => await db.lastPlayers.delete(int.parse(id)),
      );
    } catch (e) {
      throw Exception('$e');
    }
  }
}
