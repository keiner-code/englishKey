import 'dart:io';

import 'package:englishkey/config/permission/permission_config.dart';
import 'package:englishkey/presentation/providers/lessons_provider.dart';
import 'package:englishkey/presentation/widget/lessons/current_video_widget.dart';
import 'package:englishkey/presentation/widget/lessons/list_tile_folder_widget.dart';
import 'package:englishkey/presentation/widget/lessons/list_tile_video_widget.dart';
import 'package:englishkey/presentation/widget/lessons/selected_file_widget.dart';
import 'package:englishkey/presentation/widget/shared/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LessonsScreen extends ConsumerWidget {
  const LessonsScreen({super.key});

  void selectFolder(BuildContext context, WidgetRef ref) async {
    final granted = await PermissionConfig.askVideoPermission();

    if (granted) {
      ref.read(lessonsProvider.notifier).pickFolders(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme.titleSmall;
    final lessonState = ref.watch(lessonsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lessiones',
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
                        child: Image.asset('assets/images/user-avatar.png'),
                      ),
                    ),
                    Text('Hi Keiner Jesus'),
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
                          return Container(
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
                                      topVideo.videoPath
                                          .split('/')
                                          .last
                                          .split('.')[1],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                      : Center(child: Text('Empieze a reproducir')),
            ),

            lessonState.files.isEmpty
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
                  onTap: () => selectFolder(context, ref),
                  trailing:
                      lessonState.directories.isNotEmpty
                          ? Icon(Icons.add)
                          : SizedBox(),
                )
                : Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed:
                        () => ref.read(lessonsProvider.notifier).removeFiles(),
                    icon: Icon(Icons.arrow_back),
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
                      lessonState.files.isEmpty
                          ? lessonState.directories.map((directory) {
                            return ListTileFolderWidget(directory: directory);
                          }).toList()
                          : lessonState.files.map((video) {
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
