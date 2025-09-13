import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/home/home_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/questions_solve/questions_solve_bloc.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/half_circle_progress_widget.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/questions_result_widget.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/result_status_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, this.isError = false});

  final bool isError;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  void initState() {
    final bloc = context.read<QuestionsSolveBloc>();
    if (widget.isError) {
      bloc.add(RemoveStatisticsErrorEvent());
    } else {
      bloc.add(InsertQuestionAttemptsEvent());
      if (bloc.state.ticketId != -1) {
        bloc.add(InsertTicketStatisticsEvent());
      } else {
        if (bloc.state.topicId != -1) {
          bloc.add(InsertTopicStatisticsEvent());
        }
      }
    }
    super.initState();
  }

  int getCorrectAnswersCount(List<QuestionModel> questions) {
    return questions.where((question) => question.isAnswered && question.errorAnswerIndex == -1).length;
  }

  int getIncorrectAnswersCount(List<QuestionModel> questions) {
    return questions.where((question) => question.isAnswered && question.errorAnswerIndex != -1).length;
  }

  int getNotAnsweredCount(List<QuestionModel> questions) {
    return questions.where((question) => !question.isAnswered).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWrapper(
        title: Strings.result,
        hasBackButton: true,
        onTap: () {
          final state = context.read<QuestionsSolveBloc>().state;
          if (widget.isError) {
            context.read<HomeBloc>().add(GetMistakeHistoryEvent());
          } else {
            if (state.ticketId != -1) {
              context.read<HomeBloc>().add(GetTicketsStatisticsEvent());
            } else {
              if (state.topicId != -1) {
                context.read<HomeBloc>().add(ParseTopicsEvent());
              }
            }
          }
          Navigator.of(context).pop();
        },
      ),
      body: BlocBuilder<QuestionsSolveBloc, QuestionsSolveState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 12,
                ),
                HalfCircleProgressIndicator(
                  firstSegmentPercentage: getCorrectAnswersCount(state.questions) / state.questions.length,
                  secondSegmentPercentage: getNotAnsweredCount(state.questions) / state.questions.length,
                  thirdSegmentPercentage: getIncorrectAnswersCount(state.questions) / state.questions.length,
                  strokeWidth: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        Strings.total,
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "${(getCorrectAnswersCount(state.questions) / state.questions.length * 100).toStringAsFixed(0)}%",
                        style: context.textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 48,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: context.themeExtension.offWhiteBlueTintToGondola,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcons.alarm,
                        colorFilter: ColorFilter.mode(
                          context.themeExtension.blackToWhite!,
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        Strings.totalTimeSpent,
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      Spacer(),
                      Text(
                        MyFunctions.formatDuration((state.totalTime - state.time)),
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ResultStatusWidget(
                          number: getCorrectAnswersCount(state.questions),
                          resultStatus: ResultStatus.correct,
                        ),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: ResultStatusWidget(
                          number: getNotAnsweredCount(state.questions),
                          resultStatus: ResultStatus.notAnswered,
                        ),
                      ),
                      SizedBox(width: 6),
                      Expanded(
                        child: ResultStatusWidget(
                          number: getIncorrectAnswersCount(state.questions),
                          resultStatus: ResultStatus.incorrect,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                    padding: EdgeInsets.only(bottom: context.mediaQuery.padding.bottom + 16, top: 16),
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return QuestionsResultWidget(
                        questionModel: state.questions[index],
                        index: index + 1,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: 12,
                      );
                    },
                    itemCount: state.questions.length)
              ],
            ),
          );
        },
      ),
    );
  }
}
