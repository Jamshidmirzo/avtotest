import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';

class ChooseTestOrViewBottomSheet extends StatelessWidget {
  const ChooseTestOrViewBottomSheet({
    super.key,
    required this.onTapTest,
    required this.onTapView,
  });

  final VoidCallback onTapTest;
  final VoidCallback onTapView;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      textAlign: TextAlign.center,
      title: Strings
          .selectOneOfTheFollowingOptionsToRepeatTheIncorrectlySolvedQuestion,
      hasClose: true,
      hasDivider: false,
      hasTitleHeader: true,
      titleCenter: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 16,
        ),
        WButton(
          rippleColor: Colors.transparent,
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          onTap: () {
            Navigator.of(context).pop();
            onTapView();
          },
          color: AppColors.vividBlue,
          text: Strings.viewQuestion,
          textColor: AppColors.white,
        ),
        SizedBox(
          height: 8,
        ),
        WButton(
          rippleColor: Colors.transparent,
          margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: context.mediaQuery.padding.bottom + 16),
          onTap: () {
            Navigator.of(context).pop();
            onTapTest();
          },
          color: AppColors.vividBlue,
          text: Strings.solveTest,
          textColor: AppColors.white,
        )
      ],
    );
  }
}
