import 'dart:io';

import 'package:englishkey/domain/entities/directories.dart';
import 'package:englishkey/domain/entities/last_player.dart';
import 'package:englishkey/infraestructure/datasources/video_player_datasource_impl.dart';
import 'package:englishkey/infraestructure/repositories/video_player_repository_impl.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class LessonsState {
  final List<File> files;
  final List<Directory> directories;
  final String errorMessage;
  final File? videoSelected;
  final List<File>? subtitleFiles;
  final List<Map<String, File>> subtitles;
  final List<LastPlayer> lastPlayed;

  const LessonsState({
    required this.files,
    this.errorMessage = '',
    required this.directories,
    this.videoSelected,
    this.subtitleFiles,
    this.subtitles = const [],
    this.lastPlayed = const [],
  });

  LessonsState copyWith({
    List<File>? files,
    String? errorMessage,
    List<Directory>? directories,
    File? videoSelected,
    Directory? directorySelected,
    List<File>? subtitleFiles,
    List<Map<String, File>>? subtitles,
    List<LastPlayer>? lastPlayed,
  }) => LessonsState(
    files: files ?? this.files,
    errorMessage: errorMessage ?? this.errorMessage,
    directories: directories ?? this.directories,
    videoSelected: videoSelected ?? this.videoSelected,
    subtitleFiles: subtitleFiles ?? this.subtitleFiles,
    subtitles: subtitles ?? this.subtitles,
    lastPlayed: lastPlayed ?? this.lastPlayed,
  );
}

class LessonsNotifier extends StateNotifier<LessonsState> {
  VideoPlayerRepositoryImpl repository;
  LessonsNotifier({required this.repository})
    : super(LessonsState(files: [], directories: []));
  //final Logger _logger = Logger();
  final cache = DefaultCacheManager();

  void getAllDirectories() async {
    final response = await repository.listDirectories();
    state = state.copyWith(
      directories:
          response
              .map((directory) => Directory(directory.directoryPath!))
              .toList(),
    );
  }

  void getAllVideo() async {
    final response = await repository.listLastPlayer();
    state = state.copyWith(lastPlayed: response.reversed.toList());
  }

  Future<String> generateThumbnail(String path) async {
    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      quality: 75,
      timeMs: 10000,
    );

    if (thumbnailPath == null) return '';
    return thumbnailPath;
  }

  Future<Map<String, File>> isCacheImageThumbnail(String videoPath) async {
    final cacheKey = 'thumb_${videoPath.hashCode}';

    final cacheFile = await cache.getFileFromCache(cacheKey);
    if (cacheFile != null && await cacheFile.file.exists()) {
      return {cacheKey: cacheFile.file};
    }
    return {};
  }

  void addVideoSelected(File video) async {
    //Load video
    state = state.copyWith(videoSelected: video);

    //Load list subtitle
    if (state.subtitleFiles != null) {
      loadSubtitleList(video);
    }

    final saveVideoLength = state.lastPlayed.length;

    if (saveVideoLength < 7) {
      //generar thumbnail
      final thumbnailPath = await generateThumbnail(video.path);

      if (thumbnailPath.isEmpty) {
        //Cargar una imagen local que no se pudo generar la thumbnail
        return;
      }

      //add to local
      final newVideo = await repository.addVideoOrUpdate(
        video: LastPlayer(videoPath: video.path, thumbnail: thumbnailPath),
      );

      state = state.copyWith(
        lastPlayed: [...state.lastPlayed, newVideo].reversed.toList(),
      );

      //Eliminar el primero agregado y insertar el ultimo
    }
  }

  void loadSubtitleList(File video) {
    final List<Map<String, File>> subsFileVideo = [];

    final titleVideo = (video.path.split('/').last).split('.')[1];

    state.subtitleFiles!.forEach((file) {
      final titleFile = (file.path.split('/').last).split('.')[1];
      if (titleVideo.contains(titleFile)) {
        subsFileVideo.add({selectedKeyMap(file.path.split('/').last): file});
      }
    });

    state = state.copyWith(subtitles: subsFileVideo);
  }

  String selectedKeyMap(String title) {
    final lenguaje = title.split('.');

    switch (lenguaje[lenguaje.length - 2]) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'pt':
        return 'Portugues';
    }
    return '';
  }

  void loadDirectorySubtitles(Directory directory) {
    final directories =
        directory.listSync(recursive: false).whereType<Directory>().toList();

    final subs =
        directories
            .where((directory) => directory.path.split('/').last == 'Subs')
            .toList();

    if (subs.isEmpty) {
      state = state.copyWith(subtitleFiles: null);
      return;
    }

    final subtitles =
        subs[0].listSync(recursive: true).whereType<File>().toList();
    state = state.copyWith(subtitleFiles: subtitles);
  }

  void removeFiles() {
    state = state.copyWith(files: []);
  }

  void readVideoToFolder(Directory directory) {
    final videoFiles =
        directory
            .listSync(recursive: true)
            .whereType<File>()
            .where(
              (file) =>
                  file.path.toLowerCase().endsWith('.mp4') ||
                  file.path.toLowerCase().endsWith('.avi') ||
                  file.path.toLowerCase().endsWith('.mov') ||
                  file.path.toLowerCase().endsWith('.mkv'),
            )
            .toList();
    if (videoFiles.isEmpty) {
      state = state.copyWith(errorMessage: 'No se encontraron videos');
      return;
    }
    state = state.copyWith(files: videoFiles, errorMessage: '');
    loadDirectorySubtitles(directory);
  }

  void pickFolders(BuildContext context) async {
    final Directory rootPath = Directory('/storage/emulated/0');
    final folderPath = await FilesystemPicker.open(
      title: 'Selecciona una carpeta',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.folder,
      pickText: 'Seleccionar esta carpeta',
      folderIconColor: Colors.blue,
    );

    if (folderPath == null) {
      state = state.copyWith(errorMessage: 'Error al cargar las carpetas');
      return;
    }

    final dir = Directory(folderPath);
    final newDirectories =
        dir.listSync(recursive: false).whereType<Directory>().toList();

    if (newDirectories.isEmpty) return;

    final setDirectories = [
      ...{
        ...state.directories.map((d) => d.path),
        ...newDirectories.map((d) => d.path),
      },
    ].map((path) => Directory(path));

    saveDirectories(newDirectories);

    state = state.copyWith(
      directories: setDirectories.toList(),
      errorMessage: '',
    );
  }

  void saveDirectories(List<Directory> newdirestories) {
    newdirestories.map((newDirectory) async {
      final isPath = state.directories.where(
        (directory) => directory.path == newDirectory.path,
      );
      if (isPath.isEmpty) {
        await repository.addDirectoryOrUpdate(
          directory: Directories(directoryPath: newDirectory.path),
        );
      }
    }).toList();
  }
}

final lessonsProvider = StateNotifierProvider<LessonsNotifier, LessonsState>((
  ref,
) {
  return LessonsNotifier(
      repository: VideoPlayerRepositoryImpl(
        datasource: VideoPlayerDatasourceImpl(),
      ),
    )
    ..getAllDirectories()
    ..getAllVideo();
});
