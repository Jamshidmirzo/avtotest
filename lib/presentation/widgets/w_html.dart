import 'package:avtotest/core/assets/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class WHtml extends StatefulWidget {
  const WHtml({
    super.key,
    required this.data,
    this.textColor,
    this.textAlign,
    this.pFontSize,
    this.strongBrFontSize,
    this.brFontSize,
    this.olFontSize,
    this.pFontWeight,
    this.strongBrFontWeight,
    this.brFontWeight,
    this.olFontWeight,
  });

  final String data;
  final Color? textColor;
  final TextAlign? textAlign;
  final int? pFontSize;
  final int? strongBrFontSize;
  final int? brFontSize;
  final int? olFontSize;
  final FontWeight? pFontWeight;
  final FontWeight? strongBrFontWeight;
  final FontWeight? brFontWeight;
  final FontWeight? olFontWeight;

  @override
  State<WHtml> createState() => _WHtmlState();
}

class _WHtmlState extends State<WHtml> {
  bool isError = false;

  @override
  Widget build(BuildContext context) {
    return Html(
      data: widget.data,
      style: {
        "p": Style(
          color: widget.textColor ?? AppColors.mainDark,
          fontSize: FontSize(widget.pFontSize?.toDouble() ?? 14),
          fontWeight: widget.pFontWeight ?? FontWeight.w500,
          textAlign: widget.textAlign ?? TextAlign.start,
          margin: Margins.only(top: 16, bottom: 8),
          padding: HtmlPaddings.zero,
        ),
        "strong br ": Style(
            color: widget.textColor ?? AppColors.mainDark,
            fontSize: FontSize(widget.strongBrFontSize?.toDouble() ?? 20),
            fontWeight: widget.strongBrFontWeight ?? FontWeight.w500,
            textAlign: widget.textAlign ?? TextAlign.start,
            alignment: Alignment.center,
            verticalAlign: VerticalAlign.middle
            // color: mainDark,
            // width: Width.auto(),
            ),
        "br": Style(
            fontSize: FontSize(widget.brFontSize?.toDouble() ?? 20),
            color: widget.textColor ?? AppColors.mainDark,
            fontWeight: widget.brFontWeight ?? FontWeight.w900,
            textAlign: widget.textAlign ?? TextAlign.start,
            alignment: Alignment.center,
            verticalAlign: VerticalAlign.middle
            // color: mainDark,
            // width: Width.auto(),
            ),
        "ol": Style(
            color: widget.textColor ?? AppColors.mainDark,
            textAlign: widget.textAlign ?? TextAlign.start,
            fontSize: FontSize(widget.olFontSize?.toDouble() ?? 20),
            fontWeight: widget.olFontWeight ?? FontWeight.w700,
            // color: mainDark,
            alignment: Alignment.center,
            verticalAlign: VerticalAlign.middle
            // width: Width.auto(),
            ),
      },
    );
  }
}
