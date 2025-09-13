import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:avtotest/presentation/widgets/w_scale_animation.dart';
import 'package:flutter/material.dart';

class DefaultBottomSheet extends StatelessWidget {
  const DefaultBottomSheet({
    super.key,
    required this.children,
    this.closeIconSize = 24,
    required this.title,
    required this.hasDivider,
    this.hasTitleHeader = true,
    this.hasClose = false,
    this.mainAxisSize = MainAxisSize.min,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.onTapX,
    this.dividerColor,
    this.containerColor,
    this.hasBottomPadding = true,
    this.titleCenter = true,
    this.headerColor,
    this.onTapBack,
  });

  final List<Widget> children;
  final String title;
  final MainAxisSize? mainAxisSize;
  final bool titleCenter;
  final bool hasDivider;
  final Color? dividerColor;
  final bool hasClose;
  final CrossAxisAlignment crossAxisAlignment;
  final Function()? onTapX;
  final bool hasBottomPadding;
  final bool hasTitleHeader;
  final Color? containerColor;
  final double closeIconSize;
  final VoidCallback? onTapBack;
  final Color? headerColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: BoxDecoration(
        color: containerColor ?? context.themeExtension.whiteToGondola,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: mainAxisSize ?? MainAxisSize.min,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Container(
            decoration: BoxDecoration(
              color: containerColor ?? context.themeExtension.whiteToGondola,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            ),
            // padding: EdgeInsets.fromLTRB(hasBackButton ? 0 : 20, 0, 0, 0),
            child: Column(
              children: [
                if (hasTitleHeader) ...{
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.grey2,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.only(top: 8),
                    height: 4,
                    width: 40,
                  ),
                },
                Container(
                  padding: const EdgeInsets.only(top: 2, left: 16),
                  decoration: BoxDecoration(
                    color: headerColor ?? containerColor ?? context.themeExtension.whiteToGondola,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 24),
                          child: titleCenter
                              ? Center(
                                  child: Text(
                                    title,
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                )
                              : Text(
                                  title,
                                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.mainDark,
                                      ),
                                ),
                        ),
                      ),
                      if (hasClose) ...{
                        WScaleAnimation(
                          onTap: onTapX ?? () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              '',
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.grey4),
                            ),
                          ),
                        ),
                      } else ...{
                        WScaleAnimation(
                          onTap: onTapX ?? () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(12, 16, 10, 0),
                            child: CircleAvatar(
                              backgroundColor: AppColors.white,
                              radius: 14,
                              child: Icon(
                                Icons.close,
                                size: closeIconSize,
                                color: context.theme.iconTheme.color,
                                // color: context.themeExtension.icon,
                              ),
                            ),
                          ),
                        ),
                      },
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (hasDivider) Divider(height: 0, thickness: 1, color: dividerColor ?? AppColors.white),
          ...children,
        ],
      ),
    );
  }
}
