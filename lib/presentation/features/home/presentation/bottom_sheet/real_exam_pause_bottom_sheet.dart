import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';

class RealExamPauseBottomSheet extends StatelessWidget {
  const RealExamPauseBottomSheet({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: Strings.youFailedTheExam,
      hasClose: true,
      hasDivider: false,
      hasTitleHeader: true,
      titleCenter: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            textAlign: TextAlign.center,
            Strings.youCannotContinueTheExamDueToThreeErrors,
            style: context.textTheme.headlineSmall!,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: WButton(
                  rippleColor: Colors.transparent,
                  margin: EdgeInsets.only(bottom: context.mediaQuery.padding.bottom + 16),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  color: AppColors.vividBlue,
                  text: Strings.toHomepage,
                  textColor: AppColors.white,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Expanded(
                child: WButton(
                  rippleColor: Colors.transparent,
                  margin: EdgeInsets.only(bottom: context.mediaQuery.padding.bottom + 16),
                  onTap: onTap,
                  color: AppColors.vividBlue,
                  text: Strings.retry,
                  textColor: AppColors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
