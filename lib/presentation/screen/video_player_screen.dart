import 'dart:async';
import 'package:englishkey/presentation/providers/lessons_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    final videoFile = ref.read(lessonsProvider).videoSelected;

    if (videoFile != null && videoFile.existsSync()) {
      _controller = VideoPlayerController.file(videoFile)
        ..initialize().then((_) {
          setState(() {});
          _controller!.play();
          _startHideControlsTimer();
        });
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _showControls = false;
      });
    });
  }

  void _onTapVideoArea() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  void _seekBy(Duration offset) {
    final currentPosition = _controller!.value.position;
    final newPosition = currentPosition + offset;
    final duration = _controller!.value.duration;

    final safePosition =
        newPosition < Duration.zero
            ? Duration.zero
            : (newPosition > duration ? duration : newPosition);

    _controller!.seekTo(safePosition);
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _controller?.dispose();
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
          _controller != null && _controller!.value.isInitialized
              ? GestureDetector(
                onTap: _onTapVideoArea,
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: SizedBox(
                          width: _controller!.value.size.width,
                          height: _controller!.value.size.height,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
                    ),
                    if (_showControls) ...[
                      // Botón de volver
                      Positioned(
                        top: 40,
                        left: 16,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            } else {
                              SystemNavigator.pop();
                            }
                          },
                        ),
                      ),

                      // Controles inferiores
                      Positioned(
                        bottom: 40,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: VideoProgressIndicator(
                                _controller!,
                                allowScrubbing: true,
                                colors: VideoProgressColors(
                                  playedColor: Colors.red,
                                  backgroundColor: Colors.grey,
                                  bufferedColor: Colors.white38,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.replay_10,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                  onPressed:
                                      () =>
                                          _seekBy(const Duration(seconds: -10)),
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  icon: Icon(
                                    _controller!.value.isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_filled,
                                    size: 48,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _controller!.value.isPlaying
                                          ? _controller!.pause()
                                          : _controller!.play();
                                    });
                                    _startHideControlsTimer();
                                  },
                                ),
                                const SizedBox(width: 20),
                                IconButton(
                                  icon: const Icon(
                                    Icons.forward_10,
                                    size: 36,
                                    color: Colors.white,
                                  ),
                                  onPressed:
                                      () =>
                                          _seekBy(const Duration(seconds: 10)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
