import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/w_scale_animation.dart';
import 'package:flutter/material.dart';

class EducationCardWidget extends StatelessWidget {
  final Widget positionedImage;
  final String title;
  final String description;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final Alignment alignment;
  final VoidCallback onTap;

  const EducationCardWidget({
    super.key,
    required this.positionedImage,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.iconBackgroundColor,
    this.alignment = Alignment.bottomCenter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return WScaleAnimation(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  constraints: const BoxConstraints(
                    minWidth: 64,
                    minHeight: 64,
                  ),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(64),
                  ),
                ),
                positionedImage,
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.bodySmall!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: context.themeExtension.cloudBurstToWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
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
    );
  }
}
