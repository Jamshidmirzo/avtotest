import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';

class TestEndBottomSheet extends StatelessWidget {
  const TestEndBottomSheet({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: Strings.finishTest,
      hasClose: true,
      hasDivider: false,
      hasTitleHeader: true,
      titleCenter: true,
      isEndBottomSheet: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 20,
            top: 10,
          ),
          child: Text(
            textAlign: TextAlign.center,
            Strings.unansweredQuestionsExistDoYouWantToFinish,
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
                child: WButton(
              rippleColor: Colors.transparent,
              margin: EdgeInsets.only(
                  left: 16, bottom: context.mediaQuery.padding.bottom + 16),
              onTap: () {
                Navigator.pop(context);
              },
              color: AppColors.vividBlue,
              text: Strings.continueTo,
              textColor: AppColors.white,
            )),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: WButton(
                rippleColor: Colors.transparent,
                margin: EdgeInsets.only(
                    right: 16, bottom: context.mediaQuery.padding.bottom + 16),
                onTap: onTap,
                color: AppColors.strongRed,
                text: Strings.finish,
                textColor: AppColors.white,
              ),
            ),
          ],
        )
      ],
    );
  }
}
