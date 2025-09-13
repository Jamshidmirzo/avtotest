import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({
    required this.allText,
    this.caseSensitive = false,
    this.maxLines,
    this.overflow = TextOverflow.clip,
    this.highlightedText,
    this.terms,
    this.textAlign = TextAlign.left,
    this.textStyle = const TextStyle(color: Colors.black),
    this.highlightTextStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    this.wordDelimiters = ' .,;?!<>[]~`@#\$%^&*()+-=|/_',
    this.words = false,
    this.highlightColor = Colors.orange,
    super.key,
  });

  final bool caseSensitive;
  final TextOverflow overflow;
  final int? maxLines;
  final String? highlightedText;
  final List<String>? terms;
  final String allText;
  final TextAlign textAlign;
  final TextStyle textStyle;
  final TextStyle highlightTextStyle;
  final String wordDelimiters;
  final bool words;
  final Color highlightColor;

  @override
  Widget build(BuildContext context) {
    // Convert the text and terms to lowercase if case sensitivity is disabled
    final String textToSearch = caseSensitive ? allText : allText.toLowerCase();
    final List<String> termsToHighlight = [if (highlightedText?.isNotEmpty ?? false) highlightedText!, ...?terms]
        .where((term) => term.isNotEmpty)
        .map((term) => caseSensitive ? term : term.toLowerCase())
        .toList();

    List<InlineSpan> spans = [];
    int start = 0;

    while (start < textToSearch.length) {
      // Find the nearest match
      int? closestMatchIndex;
      int? closestMatchLength;

      for (final term in termsToHighlight) {
        final index = textToSearch.indexOf(term, start);

        if (index != -1 && (closestMatchIndex == null || index < closestMatchIndex)) {
          closestMatchIndex = index;
          closestMatchLength = term.length;
        }
      }

      if (closestMatchIndex == null) {
        // Add the remaining text as non-highlighted
        spans.add(TextSpan(text: allText.substring(start), style: textStyle));
        break;
      }

      // Add non-highlighted text before the match
      if (start < closestMatchIndex) {
        spans.add(TextSpan(
          text: allText.substring(start, closestMatchIndex),
          style: textStyle,
        ));
      }

      // Add highlighted text
      spans.add(TextSpan(
        text: allText.substring(
          closestMatchIndex,
          closestMatchIndex + closestMatchLength!,
        ),
        style: highlightTextStyle.copyWith(
          backgroundColor: highlightColor,
        ),
      ));

      // Move the start index past the match
      start = closestMatchIndex + closestMatchLength;
    }

    return RichText(
      maxLines: maxLines,
      overflow: overflow,
      text: TextSpan(children: spans, style: textStyle),
      textAlign: textAlign, textScaler: TextScaler.linear(MediaQuery.of(context).textScaleFactor),
    );
  }
}
