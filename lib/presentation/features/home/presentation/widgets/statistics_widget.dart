import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return SizedBox(
      width: 44,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (inCorrectCount > 0) ...[
            _buildStatisticRow(
              icon: AppIcons.timesCircle,
              count: inCorrectCount,
              color: AppColors.red,
              context: context,
            ),
            const SizedBox(height: 2),
          ],
          if (noAnswerCount > 0) ...[
            _buildStatisticRow(
              icon: AppIcons.commentInfo,
              count: noAnswerCount,
              color: const Color(0xffF8B63D),
              context: context,
            ),
            const SizedBox(height: 2),
          ],
          if (correctCount > 0)
            _buildStatisticRow(
              icon: AppIcons.checkCircle,
              count: correctCount,
              color: const Color(0xff16AE62),
              context: context,
            ),
        ],
      ),
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
          width: 16,
          height: 16,
        ),
        const SizedBox(width: 4),
        SizedBox(
          width: 22,
          child: Text(
            count.toString(),
            textAlign: TextAlign.left,
            style: context.textTheme.headlineMedium!.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
