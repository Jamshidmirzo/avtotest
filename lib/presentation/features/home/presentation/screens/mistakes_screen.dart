import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/questions_result_widget.dart';
import 'package:flutter/material.dart';

class MistakesScreen extends StatefulWidget {
  const MistakesScreen({super.key, required this.questions});

  final List<QuestionModel> questions;

  @override
  State<MistakesScreen> createState() => _ErrorQuestionViewScreenState();
}

class _ErrorQuestionViewScreenState extends State<MistakesScreen> {
  late List<QuestionModel> questions;

  @override
  void initState() {
    questions = widget.questions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWrapper(
        title: Strings.tests,
        hasBackButton: true,
      ),
      body: ListView.separated(
          padding: EdgeInsets.only(bottom: context.mediaQuery.padding.bottom + 16, top: 16),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return QuestionsResultWidget(
              onTapBookmark: () {
                questions = questions.map((e) {
                  if (e.id == questions[index].id) {
                    return e.copyWith(isBookmarked: !e.isBookmarked);
                  }
                  return e;
                }).toList();
                setState(() {});
              },
              questionModel: questions[index],
              index: index + 1,
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 12,
            );
          },
          itemCount: questions.length),
    );
    ;
  }
}
