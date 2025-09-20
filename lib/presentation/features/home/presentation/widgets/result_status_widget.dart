import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';

class ResultStatusWidget extends StatelessWidget {
  const ResultStatusWidget(
      {super.key, required this.number, required this.resultStatus});

  final int number;
  final ResultStatus resultStatus;

  String get getTitle {
    switch (resultStatus) {
      case ResultStatus.correct:
        return Strings.correct;
      case ResultStatus.incorrect:
        return Strings.incorrect;
      case ResultStatus.notAnswered:
        return Strings.unanswered;
    }
  }

  Color get getContainerColor {
    switch (resultStatus) {
      case ResultStatus.correct:
        return const Color(0xff00933F);
      case ResultStatus.incorrect:
        return const Color(0xFFED3241);
      case ResultStatus.notAnswered:
        return AppColors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: context.themeExtension.paleBlueToCharcoalBlack,
      ),
      child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: getContainerColor,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Text(
            getTitle,
            style: context.textTheme.headlineSmall!.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(width: 4),
          Text(
            number.toString(),
            style: context.textTheme.headlineSmall!.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}

enum ResultStatus {
  correct,
  incorrect,
  notAnswered,
}
