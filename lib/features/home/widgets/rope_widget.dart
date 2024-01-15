import 'package:flutter/material.dart';

class RopeWidget extends CustomPainter {
  final Color ropeColor;
  final Offset springOffset, anchorOffset;

  const RopeWidget({
    required this.ropeColor,
    required this.springOffset,
    required this.anchorOffset,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final ropePaint = Paint()
      ..color = ropeColor
      ..strokeWidth = 3;
    size.center(Offset.zero);
    canvas.drawLine(anchorOffset, springOffset, ropePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
