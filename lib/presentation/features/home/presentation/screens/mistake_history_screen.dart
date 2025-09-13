import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/utils/navigator_extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/widgets/empty_widget.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/bottom_sheet/choose_test_or_view_bottom_sheet.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/mistakes_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/screens/test_screen.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/mistake_history_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MistakeHistoryScreen extends StatefulWidget {
  const MistakeHistoryScreen({super.key});

  @override
  State<MistakeHistoryScreen> createState() => _MistakeHistoryScreenState();
}

class _MistakeHistoryScreenState extends State<MistakeHistoryScreen> {
  @override
  void initState() {
    context.read<HomeBloc>().add(GetMistakeHistoryEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBarWrapper(
              title: Strings.errors,
              hasBackButton: true,
            ),
            body: state.mistakeQuestions.isNotEmpty
                ? ListView.separated(
                    padding: EdgeInsets.only(
                      top: 13,
                      bottom: context.padding.bottom,
                    ),
                    itemBuilder: (context, index) {
                      return MistakeHistoryWidget(
                        model: state.mistakeQuestions[index],
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (ctx) {
                                return ChooseTestOrViewBottomSheet(
                                  onTapTest: () {
                                    context.read<HomeBloc>().add(
                                        GetMistakeQuestionsEvent(
                                            onSuccess: (List<QuestionModel>
                                                questions) {
                                              context.rootNavigator.pushPage(
                                                TestScreen(
                                                  questions: questions,
                                                  title: Strings.tests,
                                                  examType: ExamType.errorExam,
                                                  errorDate: state
                                                      .mistakeQuestions[index]
                                                      .date,
                                                ),
                                              );
                                            },
                                            isView: false,
                                            attempts: state
                                                .mistakeQuestions[index]
                                                .attempts));
                                  },
                                  onTapView: () {
                                    context.read<HomeBloc>().add(
                                        GetMistakeQuestionsEvent(
                                            onSuccess: (List<QuestionModel>
                                                questions) {
                                              context.rootNavigator.push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return MistakesScreen(
                                                    questions: questions);
                                              }));
                                            },
                                            isView: true,
                                            attempts: state
                                                .mistakeQuestions[index]
                                                .attempts));
                                  },
                                );
                              });
                        },
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 4),
                    itemCount: state.mistakeQuestions.length,
                  )
                : EmptyWidget());
      },
    );
  }
}
