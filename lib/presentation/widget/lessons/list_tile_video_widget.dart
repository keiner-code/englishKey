import 'dart:io';

import 'package:englishkey/presentation/providers/lessons_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class ListTileVideoWidget extends ConsumerWidget {
  const ListTileVideoWidget({super.key, required this.video});
  final File video;

  Future<Duration?> getVideoDuration(String path) async {
    final controller = VideoPlayerController.file(File(path));
    await controller.initialize();
    final duration = controller.value.duration;
    await controller.dispose();
    return duration;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        ref.read(lessonsProvider.notifier).addVideoSelected(video);
        context.push('/video_player');
      },
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            'assets/images/video_image.png',
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
      title: Text(
        video.path.split('/').last,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(video.path.split('/')[video.path.split('/').length - 2]),
      trailing: FutureBuilder<Duration?>(
        future: getVideoDuration(video.path),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: 20,
              height: 20,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          if (snapshot.hasData && snapshot.data != null) {
            final duration = snapshot.data!;
            final minutes = duration.inMinutes
                .remainder(60)
                .toString()
                .padLeft(2, '0');
            final seconds = duration.inSeconds
                .remainder(60)
                .toString()
                .padLeft(2, '0');
            return Text('$minutes:$seconds', style: TextStyle(fontSize: 14));
          }
          return Text('--:--', style: TextStyle(fontSize: 14));
        },
      ),
    );
  }
}
