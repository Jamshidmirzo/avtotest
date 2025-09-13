import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/widgets/w_highlighted_text.dart';
import 'package:avtotest/presentation/features/education/data/model/term_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RoadTermWidget extends StatelessWidget {
  const RoadTermWidget({
    super.key,
    required this.termModel,
    this.highlightedText = "",
  });

  final TermModel termModel;
  final String highlightedText;

  String getTitle(String language) {
    switch (language) {
      case 'uz':
        return termModel.termLa;
      case 'ru':
        return termModel.termUz;
      case 'uk':
        return termModel.termUz;
      default:
        return termModel.termUz; // Default to Uzbek if no match found
    }
  }

  String getDescription(String language) {
    switch (language) {
      case 'uz':
        return termModel.definitionLa;
      case 'ru':
        return termModel.definitionUz;
      case 'uk':
        return termModel.definitionUz;
      default:
        return termModel.definitionUz; // Default to Uzbek if no match found
    }
  }

  @override
  Widget build(BuildContext context) {
    final language = context.locale.languageCode;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.themeExtension.offWhiteBlueTintToGondola,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HighlightedText(
            highlightedText: highlightedText,
            highlightTextStyle: context.textTheme.headlineSmall!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            textStyle: context.textTheme.headlineSmall!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
            allText: MyFunctions.capitalizeFirstLetter(text: getTitle(language)),
          ),
          SizedBox(
            height: 8,
          ),
          HighlightedText(
            highlightedText: highlightedText,
            allText: MyFunctions.capitalizeFirstLetter(
              text: getDescription(language),
            ),
            textStyle: context.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
