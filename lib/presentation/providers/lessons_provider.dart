import 'dart:io';

import 'package:englishkey/domain/entities/directories.dart';
import 'package:englishkey/domain/entities/last_player.dart';
import 'package:englishkey/infraestructure/datasources/video_player_datasource_impl.dart';
import 'package:englishkey/infraestructure/repositories/video_player_repository_impl.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class LessonsState {
  final List<File> listVideoToDirectory;
  final List<Directory> directories;
  final String errorMessage;
  final File? videoSelected;
  final List<File>? subtitleFiles;
  final List<Map<String, File>> subtitles;
  final List<LastPlayer> lastPlayed;

  const LessonsState({
    required this.listVideoToDirectory,
    this.errorMessage = '',
    required this.directories,
    this.videoSelected,
    this.subtitleFiles,
    this.subtitles = const [],
    this.lastPlayed = const [],
  });

  LessonsState copyWith({
    List<File>? listVideoToDirectory,
    String? errorMessage,
    List<Directory>? directories,
    File? videoSelected,
    Directory? directorySelected,
    List<File>? subtitleFiles,
    List<Map<String, File>>? subtitles,
    List<LastPlayer>? lastPlayed,
  }) => LessonsState(
    listVideoToDirectory: listVideoToDirectory ?? this.listVideoToDirectory,
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
    : super(LessonsState(listVideoToDirectory: [], directories: []));

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

  Future<Duration?> getVideoDuration(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'duration_$path';

    final currentduration = prefs.getString(key);

    if (currentduration != null && currentduration.isNotEmpty) {
      final parts = currentduration.split(':');
      if (parts.length != 3) throw FormatException('Formato no válido');
      final secParts = parts[2].split('.');
      return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: int.parse(secParts[0]),
        microseconds:
            secParts.length > 1 ? int.parse(secParts[1].padRight(6, '0')) : 0,
      );
    }

    final controller = VideoPlayerController.file(File(path));
    await controller.initialize();
    final duration = controller.value.duration;
    await controller.dispose();

    await prefs.setString(key, duration.toString());

    return duration;
  }

  Future<String> generateThumbnail(String path) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'thumbnail_$path';

    final cached = prefs.getString(key);

    if (cached != null && File(cached).existsSync()) {
      return cached;
    }

    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: path,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.PNG,
      quality: 75,
      timeMs: 10000,
    );

    if (thumbnailPath == null) return '';
    await prefs.setString(key, thumbnailPath);
    return thumbnailPath;
  }

  bool isTheVideoSavedLocally(String path) {
    final videoExist = state.lastPlayed.firstWhere(
      (item) => item.videoPath == path,
    );

    if (videoExist.videoPath.isEmpty) return false;

    final index = state.lastPlayed.indexWhere(
      (lasplayer) => lasplayer.videoPath == path,
    );
    final listVideo = state.lastPlayed;
    final temp = listVideo[index];
    listVideo[index] = state.lastPlayed.first;
    listVideo.first = temp;
    state = state.copyWith(lastPlayed: listVideo);
    return true;
  }

  void showVideoState(File video) {
    state = state.copyWith(videoSelected: video);
    final directory = video.parent;
    readVideoToFolder(directory);

    if (state.subtitleFiles != null) {
      loadSubtitleList(video);
    }
  }

  void addVideoSelected(File video) async {
    //Load video
    state = state.copyWith(videoSelected: video);

    //Load list subtitle
    if (state.subtitleFiles != null) {
      loadSubtitleList(video);
    }

    //generar thumbnail
    final thumbnailPath = await generateThumbnail(video.path);

    //Validate video
    if (isTheVideoSavedLocally(video.path)) return;

    if (state.lastPlayed.length < 7) {
      //add to local
      final newVideo = await repository.addVideoOrUpdate(
        video: LastPlayer(videoPath: video.path, thumbnail: thumbnailPath),
      );

      state = state.copyWith(
        lastPlayed: [...state.lastPlayed, newVideo].reversed.toList(),
      );
      return;
    }
    //Controlar los duplicados y posicionarlos
    if (await deleteVideo()) {
      final newVideo = await repository.addVideoOrUpdate(
        video: LastPlayer(videoPath: video.path, thumbnail: thumbnailPath),
      );

      state = state.copyWith(
        lastPlayed: [...state.lastPlayed, newVideo].reversed.toList(),
      );
    }
  }

  Future<bool> deleteVideo() async {
    final firstid = state.lastPlayed.first.id;
    final isDelete = await repository.removeVideo(id: firstid.toString());
    state = state.copyWith(
      lastPlayed:
          state.lastPlayed.where((video) => video.id != firstid).toList(),
    );
    return isDelete;
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
    state = state.copyWith(listVideoToDirectory: []);
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
    state = state.copyWith(listVideoToDirectory: videoFiles, errorMessage: '');
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
