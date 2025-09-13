import 'dart:io';

import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class TappableArea extends StatelessWidget {
  final Color? splashColor;
  final Widget child;
  final VoidCallback onTap;
  final double borderRadius;
  final BuildContext context;
  final BorderRadius? borderRRadius;
  final bool isDisabled;

  const TappableArea({
    super.key,
    this.splashColor,
    required this.child,
    required this.onTap,
    this.borderRadius = 0,
    required this.context,
    this.borderRRadius,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDisabled) {
      return child;
    }
    if (Platform.isIOS) {
      return Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        borderRadius: borderRRadius ?? BorderRadius.circular(borderRadius),
        child: InkWell(
          splashColor: splashColor ?? AppColors.white.withOpacity(.1),
          splashFactory: NoSplash.splashFactory,
          highlightColor: splashColor ?? AppColors.white.withOpacity(.1),
          onTap: onTap,
          child: child,
        ),
      );
    } else {
      return Material(
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        borderRadius: borderRRadius ?? BorderRadius.circular(borderRadius),
        child: InkWell(
          hoverColor: AppColors.white.withOpacity(.02),
          focusColor: AppColors.white.withOpacity(.02),
          highlightColor: Colors.transparent,
          splashFactory: InkSplash.splashFactory,
          splashColor: AppColors.white.withOpacity(.01),
          overlayColor: WidgetStateProperty.all(AppColors.white.withOpacity(.1)),
          borderRadius: borderRRadius ?? BorderRadius.circular(borderRadius),
          onTap: onTap,
          child: child,
        ),
      );
    }
  }
}
