import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/utils/navigator_extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/widgets/empty_widget.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/bottom_sheet/delete_sheet.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/test_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/topic_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
    return Scaffold(
      appBar: AppBarWrapper(
        title: Strings.themedTests,
        hasBackButton: true,
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  useRootNavigator: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return DeleteBottomSheet(
                      onTap: () {
                        context
                            .read<HomeBloc>()
                            .add(DeleteTopicStatisticsEvent());
                        Navigator.of(context).pop();
                      },
                      title: Strings.deleteTicketResults,
                      description:
                          Strings.allResultsWillBeDeletedDoYouWantToProceed,
                    );
                  });
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: SvgPicture.asset(
                  AppIcons.trash,
                  colorFilter: ColorFilter.mode(
                      context.themeExtension.mainBlackToWhite!,
                      BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return state.topics.isNotEmpty
              ? ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)
                      .copyWith(
                    bottom: context.mediaQuery.padding.bottom + 16,
                  ),
                  itemBuilder: (context, index) {
                    return TopicWidget(
                      topic: state.topics[index],
                      onTap: () {
                        context.read<HomeBloc>().add(
                              GetTopicQuestionsEvent(
                                topicId: state.topics[index].id,
                                onSuccess: (questions) {
                                  context.rootNavigator.push(
                                      MaterialPageRoute(builder: (context) {
                                    String lessonTitleOrg =
                                        state.topics[index].titleUz;
                                    String lessonTitleFormatted =
                                        MyFunctions.getLessonTitle(
                                                lesson: state.topics[index],
                                                lang: lang)
                                            .replaceAll("<p>", "")
                                            .replaceAll("</p>", "");
                                    return TestScreen(
                                      questions: questions,
                                      title: lessonTitleFormatted,
                                      lessonId: state.topics[index].id,
                                      examType: ExamType.topicExam,
                                    );
                                  })).then((value) {
                                    context
                                        .read<HomeBloc>()
                                        .add(ParseTopicsEvent());
                                  });
                                },
                              ),
                            );
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 5);
                  },
                  itemCount: state.topics.length)
              : EmptyWidget();
        },
      ),
    );
  }
}
