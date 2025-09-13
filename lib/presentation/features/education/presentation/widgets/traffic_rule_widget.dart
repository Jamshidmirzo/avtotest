import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';

class TrafficRuleWidget extends StatelessWidget {
  const TrafficRuleWidget({
    super.key,
    required this.onTap,
    required this.index,
    required this.title,
  });

  final VoidCallback onTap;
  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.themeExtension.offWhiteBlueTintToGondola,
          border: Border.all(width: 1, color: context.themeExtension.paleBlueToAshGray!),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "${index + 1}",
              style: context.textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 64,
                color: context.themeExtension.paleBlueToAshGray!,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  title,
                  style: context.textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: context.themeExtension.cloudBurstToWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
