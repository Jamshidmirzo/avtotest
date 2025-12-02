import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({
    super.key,
    required this.correctCount,
    required this.inCorrectCount,
    required this.noAnswerCount,
  });

  final int correctCount;
  final int inCorrectCount;
  final int noAnswerCount;

  @override
  Widget build(BuildContext context) {
    // Убрали внешний SizedBox с фиксированной шириной 46.w
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (inCorrectCount > 0) ...[
          _buildStatisticRow(
            icon: AppIcons.timesCircle,
            count: inCorrectCount,
            color: AppColors.red,
            context: context,
          ),
          SizedBox(height: 2.h),
        ],
        if (noAnswerCount > 0) ...[
          _buildStatisticRow(
            icon: AppIcons.commentInfo,
            count: noAnswerCount,
            color: const Color(0xffF8B63D),
            context: context,
          ),
          SizedBox(height: 2.h),
        ],
        if (correctCount > 0)
          _buildStatisticRow(
            icon: AppIcons.checkCircle,
            count: correctCount,
            color: const Color(0xff16AE62),
            context: context,
          ),
      ],
    );
  }

  Widget _buildStatisticRow({
    required String icon,
    required int count,
    required Color color,
    required BuildContext context,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SvgPicture.asset(
          icon,
          width: 15.w,
          height: 15.w,
        ),
        SizedBox(width: 4.w),
        // Убрали SizedBox(width: 20.w), который заставлял цифры падать
        Flexible(
          child: Text(
            count.toString(),
            textAlign: TextAlign.left,
            maxLines: 1, // Запрещаем перенос на новую строку
            style: context.textTheme.headlineMedium!.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
