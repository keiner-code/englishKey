import 'dart:io';

import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LessonsState {
  final List<File> files;
  final List<Directory> directories;
  final String errorMessage;
  final File? videoSelected;

  const LessonsState({
    required this.files,
    this.errorMessage = '',
    required this.directories,
    this.videoSelected,
  });

  LessonsState copyWith({
    List<File>? files,
    String? errorMessage,
    List<Directory>? directories,
    File? videoSelected,
  }) => LessonsState(
    files: files ?? this.files,
    errorMessage: errorMessage ?? this.errorMessage,
    directories: directories ?? this.directories,
    videoSelected: videoSelected ?? this.videoSelected,
  );
}

class LessonsNotifier extends StateNotifier<LessonsState> {
  LessonsNotifier() : super(LessonsState(files: [], directories: []));
  //final Logger _logger = Logger()

  void addVideoSelected(File video) {
    state = state.copyWith(videoSelected: video);
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
  }

  void pickFolders(BuildContext context) async {
    final Directory rootPath = Directory('/storage/emulated/0');
    final folderPath = await FilesystemPicker.open(
      title: 'Selecciona una carpeta',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.folder,
      pickText: 'Seleccionar esta carpeta',
      folderIconColor: Colors.teal,
    );

    if (folderPath == null) {
      state = state.copyWith(errorMessage: 'Error al cargar las carpetas');
      return;
    }

    final dir = Directory(folderPath);
    final newDirectories =
        dir.listSync(recursive: false).whereType<Directory>().toList();

    if (newDirectories.isEmpty) return;

    state = state.copyWith(
      directories: [...state.directories, ...newDirectories],
      errorMessage: '',
    );
  }
}

final lessonsProvider = StateNotifierProvider<LessonsNotifier, LessonsState>((
  ref,
) {
  return LessonsNotifier();
});
