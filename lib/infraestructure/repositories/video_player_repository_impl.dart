import 'package:englishkey/domain/datasources/video_player_datasource.dart';
import 'package:englishkey/domain/entities/directories.dart';
import 'package:englishkey/domain/entities/last_player.dart';
import 'package:englishkey/domain/repositories/video_player_repository.dart';

class VideoPlayerRepositoryImpl extends VideoPlayerRepository {
  final VideoPlayerDatasource datasource;

  VideoPlayerRepositoryImpl({required this.datasource});

  @override
  Future<Directories> addDirectoryOrUpdate({required Directories directory}) {
    return datasource.addDirectoryOrUpdate(directory: directory);
  }

  @override
  Future<LastPlayer> addVideoOrUpdate({required LastPlayer video}) {
    return datasource.addVideoOrUpdate(video: video);
  }

  @override
  Future<List<Directories>> listDirectories() {
    return datasource.listDirectories();
  }

  @override
  Future<List<LastPlayer>> listLastPlayer() {
    return datasource.listLastPlayer();
  }

  @override
  Future<bool> removeDirectory({required String id}) {
    return datasource.removeDirectory(id: id);
  }

  @override
  Future<bool> removeVideo({required String id}) {
    return datasource.removeVideo(id: id);
  }
}
