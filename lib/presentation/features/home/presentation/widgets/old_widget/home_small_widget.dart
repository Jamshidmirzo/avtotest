import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeSmallWidget extends StatelessWidget {
  const HomeSmallWidget({
    super.key,
    required this.onTap,
    required this.backgroundImage,
    required this.title,
    required this.icon,
    this.textColor,
  });

  final VoidCallback onTap;
  final String backgroundImage;
  final String title;
  final String icon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          SvgPicture.asset(
            backgroundImage,
            width: (context.mediaQuery.size.width - 40) / 2,
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: context.textTheme.headlineSmall!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor ?? AppColors.strongRed,
                    ),
                  ),
                  SvgPicture.asset(icon)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
