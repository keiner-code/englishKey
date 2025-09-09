import 'dart:io';

import 'package:englishkey/presentation/providers/lessons_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CurrentVideoWidget extends ConsumerWidget {
  const CurrentVideoWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonState = ref.watch(lessonsProvider);
    return GestureDetector(
      onTap: () {
        ref
            .read(lessonsProvider.notifier)
            .showVideoState(lessonState.lastPlayed.first);
        context.push('/video_player');
      },
      child: Container(
        width: double.infinity,
        height: 271.5,
        color: Colors.transparent,
        child:
            lessonState.lastPlayed.isNotEmpty
                ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(lessonState.lastPlayed.first.thumbnail),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 10,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.play_circle_outline,
                                size: 30,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              lessonState.lastPlayed.first.videoPath
                                  .split('/')
                                  .last
                                  .split('.')[1],
                              style: TextStyle(
                                fontSize:
                                    Theme.of(
                                      context,
                                    ).textTheme.titleSmall!.fontSize,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
                : Center(child: Text('Empieze Reproduciendo un video')),
      ),
    );
  }
}
