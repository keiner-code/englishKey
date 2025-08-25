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
      selected:
          ref.read(lessonsProvider).videoSelected != null
              ? video.path == ref.read(lessonsProvider).videoSelected!.path
              : false,
    );
  }
}
