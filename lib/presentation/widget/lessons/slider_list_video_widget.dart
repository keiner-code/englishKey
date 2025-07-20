import 'package:englishkey/presentation/providers/lessons_provider.dart';
import 'package:englishkey/presentation/widget/lessons/list_tile_video_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SliderListVideoWidget extends ConsumerWidget {
  const SliderListVideoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screen = MediaQuery.of(context).size;
    final listVideo = ref.watch(lessonsProvider).listVideoToDirectory;
    return Container(
      width: screen.width * 0.3,
      color: Theme.of(context).colorScheme.surface.withAlpha(180),
      child: ListView.builder(
        itemCount: listVideo.length,
        itemBuilder: (context, index) {
          return ListTileVideoWidget(
            video: listVideo[index],
            showSubtitle: false,
          );
        },
      ),
    );
  }
}
