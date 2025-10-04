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
  late final List<_MenuItem> _menuItems;

  @override
  void initState() {
    super.initState();
    _initializeMenuItems();
  }

  void _initializeMenuItems() {
    _menuItems = [
      _MenuItem(
        title: "${Strings.preparatoryExam} - 20",
        imagePath: AppIcons.homePreparatoryExam20,
        onTap: (context) {
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
      ),
      _MenuItem(
        title: "${Strings.preparatoryExam} - 50",
        imagePath: AppIcons.homePreparatoryExam50,
        onTap: (context) {
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
      ),
      _MenuItem(
        title: Strings.realExam,
        imagePath: AppIcons.homeRealExam,
        onTap: (context) {
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
      ),
      _MenuItem(
        title: Strings.tickets,
        imagePath: AppIcons.test,
        onTap: (context) => context.push(TicketsScreen()),
      ),
      _MenuItem(
        title: Strings.themedTests,
        imagePath: AppIcons.homeThemedTests,
        onTap: (context) {
          context.rootNavigator.pushPage(TopicsScreen()).then((value) {
            context.addBlocEvent<HomeBloc>(GetMistakeHistoryEvent());
          });
        },
      ),
      _MenuItem(
        title: Strings.homeDistractionQuestions,
        imagePath: AppIcons.homeDistractorQuestions,
        onTap: (context) {
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
      ),
      _MenuItem(
        title: Strings.marathon,
        imagePath: AppIcons.cup,
        onTap: (context) {
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
      ),
      _MenuItem(
        title: Strings.saved,
        imagePath: AppIcons.bookmarkOutline,
        onTap: (context) {
          context.rootNavigator.push(
            MaterialPageRoute(
              builder: (_) => const BookmarksScreen(),
            ),
          );
        },
      ),
      _MenuItem(
        title: Strings.errors,
        imagePath: AppIcons.error,
        onTap: (context) {
          context.rootNavigator.pushPage(MistakeHistoryScreen());
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    final expandedHeight = shortestSide * 0.65;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            SliverAppBar(
              elevation: 0,
              scrolledUnderElevation: 0,
              expandedHeight: expandedHeight,
              floating: false,
              pinned: true,
              stretch: true,
              backgroundColor: Color(0xff006FFD),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              systemOverlayStyle: const SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: Brightness.light,
              ),
              title: Row(
                // mainAxisSize: MainAxisSize.mi,
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
              // centerTitle: true,
              actions: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => context.rootNavigator.pushPage(SearchScreen()),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AppIcons.search),
                    ),
                  ),
                ),
                SizedBox(width: 16)
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      child: Image.asset(
                        AppImages.mainBackground,
                        fit: BoxFit.cover,
                      ),
                    ),
                    _buildMainProgressBar(context),
                  ],
                ),
                // stretchModes: const [
                //   StretchMode.zoomBackground,
                //   StretchMode.blurBackground,
                // ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(top: 5),
              sliver: SliverList.builder(
                itemCount: _menuItems.length + 1, // +1 для нижнего отступа
                itemBuilder: (context, index) {
                  if (index == _menuItems.length) {
                    return SizedBox(height: 16);
                  }

                  final item = _menuItems[index];
                  return HomeWidget(
                    title: item.title,
                    imagePath: item.imagePath,
                    onTap: () => item.onTap(context),
                  );
                },
              ),
            ),
            SliverFillRemaining(
              child: SizedBox
                  .expand(), 
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainProgressBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    final radius = shortestSide * 0.35;
    final lineWidth = shortestSide * 0.07;
    final percentFontSize = shortestSide * 0.12;
    final infoFontSize = shortestSide * 0.04;

    return Positioned(
      left: 0,
      right: 0,
      bottom: -shortestSide * 0.25,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final percent = state.questions.isNotEmpty
                  ? ((state.solveQuestionCount / state.questions.length) * 100)
                          .round() /
                      100
                  : 0.0;

              return CircularPercentIndicator(
                radius: radius,
                lineWidth: lineWidth,
                percent: percent,
                animation: false,
                circularStrokeCap: CircularStrokeCap.round,
                reverse: false,
                backgroundColor: Colors.blue.withOpacity(0.2),
                progressColor: AppColors.white,
                arcType: ArcType.HALF,
                arcBackgroundColor: const Color(0xff6A8FFF),
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
                        fontSize: percentFontSize,
                        color: AppColors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${Strings.tests}:",
                          style: context.textTheme.headlineSmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: infoFontSize,
                            color: AppColors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        state.isLoading
                            ? SizedBox(
                                width: infoFontSize,
                                height: infoFontSize,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppColors.white,
                                  ),
                                ),
                              )
                            : Text(
                                state.questions.isNotEmpty
                                    ? "${state.totalCount}/${state.questions.length}"
                                    : "0/0",
                                style:
                                    context.textTheme.headlineSmall!.copyWith(
                                  color: AppColors.white,
                                  fontSize: infoFontSize,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ],
                    ),
                    SizedBox(height: radius * 0.35),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final String imagePath;
  final Function(BuildContext) onTap;

  _MenuItem({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });
}
