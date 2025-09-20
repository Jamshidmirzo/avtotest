import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/data/datasource/preference/device_preferences.dart';
import 'package:avtotest/data/datasource/preference/settings_preferences.dart';
import 'package:avtotest/data/datasource/preference/subscription_preferences.dart';
import 'package:avtotest/data/datasource/preference/user_preferences.dart';
import 'package:avtotest/presentation/features/home/data/model/answer_model.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/bottom_sheet/premium_bottom_sheet.dart';
import 'package:avtotest/presentation/features/home/presentation/bottom_sheet/question_hint_bottom_sheet.dart';
import 'package:avtotest/presentation/utils/bloc_context_extensions.dart';
import 'package:avtotest/presentation/utils/context_message_extensions.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';

class TestHintWidget extends StatefulWidget {
  final bool isTestScreen;
  final QuestionModel question;
  final DevicePreferences devicePreferences;
  final SettingsPreferences settingsPreferences;
  final SubscriptionPreferences subscriptionPreferences;
  final UserPreferences userPreferences;

  const TestHintWidget(
    this.question, {
    super.key,
    required this.devicePreferences,
    required this.settingsPreferences,
    required this.subscriptionPreferences,
    required this.userPreferences,
    required this.isTestScreen,
  });

  @override
  State<TestHintWidget> createState() => _TestHintWidgetState();
}

class _TestHintWidgetState extends State<TestHintWidget> {
  final AudioPlayer _player = AudioPlayer();

  SubscriptionPreferences? _subscriptionPreferences;
  String? _currentAudioId;
  bool _isLoading = false;
  bool _isPrepared = false;

  @override
  void initState() {
    super.initState();
    _subscriptionPreferences = widget.subscriptionPreferences;
    _initializeAudio();
  }

  @override
  void didUpdateWidget(TestHintWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Stop audio when question changes
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

  void _initializeAudio() {
    if (_currentAudioId != widget.question.audioId) {
      _player.stop();
      _isPrepared = false;
      _currentAudioId = widget.question.audioId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    return Row(
      children: [
        widget.isTestScreen ? const SizedBox(width: 32) : SizedBox.shrink(),
        if (langCode != 'ru')
          (_isPrepared
              ? _buildAudioControls(context)
              : _buildStartButton(context)),
        const Spacer(),
        _buildTextHintButton(context),
        const SizedBox(width: 0),
      ],
    );
  }

  Widget _buildTextHintButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: "Hero",
      onPressed: _showTextHintModal,
      backgroundColor: AppColors.vividBlue,
      child: SvgPicture.asset(
        AppIcons.icHintText,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
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
                colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
              ),
      ),
    );
  }

  Widget _buildAudioControls(BuildContext context) {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;
        final processingState = playerState?.processingState;
        final isBuffering = processingState == ProcessingState.buffering ||
            processingState == ProcessingState.loading;
        if (processingState == ProcessingState.completed ||
            processingState == ProcessingState.idle) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && _isPrepared)
              setState(() {
                _isPrepared = false;
              });
          });
        }
        return StreamBuilder<Duration?>(
          stream: _player.durationStream,
          builder: (context, durationSnapshot) {
            final duration = durationSnapshot.data ?? Duration.zero;
            return StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (context, positionSnapshot) {
                final position = positionSnapshot.data ?? Duration.zero;
                double progress = 0;
                if (duration.inMilliseconds > 0) {
                  progress = position.inMilliseconds / duration.inMilliseconds;
                  if (progress > 1) progress = 1;
                }
                return FloatingActionButton(
                  onPressed: isBuffering
                      ? null
                      : () async {
                          if (isPlaying) {
                            await _player.pause();
                          } else {
                            await _player.play();
                          }
                        },
                  backgroundColor: AppColors.vividBlue,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: isBuffering ? null : progress,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.vividBlue),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      SvgPicture.asset(
                        isPlaying
                            ? AppIcons.icAudioPlayerPause
                            : AppIcons.icAudioPlayerPlay,
                        colorFilter:
                            ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showTextHintModal() {
    final lang = context.locale.languageCode;
    debugPrint('>>> showTextHintModal for question ${widget.question.id}');

    try {
      // Получаем bloc локально (чтобы было явнее)
      final bloc = context.read<QuestionsSolveBloc>();
      debugPrint('>>> QuestionsSolveBloc found: $bloc');

      bloc.add(GetCorrectAnswerEvent(onSuccess: (AnswerModel? answerModel) {
        debugPrint('>>> GetCorrectAnswerEvent.onSuccess: $answerModel');

        if (!mounted) {
          debugPrint('>>> widget unmounted, abort');
          return;
        }

        if (answerModel == null) {
          debugPrint('>>> answerModel == null — показываем SnackBar');
          context.showErrorSnackBar("Подсказка недоступна");
          return;
        }

        try {
          showModalBottomSheet(
            useRootNavigator: true,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            context: context,
            builder: (ctx) {
              debugPrint('>>> building QuestionHintBottomSheet');
              return QuestionHintBottomSheet(
                question: MyFunctions.getQuestionDescription(
                  questionModel: widget.question,
                  lang: lang,
                ),
              );
            },
          );
        } catch (e, s) {
          debugPrint('>>> showModalBottomSheet error: $e\n$s');
        }
      }));
    } catch (e, s) {
      debugPrint('>>> _showTextHintModal outer error: $e\n$s');
      context.showErrorSnackBar("Ошибка при открытии подсказки");
    }
  }

  Future<void> _startAudioLoad() async {
    if (_subscriptionPreferences?.cantPlayAudio ?? false) {
      debugPrint("Audio playing not allowed");
      _showPremiumDialog();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final audioStreamUrl = _buildAudioUrl();
      debugPrint("Audio URL: $audioStreamUrl");

      await _player.setUrl(audioStreamUrl);

      setState(() {
        _isPrepared = true;
        _isLoading = false;
      });

      await _player.play();
      await _subscriptionPreferences?.recordAudioPlay();
    } catch (e) {
      debugPrint("Audio load error: $e");
      setState(() => _isLoading = false);
      context.showErrorSnackBar(Strings.testAudioInstructionStreamError,
          durationInSeconds: 3,
          autoDismiss: true,
          position: DelightSnackbarPosition.bottom);
    }
  }

  String _buildAudioUrl() {
    const baseApiUrl = 'https://backend.avtotest-begzod.uz';
    const apiEndpoint = 'api/v1/file/download/mobile/audio';
    final deviceId = widget.devicePreferences.deviceInstallationId;
    final params = '${_currentAudioId ?? ""}@$deviceId';

    return '$baseApiUrl/$apiEndpoint/$params';
  }

  void _showPremiumDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return PremiumBottomSheet(
          userId: widget.userPreferences.userId,
          onClickOpenTelegram: () => Navigator.of(context).pop(),
        );
      },
    );
  }
}
