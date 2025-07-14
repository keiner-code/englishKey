import 'package:englishkey/domain/entities/directories.dart';
import 'package:englishkey/domain/entities/last_player.dart';

abstract class VideoPlayerDatasource {
  Future<Directories> addDirectoryOrUpdate({required Directories directory});
  Future<LastPlayer> addVideoOrUpdate({required LastPlayer video});
  Future<List<Directories>> listDirectories();
  Future<List<LastPlayer>> listLastPlayer();
  Future<bool> removeDirectory({required String id});
  Future<bool> removeVideo({required String id});
}
