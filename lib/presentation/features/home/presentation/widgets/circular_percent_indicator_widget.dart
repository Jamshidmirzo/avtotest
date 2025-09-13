import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/percent_indicator/circular_percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularPercentIndicatorWidget extends StatelessWidget {
  const CircularPercentIndicatorWidget({super.key, required this.percentage});

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 18.0,
      lineWidth: 3.0,
      percent: percentage / 100,
      center: percentage == 100
          ? SvgPicture.asset(
              AppIcons.check,
              colorFilter: ColorFilter.mode(AppColors.vividBlue, BlendMode.srcIn),
            )
          : Text(
              "${percentage.toStringAsFixed(0)}%",
              style: context.textTheme.headlineSmall!.copyWith(fontWeight: FontWeight.w600, fontSize: 10),
            ),
      progressColor: AppColors.vividBlue,
      backgroundColor: AppColors.lightGray,
      circularStrokeCap: CircularStrokeCap.butt,
      animation: true,
    );
  }
}
