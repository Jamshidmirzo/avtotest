import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_images.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/features/education/presentation/screens/road_main_signs_screen.dart'
    show RoadMainSignsScreen;
import 'package:avtotest/presentation/features/education/presentation/screens/road_terms_screen.dart';
import 'package:avtotest/presentation/features/education/presentation/screens/video_education_screen.dart';
import 'package:avtotest/presentation/features/education/presentation/widgets/education_card_widget.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/utils/navigator_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          Strings.education,
          style: context.textTheme.bodySmall!.copyWith(
            color: context.themeExtension.charcoalBlackToWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          /// CARD 1 — LAWS
          // EducationCardWidget(
          //   positionedImage: Positioned(
          //     right: 0,
          //     left: 0,
          //     top: 0,
          //     bottom: 0,
          //     child: Image.asset(AppImages.education1, width: 56, height: 51),
          //   ),
          //   title: Strings.trafficLaws,
          //   description: Strings.lawOfTheRepublicOfUzbekistan,
          //   backgroundColor: context.themeExtension.paleBlueToAshGray!,
          //   iconBackgroundColor: AppColors.lightSkyBlue,
          //   alignment: Alignment.center,
          //   onTap: () {
          //     final langCode = context.locale.languageCode;
          //     String url = langCode == 'uz'
          //         ? "https://lex.uz/docs/-5953883"
          //         : "https://lex.uz/uz/docs/5953883";

          //     context.rootNavigator.push(
          //       MaterialPageRoute(
          //         builder: (context) => WebViewScreen(
          //           url: url,
          //           title: Strings.webpageTitle,
          //         ),
          //       ),
          //     );
          //   },
          // ),

          const SizedBox(height: 12),

          /// CARD 2 — ROAD SIGNS
          EducationCardWidget(
            positionedImage: Positioned(
              right: 0,
              left: 0,
              top: 0,
              bottom: -4,
              child: Image.asset(AppImages.education2, width: 56, height: 51),
            ),
            title: Strings.roadSigns,
            description: Strings.annex1ToTheTrafficRules,
            backgroundColor: context.themeExtension.snowToBastille!,
            iconBackgroundColor: const Color(0xFFFFD9D9),
            onTap: () => context.rootNavigator.pushPage(
              const RoadMainSignsScreen(),
            ),
          ),

          const SizedBox(height: 12),

          /// CARD 3 — TERMS
          EducationCardWidget(
            positionedImage: Positioned(
              right: 0,
              left: 0,
              top: 0,
              bottom: -4,
              child: Image.asset(AppImages.education3, width: 56, height: 51),
            ),
            title: Strings.terms,
            description:
                Strings.essentialTermsFrequentlyUsedInTrafficRegulations,
            backgroundColor: context.themeExtension.whiteIceToBlackMarlin!,
            iconBackgroundColor: const Color(0xFFDCF3ED),
            onTap: () {
              context.rootNavigator.push(
                MaterialPageRoute(builder: (context) {
                  return const RoadTermsScreen();
                }),
              );
            },
          ),

          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => context.rootNavigator.push(
                MaterialPageRoute(
                  builder: (context) => VideoEducationScreen(),
                )),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.bastille
                    : Color(0xFFF6F2FF),
                borderRadius: BorderRadius.circular(16),
              ),
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: 64,
                    height: 64,
                    constraints: const BoxConstraints(
                      minWidth: 64,
                      minHeight: 64,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFD5CBEC),
                      borderRadius: BorderRadius.circular(64),
                    ),
                    child: Image.asset(AppImages.video, width: 40, height: 40),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.tr('videoLesson'),
                          style: context.textTheme.bodySmall!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: context.themeExtension.cloudBurstToWhite,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.tr('videoLessonDescp'),
                          style: context.textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: context.themeExtension.cloudBurstToWhite,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
