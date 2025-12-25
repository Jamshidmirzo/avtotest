import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;

class VideoEditorScreen extends StatefulWidget {
  const VideoEditorScreen({Key? key}) : super(key: key);

  @override
  State<VideoEditorScreen> createState() => _VideoEditorScreenState();
}

class _VideoEditorScreenState extends State<VideoEditorScreen>
    with TickerProviderStateMixin {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  double _currentPosition = 0;
  double _volume = 1.0;
  bool _isMuted = false;
  int _lastTapTime = 0;
  String? _errorMessage;
  bool _isVertical = false;
  bool _showControls = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _fadeController.forward();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://backend.avtotest-begzod.uz/api/v1/file/download/video/0038e23a-eace-4930-a91f-fe0d3d1ea6d6',
        ),
      );

      await _controller!.initialize();

      setState(() {
        _isInitialized = true;
      });

      _controller!.addListener(() {
        if (mounted) {
          setState(() {
            _currentPosition =
                _controller!.value.position.inMilliseconds.toDouble();
          });
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ошибка загрузки видео: $e';
      });
    }
  }

  void _handleVideoTap() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final timeSinceLastTap = now - _lastTapTime;

    if (timeSinceLastTap < 300 && timeSinceLastTap > 0) {
      if (_controller != null) {
        final newPosition =
            _controller!.value.position + const Duration(seconds: 1);
        if (newPosition < _controller!.value.duration) {
          _controller!.seekTo(newPosition);
        }
      }
    } else {
      _togglePlayPause();
    }

    setState(() {
      _showControls = true;
    });

    _lastTapTime = now;
  }

  void _togglePlayPause() {
    if (_controller == null) return;

    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
      } else {
        _controller!.play();
        _isPlaying = true;
      }
    });
  }

  void _toggleOrientation() {
    setState(() {
      _isVertical = !_isVertical;
    });
  }

  void _skipTime(int seconds) {
    if (_controller == null) return;

    final currentPos = _controller!.value.position;
    final newPos = currentPos + Duration(seconds: seconds);

    if (newPos < Duration.zero) {
      _controller!.seekTo(Duration.zero);
    } else if (newPos > _controller!.value.duration) {
      _controller!.seekTo(_controller!.value.duration);
    } else {
      _controller!.seekTo(newPos);
    }
  }

  void _toggleMute() {
    if (_controller == null) return;

    setState(() {
      _isMuted = !_isMuted;
      _controller!.setVolume(_isMuted ? 0 : _volume);
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller?.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: SafeArea(
        child: _errorMessage != null
            ? Center(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline,
                          size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red[300], fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            : _isInitialized && _controller != null
                ? FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        // Шапка
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF1E1E2E),
                                const Color(0xFF1E1E2E).withOpacity(0.8),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF6C63FF),
                                          Color(0xFF5A52D5)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.video_library,
                                        color: Colors.white, size: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Video Editor',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFF6C63FF).withOpacity(0.2),
                                      const Color(0xFF5A52D5).withOpacity(0.2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFF6C63FF)
                                        .withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    _isVertical
                                        ? Icons.stay_current_portrait
                                        : Icons.stay_current_landscape,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                  onPressed: _toggleOrientation,
                                  tooltip: _isVertical
                                      ? 'Горизонтально'
                                      : 'Вертикально',
                                ),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 900),
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6C63FF)
                                          .withOpacity(0.2),
                                      blurRadius: 30,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFF1E1E2E),
                                          const Color(0xFF1A1A2E),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        // Видео плеер
                                        AnimatedContainer(
                                          duration:
                                              const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: Transform.rotate(
                                              angle:
                                                  _isVertical ? math.pi / 2 : 0,
                                              child: AspectRatio(
                                                aspectRatio: _isVertical
                                                    ? 1 /
                                                        _controller!
                                                            .value.aspectRatio
                                                    : _controller!
                                                        .value.aspectRatio,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                            blurRadius: 20,
                                                          ),
                                                        ],
                                                      ),
                                                      child: GestureDetector(
                                                        onTap: _handleVideoTap,
                                                        child: VideoPlayer(
                                                            _controller!),
                                                      ),
                                                    ),
                                                    // Индикатор двойного тапа
                                                    Positioned(
                                                      top: 16,
                                                      right: 16,
                                                      child: Transform.rotate(
                                                        angle: _isVertical
                                                            ? -math.pi / 2
                                                            : 0,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 16,
                                                            vertical: 8,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xFF6C63FF),
                                                                Color(
                                                                    0xFF5A52D5)
                                                              ],
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: const Color(
                                                                        0xFF6C63FF)
                                                                    .withOpacity(
                                                                        0.4),
                                                                blurRadius: 10,
                                                                spreadRadius: 2,
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: const [
                                                              Icon(
                                                                  Icons
                                                                      .touch_app,
                                                                  size: 16,
                                                                  color: Colors
                                                                      .white),
                                                              SizedBox(
                                                                  width: 6),
                                                              Text(
                                                                'Двойной тап: +1 сек',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 24),

                                        // Контролы
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                const Color(0xFF252538)
                                                    .withOpacity(0.5),
                                                const Color(0xFF1E1E2E)
                                                    .withOpacity(0.5),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.white
                                                  .withOpacity(0.05),
                                              width: 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              // Прогресс-бар
                                              Stack(
                                                children: [
                                                  Container(
                                                    height: 6,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 6,
                                                    width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width *
                                                        (_currentPosition /
                                                            _controller!
                                                                .value
                                                                .duration
                                                                .inMilliseconds
                                                                .toDouble()),
                                                    decoration: BoxDecoration(
                                                      gradient:
                                                          const LinearGradient(
                                                        colors: [
                                                          Color(0xFF6C63FF),
                                                          Color(0xFF5A52D5)
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: const Color(
                                                                  0xFF6C63FF)
                                                              .withOpacity(0.5),
                                                          blurRadius: 8,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SliderTheme(
                                                    data:
                                                        SliderTheme.of(context)
                                                            .copyWith(
                                                      trackHeight: 6,
                                                      thumbShape:
                                                          const RoundSliderThumbShape(
                                                        enabledThumbRadius: 10,
                                                      ),
                                                      overlayShape:
                                                          const RoundSliderOverlayShape(
                                                        overlayRadius: 20,
                                                      ),
                                                      activeTrackColor:
                                                          Colors.transparent,
                                                      inactiveTrackColor:
                                                          Colors.transparent,
                                                      thumbColor: Colors.white,
                                                      overlayColor: const Color(
                                                              0xFF6C63FF)
                                                          .withOpacity(0.3),
                                                    ),
                                                    child: Slider(
                                                      value: _currentPosition,
                                                      min: 0,
                                                      max: _controller!
                                                          .value
                                                          .duration
                                                          .inMilliseconds
                                                          .toDouble(),
                                                      onChanged: (value) {
                                                        setState(() {
                                                          _currentPosition =
                                                              value;
                                                        });
                                                        _controller!.seekTo(
                                                          Duration(
                                                              milliseconds:
                                                                  value
                                                                      .toInt()),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 12),

                                              // Время
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      _formatDuration(
                                                          _controller!
                                                              .value.position),
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    Text(
                                                      _formatDuration(
                                                          _controller!
                                                              .value.duration),
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(height: 24),

                                              // Кнопки управления
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      _buildControlButton(
                                                        Icons.replay_5,
                                                        () => _skipTime(-5),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      _buildPlayButton(),
                                                      const SizedBox(width: 12),
                                                      _buildControlButton(
                                                        Icons.forward_5,
                                                        () => _skipTime(5),
                                                      ),
                                                    ],
                                                  ),

                                                  // Громкость
                                                ],
                                              ),
                                              Center(
                                                child: Row(
                                                  children: [
                                                    _buildControlButton(
                                                      _isMuted
                                                          ? Icons.volume_off
                                                          : Icons.volume_up,
                                                      _toggleMute,
                                                      size: 36,
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Container(
                                                      width: 100,
                                                      child: SliderTheme(
                                                        data: SliderTheme.of(
                                                                context)
                                                            .copyWith(
                                                          trackHeight: 4,
                                                          thumbShape:
                                                              const RoundSliderThumbShape(
                                                            enabledThumbRadius:
                                                                6,
                                                          ),
                                                          activeTrackColor:
                                                              const Color(
                                                                  0xFF6C63FF),
                                                          inactiveTrackColor:
                                                              Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.2),
                                                          thumbColor:
                                                              Colors.white,
                                                        ),
                                                        child: Slider(
                                                          value: _isMuted
                                                              ? 0
                                                              : _volume,
                                                          min: 0,
                                                          max: 1,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _volume = value;
                                                              _isMuted = false;
                                                              _controller!
                                                                  .setVolume(
                                                                      value);
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF6C63FF).withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Загрузка видео...',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed,
      {double size = 40}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(icon, size: size * 0.6),
        color: Colors.white,
        iconSize: size,
        onPressed: onPressed,
        padding: EdgeInsets.all(size * 0.2),
      ),
    );
  }

  Widget _buildPlayButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF5A52D5)],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.5),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          size: 36,
        ),
        color: Colors.white,
        iconSize: 56,
        onPressed: _togglePlayPause,
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
