import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/features/education/data/model/sign_main_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoadSignMainWidget extends StatelessWidget {
  const RoadSignMainWidget({
    super.key,
    required this.onTap,
    required this.index,
    required this.model,
  });

  final VoidCallback onTap;
  final int index;
  final SignMainModel model;

  String getTitle(String language) {
    switch (language) {
      case 'uz':
        return model.nameLa;
      case 'ru':
        return model.nameRu;
      case 'uk':
        return model.nameUz;
      default:
        return model.nameUz; // Default to Uzbek if no match found
    }
  }

  @override
  Widget build(BuildContext context) {
    String lang = context.locale.languageCode;
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
            SvgPicture.asset(MyFunctions.getAssetsSvgImage(model.media), width: 94, height: 94),
            Spacer(),
            Text(
              getTitle(lang),
              style: context.textTheme.bodySmall!.copyWith(
                fontWeight: FontWeight.w600,
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
