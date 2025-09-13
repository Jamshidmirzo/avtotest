import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/core/utils/my_functions.dart';
import 'package:avtotest/presentation/widgets/default_bottomsheet.dart';
import 'package:avtotest/presentation/widgets/w_button.dart';
import 'package:avtotest/presentation/features/education/data/model/sign_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/assets/colors/app_colors.dart';

class RoadSignBottomSheet extends StatefulWidget {
  const RoadSignBottomSheet({super.key, required this.signModel});

  final SignModel signModel;

  @override
  State<RoadSignBottomSheet> createState() => _RoadSignBottomSheetState();
}

class _RoadSignBottomSheetState extends State<RoadSignBottomSheet> {
  String getTitle(String language) {
    switch (language) {
      case 'uz':
        return widget.signModel.signNameLa;
      case 'ru':
        return widget.signModel.signNameRu;
      case 'uk':
        return widget.signModel.signNameUz;
      default:
        return widget.signModel.signNameUz; // Default to Uzbek if no match found
    }
  }

  String getDescription(String language) {
    switch (language) {
      case 'uz':
        return widget.signModel.descriptionLa;
      case 'ru':
        return widget.signModel.descriptionRu;
      case 'uk':
        return widget.signModel.descriptionUz;
      default:
        return widget.signModel.descriptionUz; // Default to Uzbek if no match found
    }
  }

  @override
  Widget build(BuildContext context) {
    String language = context.locale.languageCode;
    return DefaultBottomSheet(
      title: "",
      hasClose: true,
      hasDivider: false,
      hasTitleHeader: true,
      titleCenter: true,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min, // <-- height contentcha bo‘ladi
              children: [
                SvgPicture.asset(
                  MyFunctions.getAssetsSvgImage(
                    widget.signModel.signImage,
                  ),
                  height: 80,
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    MyFunctions.removeHtmlTagsWithNewLines(getTitle(language)),
                    textAlign: TextAlign.center,
                    style: context.textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    MyFunctions.removeHtmlTagsWithNewLines(getDescription(language)),
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        WButton(
          rippleColor: Colors.transparent,
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: context.mediaQuery.padding.bottom + 16,
          ),
          onTap: () {
            Navigator.of(context).pop();
          },
          color: AppColors.vividBlue,
          text: Strings.understandable,
          textColor: AppColors.white,
        ),
      ],
    );
  }
}

