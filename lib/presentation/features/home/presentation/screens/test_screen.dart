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
import 'package:avtotest/presentation/features/home/presentation/widgets/answer_widget.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/test_hint_widget.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/couters_widget.dart';
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
  final PageController _pageController = PageController();
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
        _bloc.add(
          InitialQuestionsEvent(
            questions: widget.questions,
            time: Duration(minutes: 25),
            groupId: widget.tickedId,
          ),
        );
      case ExamType.realExam:
        _bloc.add(
          InitialQuestionsEvent(
            questions: widget.questions,
            time: Duration(minutes: 25),
          ),
        );
      case ExamType.exam:
        if (widget.isRealExam45 != null && widget.isRealExam45!) {
          _bloc.add(
            InitialQuestionsEvent(
              questions: widget.questions,
              time: Duration(minutes: 45),
            ),
          );
        } else {
          _bloc.add(
            InitialQuestionsEvent(
              questions: widget.questions,
              time: Duration(minutes: 25),
            ),
          );
        }
      case ExamType.topicExam:
        _bloc.add(
          InitialQuestionsEvent(
            questions: widget.questions,
            time: Duration.zero,
            lessonId: widget.lessonId,
          ),
        );
      case ExamType.hardQuestions:
        _bloc.add(
          InitialQuestionsEvent(
              questions: widget.questions,
              time: Duration(minutes: widget.questions.length)),
        );
      case ExamType.marathon:
        _bloc.add(
          InitialQuestionsEvent(
              questions: widget.questions,
              time: Duration.zero,
              isMarathon: true),
        );
      case ExamType.errorExam:
        _bloc
          ..add(
            InitialQuestionsEvent(
              questions: widget.questions,
              time: Duration(minutes: widget.questions.length),
            ),
          )
          ..add(SetDateEvent(date: widget.errorDate));
    }
  }

  void scrollToCurrentStep({required int currentStep}) {
    final double itemWidth = currentStep > 100 ? 55 : 50;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double targetScrollOffset =
        (itemWidth * currentStep) - (screenWidth / 2) + (itemWidth / 2) + 16;

    _scrollController.animateTo(
      targetScrollOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  AnswerStatus getAnswerStatus({
    required QuestionModel questionModel,
    required int index,
  }) {
    if (questionModel.isAnswered) {
      if (questionModel.answers[index].isCorrect) {
        return AnswerStatus.correct;
      } else {
        if (index == questionModel.errorAnswerIndex) {
          return AnswerStatus.incorrect;
        } else {
          return AnswerStatus.notAnswered;
        }
      }
    } else {
      return AnswerStatus.notAnswered;
    }
  }

  int getAnswersCount({
    required List<QuestionModel> questionModels,
  }) {
    return questionModels.where((item) {
      return item.isAnswered;
    }).length;
  }

  int getCorrectAnswersCount({
    required List<QuestionModel> questionModels,
  }) {
    return questionModels.where((item) {
      return item.isAnswered && item.errorAnswerIndex == -1;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<QuestionsSolveBloc, QuestionsSolveState>(
        builder: (context, state) {
          // print("_settingsPreferences.isAnswerHintShowingEnabled ${_settingsPreferences.isAnswerHintShowingEnabled}");
          return PopScope(
            canPop: true,
            onPopInvokedWithResult: (bool didPop, result) {
              if (widget.examType == ExamType.errorExam) {
                _bloc.add(RemoveStatisticsErrorEvent());
              } else {
                _bloc.add(InsertQuestionAttemptsEvent());
                if (_bloc.state.ticketId != -1) {
                  _bloc.add(InsertTicketStatisticsEvent());
                } else {
                  if (_bloc.state.topicId != -1) {
                    _bloc.add(InsertTopicStatisticsEvent());
                  }
                }
              }
            },
            child: Scaffold(
              appBar: AppBarWrapper(
                  title: widget.title,
                  hasBackButton: true,
                  actions: [
                    state.questions.isNotEmpty &&
                            (widget.examType == ExamType.realExam ||
                                widget.examType == ExamType.marathon ||
                                widget.examType == ExamType.errorExam)
                        ? Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text:
                                          "${getAnswersCount(questionModels: state.questions) - getCorrectAnswersCount(questionModels: state.questions)}",
                                      style: context.textTheme.headlineSmall!
                                          .copyWith(color: AppColors.red)),
                                  TextSpan(
                                      text:
                                          " / ${getAnswersCount(questionModels: state.questions)}",
                                      style: context.textTheme.headlineSmall!
                                          .copyWith(
                                              color: context.themeExtension
                                                  .charcoalBlackToWhite))
                                ]),
                              ),
                            ),
                          )
                        : SizedBox(),
                    widget.examType == ExamType.marathon
                        ? Center(
                            child: GestureDetector(
                              onTap: () {
                                context
                                    .read<QuestionsSolveBloc>()
                                    .add(RefreshMarathonEvent());
                              },
                              child: Icon(Icons.refresh,
                                  color: context.themeExtension.blackToWhite,
                                  size: 30),
                            ),
                          )
                        : SizedBox(),
                    state.questions.isNotEmpty
                        ? Center(
                            child: GestureDetector(
                              onTap: () {
                                context.addBlocEvent<HomeBloc>(
                                    ParseQuestionsEvent());
                                context.addBlocEvent<QuestionsSolveBloc>(
                                    BookmarkEvent(
                                        question: state
                                            .questions[state.currentIndex]));
                                context.addBlocEvent<HomeBloc>(BookmarkedEvent(
                                    questionId:
                                        state.questions[state.currentIndex].id,
                                    isBookmarked: state
                                        .questions[state.currentIndex]
                                        .isBookmarked));
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  AppIcons.bookmark,
                                  colorFilter: ColorFilter.mode(
                                    state.questions[state.currentIndex]
                                            .isBookmarked
                                        ? AppColors.yellow
                                        : context.themeExtension.blackToWhite!,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(
                      width: 16,
                    ),
                  ],
                  onTap: () {
                    if (widget.examType == ExamType.errorExam) {
                      _bloc.add(RemoveStatisticsErrorEvent());
                    } else {
                      _bloc.add(InsertQuestionAttemptsEvent());
                      if (_bloc.state.ticketId != -1) {
                        _bloc.add(InsertTicketStatisticsEvent());
                      } else {
                        if (_bloc.state.topicId != -1) {
                          _bloc.add(InsertTopicStatisticsEvent());
                        }
                      }
                    }
                    Navigator.of(context).pop();
                  }),
              body: WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Column(
                  children: [
                    if (widget.examType == ExamType.ticket ||
                        widget.examType == ExamType.exam ||
                        widget.examType == ExamType.realExam ||
                        widget.examType == ExamType.topicExam ||
                        widget.examType == ExamType.hardQuestions ||
                        widget.examType == ExamType.errorExam) ...[
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
                                    SvgPicture.asset(
                                      AppIcons.alarm,
                                      colorFilter: ColorFilter.mode(
                                        context.themeExtension
                                            .charcoalBlackToWhite!,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      MyFunctions.formatDuration(state.time),
                                      style: context.textTheme.headlineSmall!
                                          .copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: WButton(
                                color: AppColors.strongRed,
                                hasGradient: false,
                                onTap: () {
                                  context.read<QuestionsSolveBloc>().add(
                                      AnswerIsFullEvent(
                                          onSuccess: (bool isFullAnswered) {
                                    if (!isFullAnswered) {
                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (ctx) {
                                            return TestEndBottomSheet(
                                                onTap: () {
                                              context
                                                  .read<QuestionsSolveBloc>()
                                                  .add(StopTimerEvent(
                                                      onStop: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                  return BlocProvider.value(
                                                    value: _bloc,
                                                    child: ResultScreen(
                                                      isError: widget
                                                              .examType ==
                                                          ExamType.errorExam,
                                                    ),
                                                  );
                                                }));
                                              }));
                                            });
                                          });
                                    } else {
                                      context
                                          .read<QuestionsSolveBloc>()
                                          .add(StopTimerEvent(onStop: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return BlocProvider.value(
                                            value: _bloc,
                                            child: ResultScreen(
                                              isError: widget.examType ==
                                                  ExamType.errorExam,
                                            ),
                                          );
                                        }));
                                      }));
                                    }
                                  }));
                                },
                                rippleColor: Colors.transparent,
                                border: Border.all(
                                  width: 2,
                                  color:
                                      AppColors.strongRed.withValues(alpha: .3),
                                ),
                                text: Strings.finish,
                                textColor: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CountersWidget(
                        scrollController: _scrollController,
                        carouselSliderController: _carouselSliderController,
                        state: state,
                      )
                    ],
                    if (state.questions.isEmpty)
                      Center(
                        child: Text(
                          Strings.loadingQuestions,
                          style: context.textTheme.headlineSmall!.copyWith(
                              color: AppColors.charcoalBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    else
                      TestWidget(
                        carouselController: _carouselSliderController,
                        questions: state.questions,
                        isMarathon: widget.examType == ExamType.marathon,
                      ),
                  ],
                ),
              ),
              floatingActionButton: state.questions.isNotEmpty &&
                      (!_settingsPreferences.isAnswerHintShowingEnabled ||
                          state.questions[state.currentIndex].isAnswered)
                  ? TestHintWidget(
                      state.questions[state.currentIndex],
                      devicePreferences: _devicePreferences,
                      settingsPreferences: _settingsPreferences,
                      subscriptionPreferences: _subscriptionPreferences,
                      userPreferences: _userPreferences,
                    )
                  : SizedBox(),
            ),
          );
        },
        listenWhen: (pre, next) {
          return pre.time != next.time && next.time == Duration.zero;
        },
        listener: (context, state) {
          if (state.time == Duration.zero) {
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
        },
      ),
    );
  }

  @override
  dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
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
