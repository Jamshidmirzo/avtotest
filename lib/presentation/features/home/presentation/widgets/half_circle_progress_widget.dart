import 'dart:math';

import 'package:avtotest/presentation/utils/extensions.dart';
import 'package:flutter/material.dart';

class HalfCircleProgressIndicator extends StatelessWidget {
  const HalfCircleProgressIndicator({
    super.key,
    required this.firstSegmentPercentage,
    required this.secondSegmentPercentage,
    required this.thirdSegmentPercentage,
    this.child,
    this.strokeWidth,
  });

  final double firstSegmentPercentage;
  final double secondSegmentPercentage;
  final double thirdSegmentPercentage;
  final Widget? child;
  final int? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final width = context.mediaQuery.size.width - 140;
    final height = (context.mediaQuery.size.width - 100) / 2;
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: MultiSegmentHalfPainter(
              segments: [
                Segment(percentage: firstSegmentPercentage, color: Colors.green),
                Segment(percentage: secondSegmentPercentage, color: Color(0xffEAF2FF)),
                Segment(percentage: thirdSegmentPercentage, color: Colors.red),
              ],
              strokeWidth: strokeWidth ?? 40,
            ),
          ),
          if (child != null)
            Positioned(
              bottom: 0,
              child: child!,
            ),
        ],
      ),
    );
  }
}

class Segment {
  final double percentage;
  final Color color;

  Segment({required this.percentage, required this.color});
}

class MultiSegmentHalfPainter extends CustomPainter {
  final List<Segment> segments;
  final int strokeWidth;

  MultiSegmentHalfPainter({
    required this.segments,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    double startAngle = pi; // Start from the top of the half circle

    for (var segment in segments) {
      final sweepAngle = pi * segment.percentage;

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth.toDouble()
        ..strokeCap = StrokeCap.round; // Rounded caps

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
