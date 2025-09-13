import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:flutter/material.dart';

class DeleteBottomSheet extends StatelessWidget {
  const DeleteBottomSheet({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
  });

  final VoidCallback onTap;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: title,
      titleCenter: true,
      hasClose: true,
      hasDivider: false,
      crossAxisAlignment: CrossAxisAlignment.center,
      hasTitleHeader: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16).copyWith(top: 8),
          child: Text(
            textAlign: TextAlign.center,
            description,
            style: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: WButton(
                rippleColor: Colors.transparent,
                margin: EdgeInsets.only(left: 16, bottom: context.mediaQuery.padding.bottom + 16),
                onTap: () {
                  Navigator.pop(context);
                },
                color: AppColors.vividBlue,
                text: Strings.cancel,
                textColor: AppColors.white,
              ),
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: WButton(
                rippleColor: Colors.transparent,
                margin: EdgeInsets.only(right: 16, bottom: context.mediaQuery.padding.bottom + 16),
                onTap: onTap,
                color: AppColors.strongRed,
                text: Strings.delete,
                textColor: AppColors.white,
              ),
            ),
          ],
        )
      ],
    );
  }
}
