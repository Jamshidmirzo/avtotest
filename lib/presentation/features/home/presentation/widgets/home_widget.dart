import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/w_scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({
    super.key,
    required this.title,
    this.widget,
    required this.onTap,
    this.padding,
    required this.imagePath,
  });

  final String title;
  final Widget? widget;
  final VoidCallback onTap;
  final EdgeInsets? padding;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return WScaleAnimation(
      scaleValue: 0.99,
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        padding: padding ?? EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        constraints: BoxConstraints(minHeight: 48),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.themeExtension.whiteToGondola,
          border: Border.all(
            width: 1.5,
            color: context.themeExtension.whiteSmokeToWhiteSmoke!,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: context.textTheme.headlineSmall!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: context.themeExtension.vividBlueToWhite,
              ),
            ),
            widget ??
                SvgPicture.asset(
                  imagePath,
                  colorFilter: ColorFilter.mode(
                    context.themeExtension.vividBlueToWhite!,
                    BlendMode.srcIn,
                  ),
                  height: 28,
                  fit: BoxFit.contain,
                ),
          ],
        ),
      ),
    );
  }
}
