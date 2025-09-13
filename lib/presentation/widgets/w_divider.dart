import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';

class WDivider extends StatelessWidget {
  const WDivider({
    super.key,
    this.color,
    this.indent,
    this.endIndent,
    this.height,
    this.thickness,
  });

  final Color? color;
  final double? indent;
  final double? endIndent;
  final double? height;
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height ?? 1,
      thickness: thickness ?? 1,
      color: color ?? AppColors.paleGray,
      indent: indent ?? 0,
      endIndent: endIndent ?? 0,
    );
  }
}
