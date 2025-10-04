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
  @override
  Widget build(BuildContext context) {
    final Color defaultColor = widget.textColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : AppColors.black);

    return Html(
      data: _cleanHtml(widget.data), // чистим инлайн цвет
      style: {
        "*": Style(
          // применяем цвет ко ВСЕМ тегам
          color: defaultColor,
        ),
        "p": Style(
          fontSize: FontSize(widget.pFontSize?.toDouble() ?? 14),
          fontWeight: widget.pFontWeight ?? FontWeight.w500,
          textAlign: widget.textAlign ?? TextAlign.start,
          margin: Margins.only(top: 16, bottom: 8),
          padding: HtmlPaddings.zero,
        ),
        "strong br": Style(
          fontSize: FontSize(widget.strongBrFontSize?.toDouble() ?? 20),
          fontWeight: widget.strongBrFontWeight ?? FontWeight.w500,
          textAlign: widget.textAlign ?? TextAlign.start,
          alignment: Alignment.center,
          verticalAlign: VerticalAlign.middle,
        ),
        "br": Style(
          fontSize: FontSize(widget.brFontSize?.toDouble() ?? 20),
          fontWeight: widget.brFontWeight ?? FontWeight.w900,
          textAlign: widget.textAlign ?? TextAlign.start,
          alignment: Alignment.center,
          verticalAlign: VerticalAlign.middle,
        ),
        "ol": Style(
          fontSize: FontSize(widget.olFontSize?.toDouble() ?? 20),
          fontWeight: widget.olFontWeight ?? FontWeight.w700,
          textAlign: widget.textAlign ?? TextAlign.start,
          alignment: Alignment.center,
          verticalAlign: VerticalAlign.middle,
        ),
      },
    );
  }

  /// Убираем inline-цвета из HTML (color: rgb(...) / hex и т.д.)
  String _cleanHtml(String html) {
    return html.replaceAll(
      RegExp(r'color\s*:\s*[^;"]+;?'),
      '',
    );
  }
}
