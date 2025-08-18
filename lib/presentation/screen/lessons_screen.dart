import 'dart:io';

import 'package:englishkey/config/permission/permission_config.dart';
import 'package:englishkey/domain/entities/last_player.dart';
import 'package:englishkey/presentation/providers/lessons_provider.dart';
import 'package:englishkey/presentation/providers/user_provider.dart';
import 'package:englishkey/presentation/widget/lessons/current_video_widget.dart';
import 'package:englishkey/presentation/widget/lessons/list_tile_folder_widget.dart';
import 'package:englishkey/presentation/widget/lessons/list_tile_video_widget.dart';
import 'package:englishkey/presentation/widget/lessons/selected_file_widget.dart';
import 'package:englishkey/presentation/widget/shared/custom_drawer.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LessonsScreen extends ConsumerStatefulWidget {
  const LessonsScreen({super.key});

  @override
  ConsumerState<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends ConsumerState<LessonsScreen> {
  void selectFolder(WidgetRef ref) async {
    final Directory rootPath = Directory('/storage/emulated/0');
    final folderPath = await FilesystemPicker.open(
      title: 'Selecciona una carpeta',
      context: context,
      rootDirectory: rootPath,
      fsType: FilesystemType.folder,
      pickText: 'Seleccionar esta carpeta',
      folderIconColor: Colors.blue,
    );

    if (!mounted) return;

    if (folderPath != null) {
      ref.read(lessonsProvider.notifier).pickFolders(folderPath);
    }
  }

  String titlefolder(File file) {
    final partFile = file.path.split('/');
    return partFile[partFile.length - 2];
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.titleSmall;
    final lessonState = ref.watch(lessonsProvider);
    final userState = ref.watch(userProvider).state;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Leciones',
          style: TextStyle(fontSize: textTheme!.fontSize),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            Row(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        child:
                            (userState.user != null &&
                                    userState.user!.photo != null)
                                ? Image.file(File(userState.user!.photo!))
                                : Icon(Icons.person, size: 30),
                      ),
                    ),
                    userState.user != null
                        ? Text('Hi ${userState.user!.firstName}')
                        : SizedBox(),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert, size: 25),
                ),
              ],
            ),
            SizedBox(height: 10),
            CurrentVideoWidget(),
            SizedBox(height: 20),
            Text(
              'Ultimos Videos Vistos',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 150,
              child:
                  lessonState.lastPlayed.isNotEmpty
                      ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: lessonState.lastPlayed.length,
                        itemBuilder: (context, index) {
                          final topVideo = lessonState.lastPlayed[index];
                          return CardVideoLessonWidget(
                            topVideo: topVideo,
                            ref: ref,
                          );
                        },
                      )
                      : Center(child: Text('Empieze a reproducir')),
            ),

            lessonState.listVideoToDirectory.isEmpty
                ? ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Archivos Selecionados',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleSmall!.fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () async {
                    final granted = await PermissionConfig.askVideoPermission();
                    if (!granted) return;
                    selectFolder(ref);
                  },
                  trailing:
                      lessonState.directories.isNotEmpty
                          ? Icon(Icons.add)
                          : SizedBox(),
                )
                : SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Center(
                        child: IconButton(
                          onPressed:
                              () =>
                                  ref
                                      .read(lessonsProvider.notifier)
                                      .removeFiles(),
                          icon: Icon(Icons.arrow_back),
                        ),
                      ),
                      Center(
                        child: Text(
                          titlefolder(lessonState.listVideoToDirectory.first),
                        ),
                      ),
                    ],
                  ),
                ),

            lessonState.errorMessage.isNotEmpty
                ? Center(
                  child: Text(
                    lessonState.errorMessage,
                    style: TextStyle(fontSize: 25, color: Colors.red),
                  ),
                )
                : lessonState.directories.isEmpty
                ? SelectedFileWidget(selectFolder: selectFolder)
                : Column(
                  children:
                      lessonState.listVideoToDirectory.isEmpty
                          ? lessonState.directories.map((directory) {
                            return ListTileFolderWidget(directory: directory);
                          }).toList()
                          : lessonState.listVideoToDirectory.map((video) {
                            return ListTileVideoWidget(video: video);
                          }).toList(),
                ),
          ],
        ),
      ),
      drawer: CustomDrawer(),
    );
  }
}

class CardVideoLessonWidget extends StatelessWidget {
  const CardVideoLessonWidget({
    super.key,
    required this.topVideo,
    required this.ref,
  });

  final LastPlayer topVideo;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ref
            .read(lessonsProvider.notifier)
            .showVideoState(File(topVideo.videoPath));
        context.push('/video_player');
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.file(File(topVideo.thumbnail)),
            ),
            Positioned(
              bottom: 10,
              left: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(20),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  topVideo.videoPath.split('/').last.split('.')[1],
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
