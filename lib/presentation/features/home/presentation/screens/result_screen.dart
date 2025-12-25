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
  late List<QuestionModel> questions;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<QuestionsSolveBloc>();
    questions = List.from(bloc.state.questions);

    if (widget.isError) {
      bloc.add(RemoveStatisticsErrorEvent());
    } else {
      bloc.add(InsertQuestionAttemptsEvent());
      if (bloc.state.ticketId != -1) {
        bloc.add(InsertTicketStatisticsEvent());
      } else if (bloc.state.topicId != -1) {
        bloc.add(InsertTopicStatisticsEvent());
      }
    }
  }

  int getCorrectAnswersCount(List<QuestionModel> list) =>
      list.where((q) => q.isAnswered && q.errorAnswerIndex == -1).length;

  int getIncorrectAnswersCount(List<QuestionModel> list) =>
      list.where((q) => q.isAnswered && q.errorAnswerIndex != -1).length;

  int getNotAnsweredCount(List<QuestionModel> list) =>
      list.where((q) => !q.isAnswered).length;

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
          } else if (state.ticketId != -1) {
            context.read<HomeBloc>().add(GetTicketsStatisticsEvent());
          } else if (state.topicId != -1) {
            context.read<HomeBloc>().add(ParseTopicsEvent());
          }
          Navigator.of(context).pop();
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 12),
                HalfCircleProgressIndicator(
                  firstSegmentPercentage:
                      getCorrectAnswersCount(questions) / questions.length,
                  secondSegmentPercentage:
                      getNotAnsweredCount(questions) / questions.length,
                  thirdSegmentPercentage:
                      getIncorrectAnswersCount(questions) / questions.length,
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
                      const SizedBox(height: 4),
                      Text(
                        "${(getCorrectAnswersCount(questions) / questions.length * 100).toStringAsFixed(0)}%",
                        style: context.textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 48,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Время
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16)
                      .copyWith(top: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                      const SizedBox(width: 10),
                      Text(
                        Strings.totalTimeSpent,
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        MyFunctions.formatDuration(
                          (context.read<QuestionsSolveBloc>().state.totalTime -
                              context.read<QuestionsSolveBloc>().state.time),
                        ),
                        style: context.textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Статусы
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ResultStatusWidget(
                          number: getCorrectAnswersCount(questions),
                          resultStatus: ResultStatus.correct,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ResultStatusWidget(
                          number: getNotAnsweredCount(questions),
                          resultStatus: ResultStatus.notAnswered,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ResultStatusWidget(
                          number: getIncorrectAnswersCount(questions),
                          resultStatus: ResultStatus.incorrect,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          // список вопросов
          SliverList.separated(
            itemCount: questions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final q = questions[index];
              return QuestionsResultWidget(
                questionModel: q,
                index: index,
                onTapBookmark: () {
                  setState(() {
                    questions = questions.map((e) {
                      if (e.id == q.id) {
                        return e.copyWith(isBookmarked: !e.isBookmarked);
                      }
                      return e;
                    }).toList();
                  });
                },
              );
            },
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: context.mediaQuery.padding.bottom + 16),
          ),
        ],
      ),
    );
  }
}
