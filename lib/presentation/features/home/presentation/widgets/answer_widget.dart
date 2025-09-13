import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:flutter/material.dart';

class AnswerWidget extends StatelessWidget {
  const AnswerWidget({
    super.key,
    required this.title,
    required this.status,
    required this.index,
    required this.onTap,
    required this.answerFontSize,
  });

  final String title;
  final AnswerStatus status;
  final int index;
  final VoidCallback onTap;
  final int answerFontSize;

  Color backgroundColor(BuildContext context) {
    switch (status) {
      case AnswerStatus.correct:
        return Color(0xff00933F);
      case AnswerStatus.incorrect:
        return AppColors.strongRed;
      case AnswerStatus.notAnswered:
        return context.themeExtension.whiteToGondola!;
      case AnswerStatus.confirm:
        return AppColors.vividBlue;
    }
  }

  Color textColor(BuildContext context) {
    switch (status) {
      case AnswerStatus.correct:
        return AppColors.white;
      case AnswerStatus.incorrect:
        return AppColors.white;
      case AnswerStatus.notAnswered:
        return context.themeExtension.blackToWhite!;
      case AnswerStatus.confirm:
        return AppColors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: backgroundColor(context),
          border: Border.all(
            width: 1,
            color: status == AnswerStatus.notAnswered
                ? context.themeExtension.whiteSmokeToTransparent!
                : Colors.transparent,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 7,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "F${index + 1}",
                style: context.textTheme.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: textColor(context),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 4, bottom: 6),
                child: Text(
                  MyFunctions.removeHtmlTagsWithSpaces(title),
                  textAlign: TextAlign.start,
                  style: context.textTheme.headlineSmall!.copyWith(
                    color: textColor(context),
                    fontSize: answerFontSize.toDouble(),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum AnswerStatus {
  correct,
  confirm,
  incorrect,
  notAnswered,
}
