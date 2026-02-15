// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class ImprovedVideoPlayer extends StatefulWidget {
  final String videoId;

  const ImprovedVideoPlayer({super.key, required this.videoId});

  @override
  State<ImprovedVideoPlayer> createState() => _ImprovedVideoPlayerState();
}

class _ImprovedVideoPlayerState extends State<ImprovedVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _isFullscreen = false;
  bool _showControls = true;
  Timer? _hideControlsTimer;
  double _playbackSpeed = 1.0;
  String? _errorMessage;

  final List<double> _speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _setPortraitMode();
  }

  void _setPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _setLandscapeMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );
  }

  Future<void> _initializeVideo() async {
    try {
      final url =
          'https://backend.avtotest-begzod.uz/api/v1/file/download/video/0038e23a-eace-4930-a91f-fe0d3d1ea6d6';
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));

      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });

      _controller!.addListener(_videoListener);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Video yuklashda xatolik yuz berdi';
        });
      }
    }
  }

  void _videoListener() {
    if (!mounted) return;
    setState(() {});

    if (_controller!.value.position >= _controller!.value.duration) {
      setState(() {
        _isPlaying = false;
        _showControls = true;
      });
      _hideControlsTimer?.cancel();
    }
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
        _showControls = true;
        _hideControlsTimer?.cancel();
      } else {
        _controller!.play();
        _isPlaying = true;
        _startHideTimer();
      }
    });
  }

  void _startHideTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleFullscreen() {
    setState(() {
      _isFullscreen = !_isFullscreen;
      if (_isFullscreen) {
        _setLandscapeMode();
      } else {
        _setPortraitMode();
      }
    });
  }

  void _skipTime(int seconds) {
    if (_controller == null) return;
    final currentPos = _controller!.value.position;
    final duration = _controller!.value.duration;
    final newPos = currentPos + Duration(seconds: seconds);

    if (newPos < Duration.zero) {
      _controller!.seekTo(Duration.zero);
    } else if (newPos > duration) {
      _controller!.seekTo(duration);
    } else {
      _controller!.seekTo(newPos);
    }

    setState(() => _showControls = true);
    _startHideTimer();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller?.removeListener(_videoListener);
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: GestureDetector(
          onTap: () {
            setState(() => _showControls = !_showControls);
            if (_showControls && _isPlaying) _startHideTimer();
          },
          child: Stack(
            children: [
              // Видео - занимает весь экран в fullscreen
              Positioned.fill(
                child: _isFullscreen
                    ? FittedBox(
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: _controller!.value.size.width,
                          height: _controller!.value.size.height,
                          child: VideoPlayer(_controller!),
                        ),
                      )
                    : Center(
                        child: AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        ),
                      ),
              ),

              // Интерфейс управления
              if (_showControls)
                Positioned.fill(
                  child: Container(
                    color: Colors.black38,
                    child: SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Верх: Кнопка назад
                          _buildTopBar(),

                          // Центр: Кнопки перемотки
                          _buildCenterControls(),

                          // Низ: Слайдер и настройки
                          _buildBottomPanel(),
                        ],
                      ),
                    ),
                  ),
                ),

              // Индикатор буферизации
              if (_controller!.value.isBuffering)
                Center(child: CircularProgressIndicator(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    // Уменьшенные размеры для fullscreen
    final topPadding = _isFullscreen ? 5.0 : 10.0;
    final leftPadding = _isFullscreen ? 8.0 : 10.0;
    final iconSize = _isFullscreen ? 22.0 : 24.0;

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: topPadding,
          left: leftPadding,
        ),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: iconSize),
          padding: EdgeInsets.all(_isFullscreen ? 6.0 : 8.0),
          constraints: BoxConstraints(
            minWidth: _isFullscreen ? 36 : 40,
            minHeight: _isFullscreen ? 36 : 40,
          ),
          onPressed: () {
            if (_isFullscreen) {
              _toggleFullscreen();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCenterControls() {
    // Компактные размеры для fullscreen
    final buttonSpacing = _isFullscreen ? 35.0 : 30.0;
    final smallButtonSize = _isFullscreen ? 24.0 : 28.0;
    final mainButtonSize = _isFullscreen ? 36.0 : 40.0;
    final smallPadding = _isFullscreen ? 8.0 : 10.0;
    final mainPadding = _isFullscreen ? 12.0 : 15.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircleButton(
          Icons.replay_5,
          () => _skipTime(-5),
          size: smallButtonSize,
          padding: smallPadding,
        ),
        SizedBox(width: buttonSpacing),
        _buildCircleButton(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          _togglePlayPause,
          size: mainButtonSize,
          padding: mainPadding,
        ),
        SizedBox(width: buttonSpacing),
        _buildCircleButton(
          Icons.forward_5,
          () => _skipTime(5),
          size: smallButtonSize,
          padding: smallPadding,
        ),
      ],
    );
  }

  Widget _buildCircleButton(
    IconData icon,
    VoidCallback onTap, {
    required double size,
    required double padding,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white24,
        ),
        child: Icon(icon, color: Colors.white, size: size),
      ),
    );
  }

  Widget _buildBottomPanel() {
    final position = _controller!.value.position;
    final duration = _controller!.value.duration;
    final progress = duration.inMilliseconds > 0
        ? position.inMilliseconds / duration.inMilliseconds
        : 0.0;

    // Уменьшенные размеры для fullscreen
    final horizontalPadding = _isFullscreen ? 12.0 : 16.0;
    final verticalPadding = _isFullscreen ? 4.0 : 10.0;
    final timeFontSize = _isFullscreen ? 11.0 : 12.0;
    final trackHeight = _isFullscreen ? 2.5 : 2.0;
    final thumbRadius = _isFullscreen ? 5.0 : 6.0;
    final volumeIconSize = _isFullscreen ? 20.0 : 24.0;
    final fullscreenIconSize = _isFullscreen ? 24.0 : 30.0;
    final speedFontSize = _isFullscreen ? 12.0 : 14.0;
    final iconButtonPadding = _isFullscreen ? 4.0 : 8.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black87, Colors.transparent],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Линия прогресса
          Row(
            children: [
              Text(
                _formatDuration(position),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: timeFontSize,
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: trackHeight,
                    thumbShape: RoundSliderThumbShape(
                      enabledThumbRadius: thumbRadius,
                    ),
                    overlayShape: RoundSliderOverlayShape(
                      overlayRadius: _isFullscreen ? 10.0 : 12.0,
                    ),
                    activeTrackColor: Colors.blueAccent,
                    inactiveTrackColor: Colors.white30,
                  ),
                  child: Slider(
                    value: progress.clamp(0.0, 1.0),
                    min: 0,
                    max: 1,
                    onChanged: (value) {
                      final newPosition = duration * value;
                      _controller!.seekTo(newPosition);
                    },
                  ),
                ),
              ),
              Text(
                _formatDuration(duration),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: timeFontSize,
                ),
              ),
            ],
          ),
          SizedBox(height: _isFullscreen ? 2.0 : 0),
          // Громкость, Скорость и Поворот
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isMuted ? Icons.volume_off : Icons.volume_up,
                  color: Colors.white,
                  size: volumeIconSize,
                ),
                padding: EdgeInsets.all(iconButtonPadding),
                constraints: BoxConstraints(
                  minWidth: _isFullscreen ? 32 : 40,
                  minHeight: _isFullscreen ? 32 : 40,
                ),
                onPressed: () {
                  setState(() {
                    _isMuted = !_isMuted;
                    _controller!.setVolume(_isMuted ? 0 : 1.0);
                  });
                },
              ),
              const Spacer(),
              // Скорость
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: _isFullscreen ? 6.0 : 8.0,
                  vertical: _isFullscreen ? 2.0 : 4.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: DropdownButton<double>(
                  value: _playbackSpeed,
                  dropdownColor: Colors.black87,
                  underline: const SizedBox(),
                  isDense: true,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                    size: _isFullscreen ? 16.0 : 18.0,
                  ),
                  items: _speedOptions
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(
                              '${s}x',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: speedFontSize,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (s) {
                    if (s != null) {
                      setState(() => _playbackSpeed = s);
                      _controller!.setPlaybackSpeed(s);
                    }
                  },
                ),
              ),
              SizedBox(width: _isFullscreen ? 8.0 : 15.0),
              // Кнопка ориентации
              IconButton(
                icon: Icon(
                  _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  size: fullscreenIconSize,
                ),
                padding: EdgeInsets.all(iconButtonPadding),
                constraints: BoxConstraints(
                  minWidth: _isFullscreen ? 32 : 40,
                  minHeight: _isFullscreen ? 32 : 40,
                ),
                onPressed: _toggleFullscreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
