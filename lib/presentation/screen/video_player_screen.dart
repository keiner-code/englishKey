import 'dart:async';
import 'dart:io';
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

class Subtitle {
  final Duration start;
  final Duration end;
  final String text;

  Subtitle({required this.start, required this.end, required this.text});
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  VideoPlayerController? _controller;
  bool _showControls = true;
  Timer? _hideControlsTimer;
  Timer? _subtitleTimer;
  List<Subtitle> _subtitles = [];
  Subtitle? _currentSubtitle;

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
          _startSubtitleLoop();
        });

      final subtitlePath =
          ref.read(lessonsProvider).subtitles.first.values.first;
      _loadSubtitles(subtitlePath);
    }
  }

  Future<void> _loadSubtitles(File file) async {
    final content = await file.readAsString();
    setState(() {
      _subtitles = _parseSrt(content);
      _currentSubtitle = null; // Reiniciar subtítulo actual
    });
  }

  List<Subtitle> _parseSrt(String content) {
    final lines = content.split('\n');
    final subtitles = <Subtitle>[];
    int index = 0;

    while (index < lines.length) {
      if (lines[index].trim().isEmpty) {
        index++;
        continue;
      }
      index++;
      if (index >= lines.length) break;

      final times = lines[index].split(' --> ');
      final start = _parseDuration(times[0]);
      final end = _parseDuration(times[1]);
      index++;

      final buffer = StringBuffer();
      while (index < lines.length && lines[index].trim().isNotEmpty) {
        buffer.writeln(lines[index]);
        index++;
      }

      subtitles.add(
        Subtitle(start: start, end: end, text: buffer.toString().trim()),
      );
      index++;
    }

    return subtitles;
  }

  Duration _parseDuration(String time) {
    final parts = time.trim().split(RegExp(r'[:,]'));
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
      milliseconds: int.parse(parts[3]),
    );
  }

  void _startSubtitleLoop() {
    _subtitleTimer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      final position = _controller!.value.position;
      final current = _getCurrentSubtitle(position);

      if (current?.text != _currentSubtitle?.text) {
        setState(() {
          _currentSubtitle = current;
        });
      }
    });
  }

  Subtitle? _getCurrentSubtitle(Duration position) {
    for (final sub in _subtitles) {
      if (position >= sub.start && position <= sub.end) {
        return sub;
      }
    }
    return null;
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
    _subtitleTimer?.cancel();
    super.dispose();
  }

  List<PopupMenuItem<String>> subtitleList(List<Map<String, File>> subtitles) {
    return subtitles.map((item) {
      return PopupMenuItem<String>(
        height: 25,
        value: item.values.first.path,
        child: Text(item.keys.first),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final lessonState = ref.watch(lessonsProvider);
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
                    Positioned(
                      bottom: 60,
                      left: 16,
                      right: 16,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text(
                            _currentSubtitle?.text ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  Theme.of(
                                    context,
                                  ).textTheme.titleLarge!.fontSize,
                              foreground:
                                  Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 3
                                    ..color = Colors.black,
                            ),
                          ),
                          Text(
                            _currentSubtitle?.text ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  Theme.of(
                                    context,
                                  ).textTheme.titleLarge!.fontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_showControls) ...[
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
                      lessonState.subtitleFiles != null
                          ? Positioned(
                            top: 15,
                            right: 15,
                            child: PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.subtitles,
                                color: Colors.white,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 8,
                              offset: const Offset(0, 40),
                              onSelected: (String subtitlePath) async {
                                await _loadSubtitles(File(subtitlePath));
                              },
                              itemBuilder:
                                  (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                        ...subtitleList(lessonState.subtitles),
                                      ],
                            ),
                          )
                          : const SizedBox(),
                    ],
                  ],
                ),
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
