import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/widgets/w_html.dart';
import 'package:avtotest/presentation/features/home/data/model/topic_model.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/statistics_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class TopicWidget extends StatelessWidget {
  const TopicWidget({
    super.key,
    required this.topic,
    required this.onTap,
  });

  final TopicModel topic;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.themeExtension.whiteToGondola,
          border: Border.all(width: 1, color: Color(0xFFC4C4C4)),
        ),
        child: Row(
          children: [
            Expanded(
              child: WHtml(
                data: MyFunctions.getLessonTitle(lesson: topic, lang: lang),
                pFontSize: 17,
                textColor: context.themeExtension.mainBlackToWhite,
              ),
            ),
            // SizedBox(width: 4),
            StatisticsWidget(
              correctCount: topic.correctCount,
              inCorrectCount: topic.incorrectCount,
              noAnswerCount: topic.noAnswerCount,
            ),
          ],
        ),
      ),
    );
  }
}
