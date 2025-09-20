import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/features/home/presentation/blocs/audio_bloc/audio_bloc.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/app_bar_wrapper.dart';
import 'package:avtotest/presentation/features/home/data/model/question_model.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/questions_result_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MistakesScreen extends StatefulWidget {
  const MistakesScreen({super.key, required this.questions});
  final List<QuestionModel> questions;

  @override
  State<MistakesScreen> createState() => _MistakesScreenState();
}

class _MistakesScreenState extends State<MistakesScreen> {
  late List<QuestionModel> questions;

  @override
  void initState() {
    super.initState();
    questions = widget.questions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWrapper(
        title: Strings.tests,
        hasBackButton: true,
      ),
      body: ListView.separated(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return QuestionsResultWidget(
            questionModel: questions[index],
            index: index,
            onTapBookmark: () {
              setState(() {
                questions = questions.map((e) {
                  if (e.id == questions[index].id) {
                    return e.copyWith(isBookmarked: !e.isBookmarked);
                  }
                  return e;
                }).toList();
              });
            },
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
      ),
    );
  }
}
