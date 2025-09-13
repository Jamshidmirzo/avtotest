import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_images.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/features/education/presentation/screens/road_main_signs_screen.dart'
    show RoadMainSignsScreen;
import 'package:avtotest/presentation/features/education/presentation/screens/road_terms_screen.dart';
import 'package:avtotest/presentation/features/education/presentation/widgets/education_card_widget.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/utils/navigator_extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'WebViewScreen.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(), // 👈 adds springy effect
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight:
                MediaQuery.of(context).size.height, // 👈 гарантируем скролл
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              EducationCardWidget(
                positionedImage: Positioned(
                  right: 0,
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child:
                      Image.asset(AppImages.education1, width: 56, height: 51),
                ),
                title: Strings.trafficLaws,
                description: Strings.lawOfTheRepublicOfUzbekistan,
                backgroundColor: context.themeExtension.paleBlueToAshGray!,
                iconBackgroundColor: AppColors.lightSkyBlue,
                alignment: Alignment.center,
                onTap: () {
                  final langCode = context.locale.languageCode;
                  String url;
                  if (langCode == 'uz') {
                    url = "https://lex.uz/docs/-5953883"; // ruscha versiya
                  } else {
                    url = "https://lex.uz/uz/docs/5953883"; // o‘zbekcha default
                  }
                  context.rootNavigator.push(
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: url,
                        title: Strings.webpageTitle,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              EducationCardWidget(
                positionedImage: Positioned(
                  right: 0,
                  left: 0,
                  top: 0,
                  bottom: -4,
                  child:
                      Image.asset(AppImages.education2, width: 56, height: 51),
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
              EducationCardWidget(
                positionedImage: Positioned(
                  right: 0,
                  left: 0,
                  top: 0,
                  bottom: -4,
                  child:
                      Image.asset(AppImages.education3, width: 56, height: 51),
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
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
