import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/features/home/data/entity/ticket_statistics_entity.dart';
import 'package:avtotest/presentation/features/home/presentation/widgets/statistics_widget.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TicketStatusWidget extends StatelessWidget {
  const TicketStatusWidget({
    super.key,
    required this.onTap,
    required this.entity,
  });

  final TicketStatisticsEntity entity;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          left: 6.w,
          right: 6.w,
          top: 2.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.themeExtension.whiteToGondola,
          border: Border.all(width: 1, color: Color(0xFFC4C4C4)),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${entity.tickedId}",
                  style: context.textTheme.headlineLarge!.copyWith(
                    color: context.themeExtension.vividBlueToWhite,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "-${Strings.ticket}",
                  style: context.textTheme.headlineMedium!.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topRight,
              child: StatisticsWidget(
                correctCount: entity.correctCount,
                inCorrectCount: entity.inCorrectCount,
                noAnswerCount: entity.noAnswerCount,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
