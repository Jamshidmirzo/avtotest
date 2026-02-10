import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/features/education/data/model/sign_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoadSignWidget extends StatelessWidget {
  const RoadSignWidget({
    super.key,
    required this.onTap,
    required this.index,
    required this.model,
  });

  final VoidCallback onTap;
  final int index;
  final SignModel model;

  String getTitle(String language) {
    switch (language) {
      case 'uz':
        return model.signNameLa;
      case 'ru':
        return model.signNameRu;
      case 'uk':
        return model.signNameUz;
      default:
        return model.signNameUz; // Default to Uzbek if no match found
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.themeExtension.whiteToGondola,
          border: Border.all(width: 1, color: AppColors.paleGray),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(MyFunctions.getAssetsSvgImage(model.signImage), width: 94, height: 94),
            Spacer(),
            Text(
              model.signNumber,
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              MyFunctions.removeHtmlTagsWithNewLines(getTitle(context.locale.languageCode)),
              style: context.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: context.themeExtension.cloudBurstToWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
