import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/assets/constants/app_images.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/bookmarks_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/mistake_history_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/search_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/test_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/tickets_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/topics_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/home_widget.dart';
import 'package:avtotest/presentation/utils/bloc_context_extensions.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/utils/navigator_extensions.dart';
import 'package:avtotest/presentation/widgets/percent_indicator/circular_percent_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<bool> scrollOffset = ValueNotifier(false);
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    scrollController.addListener(() {
      scrollOffset.value = scrollController.position.pixels > kToolbarHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.vividBlue,
      statusBarIconBrightness: Brightness.light,
    ));

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: AppColors.vividBlue,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: ValueListenableBuilder(
            valueListenable: scrollOffset,
            builder: (context, value, Widget? child) {
              return _buildAppBar(context);
            },
          ),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _buildProgressBarBackground(),
                  _buildMainProgressBar(),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                    children: [
                      SizedBox(height: 5),
                      _buildPreparatoryExam20(context),
                      _buildPreparatoryExam50(context),
                      _buildRealExam(context),
                      _buildTickets(context),
                      _buildThemedTests(context),
                      _buildDistractionQuestions(context),
                      _buildMarathon(context),
                      _buildBookmarkedQuestions(context),
                      _buildIncorrectAnsweredQuestions(context),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              )
            ]),
      ),
    );
  }

  ClipRRect _buildProgressBarBackground() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(25),
        bottomRight: Radius.circular(25),
      ),
      child: Image.asset(
        AppImages.mainBackground,
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          SvgPicture.asset(AppIcons.appIcon),
          SizedBox(width: 6),
          Text(
            "AvtoTest",
            style: context.textTheme.headlineLarge!.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ],
      ),
      centerTitle: true,
      scrolledUnderElevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      backgroundColor: Colors.transparent,
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(AppIcons.search),
          ),
          onTap: () => context.rootNavigator.pushPage(SearchScreen()),
        ),
        SizedBox(width: 16)
      ],
    );
  }

  Widget _buildMainProgressBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: -120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return CircularPercentIndicator(
                radius: 160.0,
                lineWidth: 30.0,
                percent: state.questions.isNotEmpty
                    ? ((state.solveQuestionCount / state.questions.length) *
                                100)
                            .round() /
                        100
                    : 0.0,
                animation: false,
                circularStrokeCap: CircularStrokeCap.round,
                reverse: false,
                backgroundColor: Colors.blue.withOpacity(0.2),
                progressColor: AppColors.white,
                arcType: ArcType.HALF,
                arcBackgroundColor: Color(0xff6A8FFF),
                center: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.questions.isNotEmpty
                          ? "${(state.solveQuestionCount / state.questions.length * 100).round()}%"
                          : "0%",
                      style: context.textTheme.headlineLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 48,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${Strings.tests}:",
                          style: context.textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: AppColors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        state.isLoading
                            ? SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.white),
                                ),
                              )
                            : Text(
                                state.questions.isNotEmpty
                                    ? "${state.totalCount}/${state.questions.length}"
                                    : "0/0",
                                style:
                                    context.textTheme.headlineSmall!.copyWith(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: 60)
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  HomeWidget _buildPreparatoryExam20(BuildContext context) {
    return HomeWidget(
      title: "${Strings.preparatoryExam} - 20",
      imagePath: AppIcons.homePreparatoryExam20,
      onTap: () {
        context.addBlocEvent<HomeBloc>(
          GetTrainingQuestionsEvent(
            questionCount: 20,
            onSuccess: (List<QuestionModel> questions) {
              context.rootNavigator.push(MaterialPageRoute(
                builder: (context) {
                  return TestScreen(
                    questions: questions,
                    title: Strings.preparatoryExam,
                    examType: ExamType.exam,
                  );
                },
              ));
            },
          ),
        );
      },
    );
  }

  HomeWidget _buildPreparatoryExam50(BuildContext context) {
    return HomeWidget(
      title: "${Strings.preparatoryExam} - 50",
      imagePath: AppIcons.homePreparatoryExam50,
      onTap: () {
        context.addBlocEvent<HomeBloc>(
          GetTrainingQuestionsEvent(
            questionCount: 50,
            onSuccess: (List<QuestionModel> questions) {
              context.rootNavigator.push(MaterialPageRoute(
                builder: (context) {
                  return TestScreen(
                    questions: questions,
                    title: Strings.preparatoryExam,
                    examType: ExamType.exam,
                    isRealExam45: true,
                  );
                },
              ));
            },
          ),
        );
      },
    );
  }

  HomeWidget _buildRealExam(BuildContext context) {
    return HomeWidget(
      title: Strings.realExam,
      imagePath: AppIcons.homeRealExam,
      onTap: () {
        context.addBlocEvent<HomeBloc>(
          GetRealExamQuestionsEvent(
            onSuccess: (List<QuestionModel> questions) {
              context.pushRoot(TestScreen(
                questions: questions,
                title: Strings.realExam,
                examType: ExamType.realExam,
              ));
            },
          ),
        );
      },
    );
  }

  HomeWidget _buildTickets(BuildContext context) {
    return HomeWidget(
      imagePath: AppIcons.test,
      title: Strings.tickets,
      onTap: () => context.push(TicketsScreen()),
    );
  }

  HomeWidget _buildThemedTests(BuildContext context) {
    return HomeWidget(
      title: Strings.themedTests,
      imagePath: AppIcons.homeThemedTests,
      onTap: () {
        context.rootNavigator.pushPage(TopicsScreen()).then((value) {
          context.addBlocEvent<HomeBloc>(GetMistakeHistoryEvent());
        });
      },
    );
  }

  HomeWidget _buildDistractionQuestions(BuildContext context) {
    return HomeWidget(
      title: Strings.homeDistractionQuestions,
      imagePath: AppIcons.homeDistractorQuestions,
      onTap: () {
        context.addBlocEvent<HomeBloc>(
          GetDistractionQuestionsEvent(
            onSuccess: (List<QuestionModel> questions) {
              context.rootNavigator.push(
                MaterialPageRoute(
                  builder: (context) {
                    return TestScreen(
                      questions: questions,
                      title: Strings.homeDistractionQuestions,
                      examType: ExamType.hardQuestions,
                    );
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  HomeWidget _buildMarathon(BuildContext context) {
    return HomeWidget(
      title: Strings.marathon,
      imagePath: AppIcons.cup,
      onTap: () {
        context.addBlocEvent<HomeBloc>(
          GetMarathonQuestionsEvent(
            onSuccess: (List<QuestionModel> questions) {
              context.rootNavigator.pushPage(
                TestScreen(
                  questions: questions,
                  title: Strings.marathon,
                  examType: ExamType.marathon,
                ),
              );
            },
          ),
        );
      },
    );
  }

  HomeWidget _buildBookmarkedQuestions(BuildContext context) {
    return HomeWidget(
      title: Strings.saved,
      imagePath: AppIcons.bookmarkOutline,
      onTap: () {
        context.rootNavigator.pushPage(BookmarksScreen());
      },
    );
  }

  HomeWidget _buildIncorrectAnsweredQuestions(BuildContext context) {
    return HomeWidget(
      title: Strings.errors,
      imagePath: AppIcons.error,
      onTap: () {
        context.rootNavigator.pushPage(MistakeHistoryScreen());
      },
    );
  }
}
