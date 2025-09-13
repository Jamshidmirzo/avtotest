import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget(
      {super.key,
      required this.correctCount,
      required this.inCorrectCount,
      required this.noAnswerCount});

  final int correctCount;
  final int inCorrectCount;
  final int noAnswerCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (inCorrectCount > 0) ...{
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.timesCircle,
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                inCorrectCount > 9
                    ? inCorrectCount.toString()
                    : " $inCorrectCount ",
                style: context.textTheme.headlineMedium!.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.red,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 2,
          )
        },
        if (noAnswerCount > 0) ...{
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.commentInfo,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                noAnswerCount > 9
                    ? noAnswerCount.toString()
                    : " $noAnswerCount ",
                style: context.textTheme.headlineMedium!.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xffF8B63D),
                ),
              ),
            ],
          ),
          SizedBox(height: 2)
        },
        if (correctCount > 0)
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppIcons.checkCircle,
              ),
              SizedBox(
                width: correctCount > 9 ? 5 : 2,
              ),
              // Spacer(),
              Text(
                correctCount > 9 ? correctCount.toString() : " $correctCount ",
                style: context.textTheme.headlineMedium!.copyWith(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff16AE62),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
