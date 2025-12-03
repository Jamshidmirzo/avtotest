import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/questions_result_widget.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/empty_widget.dart';
import 'package:avtotest/presentation/widgets/w_textfield.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class SearchScreen extends StatefulWidget {
  final bool? showTutorial;

  // ✅ УДАЛЯЕМ СТАТИЧЕСКИЙ ФЛАГ ОТСЮДА!

  const SearchScreen({super.key, this.showTutorial});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearch = false;
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final GlobalKey firstAudioKey = GlobalKey();

  // ✅ НОВАЯ ПЕРЕМЕННАЯ СОСТОЯНИЯ: сбрасывается при каждом новом входе на экран.
  bool _hasShownTutorialInThisVisit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(
            GetOrderedQuestionsEvent(
              questionCount: 1,
              onSuccess: (questions) {
                if (questions.isNotEmpty) {
                  context.read<QuestionsSolveBloc>().add(
                        LoadQuestionsEvent(questions),
                      );
                }
              },
            ),
          );

      _initTutorial();
    });
  }

  Future<void> _initTutorial() async {
    if (widget.showTutorial != true) return;

    // ✅ 1. ПРОВЕРЯЕМ ЛОКАЛЬНУЮ ПЕРЕМЕННУЮ
    if (_hasShownTutorialInThisVisit) return;

    // Ждем пока список загрузится и отрисуется
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    int attempts = 10;
    while (attempts > 0) {
      if (!mounted) return;
      final ctx = firstAudioKey.currentContext;

      if (ctx != null) {
        _hasShownTutorialInThisVisit = true;
        await Future.delayed(const Duration(milliseconds: 10));
        if (mounted) _showTutorial();
        return;
      }
      attempts--;
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  void _showTutorial() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    try {
      TutorialCoachMark(
        targets: _createTargets(),
        colorShadow: isDark ? Colors.white : Colors.black,
        opacityShadow: isDark ? 0.6 : 0.4,
        paddingFocus: 10,
        hideSkip: false,
        onFinish: () {},
        onSkip: () => true,
      ).show(context: context);
    } catch (e) {
      debugPrint("Tutorial Error: $e");
    }
  }

  List<TargetFocus> _createTargets() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return [
      TargetFocus(
        identify: "audio_button_tutorial",
        keyTarget: firstAudioKey,
        enableOverlayTab: true,
        shape: ShapeLightFocus.Circle,
        radius: 35,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1), blurRadius: 10)
                ],
              ),
              child: Text(
                context.tr('hint_audio_instruction'),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ).tr(),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                if (isSearch) {
                  setState(() {
                    isSearch = false;
                    controller.clear();
                    context
                        .read<HomeBloc>()
                        .add(SearchQuestionEvent(query: ''));
                  });
                } else {
                  Navigator.pop(context);
                }
              },
              icon: SvgPicture.asset(
                AppIcons.chevronLeft,
                colorFilter: ColorFilter.mode(
                  context.themeExtension.blackToWhite!,
                  BlendMode.srcIn,
                ),
              ),
            ),
            leadingWidth: 30,
            centerTitle: true,
            title: isSearch
                ? WTextField(
                    focusNode: focusNode,
                    controller: controller,
                    margin: EdgeInsets.zero,
                    borderRadius: 16,
                    hintText: Strings.search,
                    hintTextStyle: context.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: context.themeExtension.ashGrayToPaleGray,
                    ),
                    hasBorderColor: false,
                    fillColor: context.themeExtension.whiteToGondola,
                    focusColor: context.themeExtension.whiteToGondola,
                    onChanged: (text) {
                      context
                          .read<HomeBloc>()
                          .add(SearchQuestionEvent(query: text));
                    },
                    suffix: controller.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              controller.clear();
                              context
                                  .read<HomeBloc>()
                                  .add(SearchQuestionEvent(query: ''));
                            },
                            child: Icon(Icons.clear,
                                color: context.themeExtension.blackToWhite),
                          )
                        : null,
                  )
                : Text(
                    Strings.tests,
                    style: context.textTheme.bodySmall!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
            automaticallyImplyLeading: false,
            actions: [
              if (!isSearch)
                GestureDetector(
                  onTap: () {
                    setState(() => isSearch = true);
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      focusNode.requestFocus();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SvgPicture.asset(
                      width: 24,
                      height: 24,
                      AppIcons.search,
                      colorFilter: ColorFilter.mode(
                        context.themeExtension.blackToWhite!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: state.searchQuestions.isNotEmpty
              ? ListView.separated(
                  padding: const EdgeInsets.only(top: 12),
                  itemCount: state.searchQuestions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return QuestionsResultWidget(
                      questionModel: state.searchQuestions[index],
                      index: index,
                      type: 1,
                      tutorialKey: index == 0 ? firstAudioKey : null,
                    );
                  },
                )
              : const EmptyWidget(),
        );
      },
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
