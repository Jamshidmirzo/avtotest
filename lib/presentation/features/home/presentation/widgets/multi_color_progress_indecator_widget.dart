import 'dart:math';

import 'package:flutter/material.dart';

class MultiSegmentCircle extends StatelessWidget {
  const MultiSegmentCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(200, 200),
      painter: MultiSegmentPainter(
        segments: [
          Segment(percentage: 0.25, color: Colors.red), // 25%
          Segment(percentage: 0.15, color: Colors.grey), // 15%
          Segment(percentage: 0.30, color: Colors.green), // 30%/ 30%
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

class MultiSegmentPainter extends CustomPainter {
  final List<Segment> segments;

  MultiSegmentPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final strokeWidth = 20.0;
    double startAngle = -pi / 2;

    for (var segment in segments) {
      final sweepAngle = 2 * pi * segment.percentage;

      final paint = Paint()
        ..color = segment.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt;

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
