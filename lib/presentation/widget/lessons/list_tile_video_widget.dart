import 'dart:io';

import 'package:englishkey/presentation/providers/lessons_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ListTileVideoWidget extends ConsumerWidget {
  const ListTileVideoWidget({
    super.key,
    required this.video,
    this.showSubtitle = true,
  });
  final File video;
  final bool showSubtitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      onTap: () {
        final currentLocation = GoRouterState.of(context).uri.toString();
        ref.read(lessonsProvider.notifier).addVideoSelected(video);
        final videoId = DateTime.now().millisecondsSinceEpoch.toString();

        if (currentLocation == '/video_player') {
          context.replace('/video_player', extra: videoId);
          return;
        }
        context.push('/video_player', extra: videoId);
      },
      contentPadding: EdgeInsets.zero,
      leading: SizedBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FutureBuilder(
            future: ref
                .read(lessonsProvider.notifier)
                .generateThumbnail(video.path),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              return Image.file(File(snapshot.data!), fit: BoxFit.fitHeight);
            },
          ),
        ),
      ),
      title: Text(
        video.path.split('/').last,
        style: TextStyle(
          fontSize:
              showSubtitle
                  ? Theme.of(context).textTheme.titleSmall!.fontSize
                  : 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle:
          showSubtitle
              ? Text(video.path.split('/')[video.path.split('/').length - 2])
              : SizedBox(),
      trailing: FutureBuilder<Duration?>(
        future: ref.read(lessonsProvider.notifier).getVideoDuration(video.path),
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
            final hours = duration.inHours;
            final minutes = duration.inMinutes
                .remainder(60)
                .toString()
                .padLeft(2, '0');
            final seconds = duration.inSeconds
                .remainder(60)
                .toString()
                .padLeft(2, '0');

            final formatted =
                hours > 0
                    ? '${hours.toString().padLeft(2, '0')}:$minutes:$seconds'
                    : '$minutes:$seconds';

            return Text(formatted, style: TextStyle(fontSize: 14));
          }
          return Text('--:--', style: TextStyle(fontSize: 14));
        },
      ),
      selected:
          ref.read(lessonsProvider).videoSelected != null
              ? video.path == ref.read(lessonsProvider).videoSelected!.path
              : false,
    );
  }
}
