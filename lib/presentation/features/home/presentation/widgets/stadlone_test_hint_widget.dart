import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/features/home/presentation/bottom_sheet/question_hint_bottom_sheet.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';

class StandaloneTestHintWidget extends StatefulWidget {
  final QuestionModel question;
  final bool isTestScreen;

  const StandaloneTestHintWidget({
    super.key,
    required this.question,
    this.isTestScreen = false,
  });

  @override
  State<StandaloneTestHintWidget> createState() =>
      _StandaloneTestHintWidgetState();
}

class _StandaloneTestHintWidgetState extends State<StandaloneTestHintWidget> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentAudioId;
  bool _isPrepared = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentAudioId = widget.question.audioId;
  }

  @override
  void didUpdateWidget(covariant StandaloneTestHintWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.question.id != widget.question.id) {
      _player.stop();
      _isPrepared = false;
      _currentAudioId = widget.question.audioId;
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _startAudioLoad() async {
    if (_currentAudioId == null || _currentAudioId!.isEmpty) return;
    try {
      setState(() => _isLoading = true);
      // Здесь можно подгружать файл/ссылку. Для примера — локальный asset:
      await _player.setAsset("assets/audios/${_currentAudioId!}.mp3");
      setState(() {
        _isPrepared = true;
        _isLoading = false;
      });
      await _player.play();
    } catch (e) {
      debugPrint("Audio load error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _showTextHintModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) =>
          QuestionHintBottomSheet(question: widget.question.toString()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (widget.isTestScreen) const SizedBox(width: 32),
        _isPrepared ? _buildAudioControls() : _buildStartButton(),
        const Spacer(),
        FloatingActionButton(
          heroTag: "text-hint-${widget.question.id}",
          onPressed: _showTextHintModal,
          backgroundColor: AppColors.vividBlue,
          child: SvgPicture.asset(
            AppIcons.icHintText,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }

  Widget _buildStartButton() {
    return Visibility(
      visible: _currentAudioId != null && _currentAudioId!.isNotEmpty,
      child: FloatingActionButton(
        onPressed: _startAudioLoad,
        backgroundColor: AppColors.vividBlue,
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : SvgPicture.asset(
                AppIcons.icAudioPlayerPlay,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
      ),
    );
  }

  Widget _buildAudioControls() {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data?.playing ?? false;
        return FloatingActionButton(
          onPressed: () async {
            if (isPlaying) {
              await _player.pause();
            } else {
              await _player.play();
            }
          },
          backgroundColor: AppColors.vividBlue,
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
