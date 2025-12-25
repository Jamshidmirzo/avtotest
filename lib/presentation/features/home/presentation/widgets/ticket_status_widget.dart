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
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 3.h,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: context.themeExtension.whiteToGondola,
          border: Border.all(
            width: 1.w,
            color: const Color(0xFFC4C4C4),
          ),
        ),
        child: Stack(
          children: [
            /// Center: Ticket Number
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${entity.tickedId}",
                    style: context.textTheme.headlineLarge!.copyWith(
                      color: context.themeExtension.vividBlueToWhite,
                      fontSize: 18.sp, // 👈 адаптивный шрифт
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    "-${Strings.ticket}",
                    style: context.textTheme.headlineMedium!.copyWith(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 0,
              right: 0,
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
