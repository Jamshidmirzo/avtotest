import 'dart:developer';
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
import 'package:avtotest/presentation/utils/context_message_extensions.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

// ГЛОБАЛЬНАЯ ПЕРЕМЕННАЯ (Вне класса)
// Гарантирует, что туториал сработает только 1 раз за сессию приложения.
bool _hasGlobalTutorialShown = false;

class TestHintWidget extends StatefulWidget {
  final bool isTestScreen;
  final QuestionModel question;
  final DevicePreferences devicePreferences;
  final SettingsPreferences settingsPreferences;
  final SubscriptionPreferences subscriptionPreferences;
  final UserPreferences userPreferences;
  final int? index;
  // ✅ Новый параметр (Nullable)
  final bool? showTutorial;
  const TestHintWidget(
    this.question, {
    super.key,
    required this.devicePreferences,
    required this.settingsPreferences,
    required this.subscriptionPreferences,
    required this.userPreferences,
    required this.isTestScreen,
    this.showTutorial, // ✅ Принимаем параметр
    this.index,
  });
  @override
  State<TestHintWidget> createState() => _TestHintWidgetState();
}

class _TestHintWidgetState extends State<TestHintWidget> {
  final AudioPlayer _player = AudioPlayer();
  final GlobalKey audioButtonKey = GlobalKey();
  String? _currentAudioId;
  bool _isPrepared = false;
  bool _isLoading = false;
  bool _isHintSheetOpen = false;
  bool _isPremiumSheetOpen = false;
  @override
  void initState() {
    log(widget.showTutorial.toString());
    super.initState();
    _currentAudioId = widget.question.audioId;
    // Запускаем проверку только после полной отрисовки кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  @override
  void didUpdateWidget(TestHintWidget oldWidget) {
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

  // ================= Tutorial Logic =================
  Future<void> _checkAndShowTutorial() async {
    // 1. ✅ ПРОВЕРКА ПАРАМЕТРА
    // Если showTutorial == null или showTutorial == false, выходим сразу.
    if (widget.showTutorial != true) return;
    if (_hasGlobalTutorialShown) return;
    if (!mounted) return;
    int attempts = 20;
    while (attempts > 0) {
      if (!mounted) return;
      if (_hasGlobalTutorialShown) return;
      final ctx = audioButtonKey.currentContext;
      final renderBox = ctx?.findRenderObject() as RenderBox?;
      if (renderBox != null && renderBox.hasSize && renderBox.attached) {
        // Устанавливаем флаг НЕМЕДЛЕННО
        _hasGlobalTutorialShown = true;
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          _safeShowTutorial();
        }
        return;
      }
      attempts--;
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  void _safeShowTutorial() {
    if (!mounted) return;
    if (audioButtonKey.currentContext == null) return;
    // Определяем, темная ли тема сейчас
    final isDark = Theme.of(context).brightness == Brightness.dark;
    try {
      TutorialCoachMark(
        targets: _createTargets(),
        // ✅ ЦВЕТ ФОНА (ТЕНИ)
        // В темной теме можно сделать тень черной, но прозрачнее, или другого оттенка.
        // Здесь пример: Черный для обоих, но разная прозрачность, если нужно.
        colorShadow: isDark ? Colors.white : Colors.black,
        // ✅ ПРОЗРАЧНОСТЬ
        // Например: в светлой теме посветлее (0.4), в темной потемнее (0.6)
        opacityShadow: isDark ? 0.6 : 0.4,
        paddingFocus: 10,
        hideSkip: false,
        onFinish: () {},
        onSkip: () {
          return true;
        },
      ).show(context: context);
    } catch (e) {
      debugPrint("TutorialCoachMark Error: $e");
    }
  }

  List<TargetFocus> _createTargets() {
    // Получаем цвета из текущей темы
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return [
      TargetFocus(
        identify: "audio_button",
        keyTarget: audioButtonKey,
        enableOverlayTab: true,
        shape: ShapeLightFocus.Circle,
        radius: 40,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // ✅ ЦВЕТ КОНТЕЙНЕРА
                // Используем цвет карточек из темы (обычно белый в Light, серый в Dark)
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  // Небольшая тень для красоты
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                // Обернул в Column для безопасности верстки
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('hint_audio_instruction'),
                    // ✅ ЦВЕТ ТЕКСТА
                    // Берем стиль текста из темы, чтобы он был белым на темном и черным на светлом
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16,
                      // Если стиль темы не срабатывает, принудительно меняем цвет:
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ).tr(),
                ],
              ),
            ),
          ),
        ],
      ),
    ];
  }

  // ================= UI (Без изменений) =================
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget.isTestScreen
            ? const SizedBox(width: 32)
            : const SizedBox.shrink(),
        _buildAudioWidget(),
        const Spacer(),
        _buildTextHintButton(context),
      ],
    );
  }

  Widget _buildAudioWidget() {
    final lang = context.locale.languageCode;
    if (lang == "ru") return const SizedBox.shrink();
    return _isPrepared ? _buildAudioControls(context) : _buildStartButton();
  }

  Widget _buildStartButton() {
    return FloatingActionButton(
      key: audioButtonKey,
      heroTag: "audio_btn_${widget.question.id}",
      onPressed: _startAudioLoad,
      backgroundColor: AppColors.vividBlue,
      child: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : SvgPicture.asset(
              AppIcons.icAudioPlayerPlay,
              colorFilter:
                  const ColorFilter.mode(Colors.white, BlendMode.srcIn),
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
            if (mounted && _isPrepared) {
              setState(() => _isPrepared = false);
            }
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
                double progress = duration.inMilliseconds > 0
                    ? position.inMilliseconds / duration.inMilliseconds
                    : 0;
                if (progress > 1) progress = 1;
                return FloatingActionButton(
                  heroTag: "audio_ctrl_${widget.question.id}",
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
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
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

  Future<void> _startAudioLoad() async {
    if (widget.subscriptionPreferences.cantPlayAudio) {
      _showPremiumDialog();
      return;
    }
    setState(() => _isLoading = true);
    try {
      final url = await _buildAudioUrl();
      await _player.setUrl(url);
      setState(() {
        _isPrepared = true;
        _isLoading = false;
      });
      await _player.play();
      await widget.subscriptionPreferences.recordAudioPlay();
    } catch (e) {
      debugPrint("AUDIO ERROR: $e");
      setState(() => _isLoading = false);
      context.showErrorSnackBar(
        Strings.testAudioInstructionStreamError,
        durationInSeconds: 3,
        position: DelightSnackbarPosition.bottom,
      );
    }
  }

  Future<String> _buildAudioUrl() async {
    const baseApiUrl = 'https://backend.avtotest-begzod.uz';
    const apiEndpoint = 'api/v1/file/download/mobile/audio';
    final deviceId = await widget.devicePreferences.deviceInstallationId;
    final params = '${_currentAudioId ?? ""}@$deviceId';
    return '$baseApiUrl/$apiEndpoint/$params';
  }

  Widget _buildTextHintButton(BuildContext context) {
    return FloatingActionButton(
      heroTag: "HintHero_${widget.question.id}",
      backgroundColor: AppColors.vividBlue,
      onPressed: _showTextHintModal,
      child: SvgPicture.asset(
        AppIcons.icHintText,
        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }

  void _showTextHintModal() {
    if (_isHintSheetOpen) return;
    _isHintSheetOpen = true;
    final lang = context.locale.languageCode;
    final bloc = context.read<QuestionsSolveBloc>();
    bloc.add(GetCorrectAnswerEvent(onSuccess: (AnswerModel? answer) {
      if (answer == null) {
        context.showErrorSnackBar("Подсказка недоступна");
        _isHintSheetOpen = false;
        return;
      }
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (ctx) => QuestionHintBottomSheet(
          question: MyFunctions.getQuestionDescription(
            questionModel: widget.question,
            lang: lang,
          ),
        ),
      ).whenComplete(() => _isHintSheetOpen = false);
    }));
  }

  void _showPremiumDialog() {
    if (_isPremiumSheetOpen) return;
    _isPremiumSheetOpen = true;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => PremiumBottomSheet(
        userId: widget.userPreferences.userId,
        onClickOpenTelegram: () => Navigator.pop(context),
      ),
    ).whenComplete(() => _isPremiumSheetOpen = false);
  }
}
