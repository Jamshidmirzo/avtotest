import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class QuestionVideoPlayer extends StatefulWidget {
  final String videoId;

  const QuestionVideoPlayer({super.key, required this.videoId});

  @override
  State<QuestionVideoPlayer> createState() => _QuestionVideoPlayerState();
}

class _QuestionVideoPlayerState extends State<QuestionVideoPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  double _currentPosition = 0;
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
          'https://backend.avtotest-begzod.uz/api/v1/file/download/video/${widget.videoId}';
      _controller = VideoPlayerController.networkUrl(Uri.parse(url));

      await _controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isInitialized = true;
      });

      _controller!.addListener(() {
        if (!mounted) return;
        setState(() {
          _currentPosition =
              _controller!.value.position.inMilliseconds.toDouble();
        });

        if (_controller!.value.position >= _controller!.value.duration) {
          setState(() {
            _isPlaying = false;
            _showControls = true;
          });
          _hideControlsTimer?.cancel();
        }
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Video yuklashda xatolik yuz berdi';
        });
      }
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
      if (mounted && _isPlaying) setState(() => _showControls = false);
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
    final newPos = _controller!.value.position + Duration(seconds: seconds);
    if (newPos < Duration.zero) {
      _controller!.seekTo(Duration.zero);
    } else if (newPos > _controller!.value.duration) {
      _controller!.seekTo(_controller!.value.duration);
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
    _controller?.dispose();
    _setPortraitMode();
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
      body: GestureDetector(
        onTap: () {
          setState(() => _showControls = !_showControls);
          if (_showControls && _isPlaying) _startHideTimer();
        },
        child: Stack(
          children: [
            // Video display
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

            // Controls
            if (_showControls)
              Positioned.fill(
                child: Container(
                  color: Colors.black38,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTopBar(),
                        _buildCenterControls(),
                        _buildBottomPanel(),
                      ],
                    ),
                  ),
                ),
              ),

            // Buffer indicator
            if (_controller!.value.isBuffering)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    final topPadding = _isFullscreen ? 5.0 : 10.0;
    final leftPadding = _isFullscreen ? 8.0 : 10.0;
    final iconSize = _isFullscreen ? 22.0 : 24.0;

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(top: topPadding, left: leftPadding),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: iconSize),
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
    final buttonSpacing = _isFullscreen ? 35.0 : 30.0;
    final smallButtonSize = _isFullscreen ? 24.0 : 28.0;
    final mainButtonSize = _isFullscreen ? 36.0 : 40.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCircleButton(Icons.replay_5, () => _skipTime(-5),
            size: smallButtonSize),
        SizedBox(width: buttonSpacing),
        _buildCircleButton(
            _isPlaying ? Icons.pause : Icons.play_arrow, _togglePlayPause,
            size: mainButtonSize),
        SizedBox(width: buttonSpacing),
        _buildCircleButton(Icons.forward_5, () => _skipTime(5),
            size: smallButtonSize),
      ],
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap,
      {required double size}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(_isFullscreen ? 12.0 : 15.0),
        decoration: const BoxDecoration(
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
          // Slider
          Row(
            children: [
              Text(_formatDuration(position),
                  style:
                      TextStyle(color: Colors.white, fontSize: timeFontSize)),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: trackHeight,
                    thumbShape:
                        RoundSliderThumbShape(enabledThumbRadius: thumbRadius),
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
              Text(_formatDuration(duration),
                  style:
                      TextStyle(color: Colors.white, fontSize: timeFontSize)),
            ],
          ),
          // Volume, Speed, Fullscreen
          Row(
            children: [
              IconButton(
                icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up,
                    color: Colors.white, size: volumeIconSize),
                onPressed: () {
                  setState(() {
                    _isMuted = !_isMuted;
                    _controller!.setVolume(_isMuted ? 0 : 1.0);
                  });
                },
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: DropdownButton<double>(
                  value: _playbackSpeed,
                  dropdownColor: Colors.black87,
                  underline: const SizedBox(),
                  isDense: true,
                  icon: Icon(Icons.arrow_drop_down,
                      color: Colors.white, size: speedFontSize),
                  items: _speedOptions
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text('${s}x',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: speedFontSize)),
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
              SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  _isFullscreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                  size: fullscreenIconSize,
                ),
                padding: EdgeInsets.all(iconButtonPadding),
                onPressed: _toggleFullscreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
