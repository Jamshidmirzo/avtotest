import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/core/assets/constants/app_icons.dart';
import 'package:avtotest/core/generated/strings.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeRealExamWidget extends StatelessWidget {
  const HomeRealExamWidget({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Stack(
          children: [
            SvgPicture.asset(
              AppIcons.realExamBackground,
              width: (context.mediaQuery.size.width - 40) / 2,
            ),
            Positioned(
              right: 16,
              top: 16,
              child: Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(180),
                  color: Color(0xffFD8058),
                ),
                child: SvgPicture.asset(
                  AppIcons.leftAction,
                  colorFilter:
                      ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Strings.real,
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    Strings.exam,
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 22,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
