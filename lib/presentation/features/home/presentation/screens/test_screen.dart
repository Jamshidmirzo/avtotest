import 'dart:developer';
import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/data/datasource/preference/device_preferences.dart';
import 'package:avtotest/data/datasource/preference/settings_preferences.dart';
import 'package:avtotest/data/datasource/preference/subscription_preferences.dart';
import 'package:avtotest/data/datasource/preference/user_preferences.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/bottom_sheet/real_exam_pause_bottom_sheet.dart';
import 'package:avtotest/presentation/features/home/presentation/bottom_sheet/test_end_bottom_sheet.dart';
import 'package:avtotest/presentation/features/home/presentation/bottom_sheet/time_end_bottom_sheet.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/result_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/couters_widget.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/test_hint_widget.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/test_widget.dart';
import 'package:avtotest/presentation/utils/bloc_context_extensions.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({
    super.key,
    required this.questions,
    required this.title,
    this.tickedId = -1,
    required this.examType,
    this.isRealExam45,
    this.lessonId = -1,
    this.errorDate = '',
  });

  final List<QuestionModel> questions;
  final String title;
  final int tickedId;
  final ExamType examType;
  final bool? isRealExam45;
  final int lessonId;
  final String errorDate;

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  bool _isBottomSheetShown = false;
  final QuestionsSolveBloc _bloc = QuestionsSolveBloc();
  final ScrollController _scrollController = ScrollController();
  final CarouselSliderController _carouselSliderController =
      CarouselSliderController();

  late final DevicePreferences _devicePreferences;
  late final SettingsPreferences _settingsPreferences;
  late final SubscriptionPreferences _subscriptionPreferences;
  late final UserPreferences _userPreferences;

  @override
  void initState() {
    _addInitialEvent();
    super.initState();
  }

  Future<void> _addInitialEvent() async {
    _devicePreferences = await DevicePreferences.getInstance();
    _settingsPreferences = await SettingsPreferences.getInstance();
    _subscriptionPreferences = await SubscriptionPreferences.getInstance();
    _userPreferences = await UserPreferences.getInstance();

    switch (widget.examType) {
      case ExamType.ticket:
        _bloc.add(InitialQuestionsEvent(
          questions: widget.questions,
          time: const Duration(minutes: 25),
          groupId: widget.tickedId,
        ));
      case ExamType.realExam:
        _bloc.add(InitialQuestionsEvent(
          questions: widget.questions,
          time: const Duration(minutes: 25),
        ));
      case ExamType.exam:
        if (widget.isRealExam45 == true) {
          _bloc.add(InitialQuestionsEvent(
            questions: widget.questions,
            time: const Duration(minutes: 45),
          ));
        } else {
          _bloc.add(InitialQuestionsEvent(
            questions: widget.questions,
            time: const Duration(minutes: 25),
          ));
        }
      case ExamType.topicExam:
        _bloc.add(InitialQuestionsEvent(
          questions: widget.questions,
          time: Duration.zero,
          lessonId: widget.lessonId,
        ));
      case ExamType.hardQuestions:
        _bloc.add(InitialQuestionsEvent(
          questions: widget.questions,
          time: Duration(minutes: widget.questions.length),
        ));
      case ExamType.marathon:
        _bloc.add(InitialQuestionsEvent(
          questions: widget.questions,
          time: Duration.zero,
          isMarathon: true,
        ));
      case ExamType.errorExam:
        _bloc
          ..add(InitialQuestionsEvent(
            questions: widget.questions,
            time: Duration(minutes: widget.questions.length),
          ))
          ..add(SetDateEvent(date: widget.errorDate));
    }
  }

  int getAnswersCount({required List<QuestionModel> questionModels}) =>
      questionModels.where((q) => q.isAnswered).length;

  int getCorrectAnswersCount({required List<QuestionModel> questionModels}) =>
      questionModels
          .where((q) => q.isAnswered && q.errorAnswerIndex == -1)
          .length;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<QuestionsSolveBloc, QuestionsSolveState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: state.questions.isNotEmpty &&
                    (!_settingsPreferences.isAnswerHintShowingEnabled ||
                        state.questions[state.currentIndex].isAnswered)
                ? TestHintWidget(
                    isTestScreen: true,
                    state.questions[state.currentIndex],
                    devicePreferences: _devicePreferences,
                    settingsPreferences: _settingsPreferences,
                    subscriptionPreferences: _subscriptionPreferences,
                    userPreferences: _userPreferences,
                  )
                : SizedBox(),
            appBar: AppBarWrapper(
              title: widget.title,
              hasBackButton: true,
              actions: [
                if (state.questions.isNotEmpty &&
                    (widget.examType == ExamType.realExam ||
                        widget.examType == ExamType.marathon ||
                        widget.examType == ExamType.errorExam))
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text:
                                "${getAnswersCount(questionModels: state.questions) - getCorrectAnswersCount(questionModels: state.questions)}",
                            style: context.textTheme.headlineSmall!
                                .copyWith(color: AppColors.red),
                          ),
                          TextSpan(
                            text:
                                " / ${getAnswersCount(questionModels: state.questions)}",
                            style: context.textTheme.headlineSmall!.copyWith(
                              color:
                                  context.themeExtension.charcoalBlackToWhite,
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
              ],
              onTap: () => Navigator.of(context).pop(),
            ),
            body: Column(
              children: [
                if (widget.examType != ExamType.marathon)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: WButton(
                            hasGradient: false,
                            onTap: () {},
                            color: context.themeExtension.whiteToGondola,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AppIcons.alarm),
                                const SizedBox(width: 10),
                                Text(
                                  MyFunctions.formatDuration(state.time),
                                  style:
                                      context.textTheme.headlineSmall!.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: WButton(
                            color: AppColors.strongRed,
                            hasGradient: false,
                            onTap: () {
                              context.read<QuestionsSolveBloc>().add(
                                StopTimerEvent(onStop: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: _bloc,
                                        child: ResultScreen(
                                          isError: widget.examType ==
                                              ExamType.errorExam,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              );
                            },
                            rippleColor: Colors.transparent,
                            border: Border.all(
                              width: 2,
                              color: AppColors.strongRed.withValues(alpha: .3),
                            ),
                            text: Strings.finish,
                            textColor: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                // ⚡ CounterWidget
                if (state.questions.isNotEmpty)
                  CountersWidget(
                    scrollController: _scrollController,
                    carouselSliderController: _carouselSliderController,
                    state: state,
                  ),
                if (state.questions.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else
                  Expanded(
                    child: TestWidget(
                      carouselController: _carouselSliderController,
                      questions: state.questions,
                      isMarathon: widget.examType == ExamType.marathon,
                    ),
                  ),
              ],
            ),
          );
        },
        listenWhen: (prev, next) =>
            prev.currentIndex != next.currentIndex ||
            prev.questions != next.questions ||
            prev.time != next.time,
        listener: (context, state) {
          // ⏰ время закончилось
          if (state.time == Duration.zero && !_isBottomSheetShown) {
            _isBottomSheetShown = true;
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isDismissible: false,
              context: context,
              builder: (_) => TimeEndBottomSheet(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: _bloc,
                        child: ResultScreen(
                          isError: widget.examType == ExamType.errorExam,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          // ✅ все вопросы отвечены
          if (getAnswersCount(questionModels: state.questions) ==
                  state.questions.length &&
              !_isBottomSheetShown) {
            _isBottomSheetShown = true;
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isDismissible: false,
              context: context,
              builder: (_) => TestEndBottomSheet(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: _bloc,
                        child: ResultScreen(
                          isError: widget.examType == ExamType.errorExam,
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          // 🚨 3 ошибки в realExam
          if (widget.examType == ExamType.realExam &&
              (getAnswersCount(questionModels: state.questions) -
                      getCorrectAnswersCount(
                          questionModels: state.questions)) >=
                  3 &&
              !_isBottomSheetShown) {
            _isBottomSheetShown = true;
            showModalBottomSheet(
              backgroundColor: Colors.transparent,
              isDismissible: false,
              context: context,
              builder: (_) => RealExamPauseBottomSheet(
                onTap: () {
                  Navigator.of(context).pop();
                  context.addBlocEvent<HomeBloc>(
                    GetRealExamQuestionsEvent(
                      onSuccess: (List<QuestionModel> newQuestions) {
                        _bloc.add(InitialQuestionsEvent(
                          questions: newQuestions,
                          time: const Duration(minutes: 25),
                        ));
                        _isBottomSheetShown = false; // сброс для нового теста
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

enum ExamType {
  ticket,
  realExam,
  exam,
  topicExam,
  marathon,
  errorExam,
  hardQuestions
}
