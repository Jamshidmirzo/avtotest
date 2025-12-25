import 'dart:async';

import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_touch_ripple/flutter_touch_ripple.dart';

class WButton extends StatelessWidget {
  final double? width;
  final double? height;
  final String text;
  final Color? color;
  final Color? rippleColor;
  final Color? textColor;
  final bool hasGradient;
  final TextStyle? textStyle;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final GestureTapCallback onTap;
  final BoxBorder? border;
  final double borderRadius;
  final Widget? child;
  final Widget? loadingWidget;
  final Color disabledColor;
  final bool isDisabled;
  final bool isLoading;
  final double? scaleValue;
  final List<BoxShadow>? shadow;

  const WButton({
    required this.onTap,
    this.text = '',
    this.color,
    this.textColor,
    this.borderRadius = 10,
    this.disabledColor = AppColors.grey3,
    this.isDisabled = false,
    this.isLoading = false,
    this.width,
    this.height,
    this.hasGradient = false,
    this.margin,
    this.padding,
    this.textStyle,
    this.border,
    this.child,
    this.scaleValue,
    this.shadow,
    this.loadingWidget,
    super.key,
    this.rippleColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonColor =
        isDisabled ? disabledColor : color ?? theme.primaryColor;
    final buttonTextColor = isDisabled
        ? AppColors.grey2
        : textColor ?? theme.textTheme.labelLarge!.color;
    final buttonGradient =
        hasGradient && !isDisabled ? AppColors.mainButtonGradient : null;

    return IgnorePointer(
      ignoring: isLoading || isDisabled,
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: TouchRipple(
          rippleColor: rippleColor ?? buttonTextColor?.withOpacity(0.3),
          // scaleValue: scaleValue ?? 0.95,
          onTap: () {
            if (!(isLoading || isDisabled)) {
              Timer.periodic(const Duration(milliseconds: 100), (timer) {
                onTap();
                timer.cancel();
              });
            }
          },
          // borderRadius: BorderRadius.circular(borderRadius),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: width,
            height: height ?? 44,
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: buttonGradient == null ? buttonColor : null,
              borderRadius: BorderRadius.circular(borderRadius),
              border: border,
              boxShadow: shadow ??
                  (theme.brightness == Brightness.light
                      ? [AppColors.shadowLight]
                      : [AppColors.shadowDark]),
              gradient: buttonGradient,
            ),
            child: isLoading
                ? loadingWidget ??
                    const Center(
                      child: CupertinoActivityIndicator(color: AppColors.white),
                    )
                : AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: textStyle ??
                        theme.textTheme.labelLarge!.copyWith(
                          fontSize: 15,
                          color: buttonTextColor,
                        ),
                    child: child ??
                        Text(
                          text,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}
