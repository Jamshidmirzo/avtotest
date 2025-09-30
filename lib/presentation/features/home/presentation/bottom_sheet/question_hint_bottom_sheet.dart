import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:avtotest/presentation/widgets/w_html.dart';
import 'package:flutter/material.dart';

class QuestionHintBottomSheet extends StatelessWidget {
  const QuestionHintBottomSheet({super.key, required this.question});

  final String question;

  @override
  Widget build(BuildContext context) {
    return DefaultBottomSheet(
      title: Strings.comment,
      hasClose: true,
      hasDivider: false,
      hasTitleHeader: true,
      titleCenter: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WHtml(
                data: question,
                pFontSize: 16,
                pFontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
                textColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : AppColors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 12,
        ),
        WButton(
          rippleColor: Colors.transparent,
          margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: context.mediaQuery.padding.bottom + 16),
          onTap: () {
            Navigator.of(context).pop();
          },
          color: AppColors.vividBlue,
          text: Strings.understandable,
          textColor: AppColors.white,
        )
      ],
    );
  }
}
