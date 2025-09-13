import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';

import '../../../../../core/assets/colors/app_colors.dart';

class TimeEndBottomSheet extends StatelessWidget {
  const TimeEndBottomSheet({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: Strings.timeExpired,
      hasClose: true,
      hasDivider: false,
      hasTitleHeader: true,
      titleCenter: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            textAlign: TextAlign.center,
            Strings.testTimeIsOverPleaseCheckResults,
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
        WButton(
          rippleColor: Colors.transparent,
          margin: EdgeInsets.only(left: 16, right: 16, bottom: context.mediaQuery.padding.bottom + 16),
          onTap: onTap,
          color: AppColors.vividBlue,
          text: Strings.understandable,
          textColor:  AppColors.white,
        )
      ],
    );
  }
}
