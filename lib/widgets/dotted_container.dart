
import 'dart:ui';

import 'package:flutter/material.dart';

class DottedBorderContainer extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;

  const DottedBorderContainer({super.key, 
    required this.child,
    this.borderWidth = 1.0,
    this.borderColor = Colors.grey,
    this.borderRadius = 0.0,
    this.dashWidth = 10.0,
    this.dashSpace = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DottedBorderPainter(
        borderWidth: borderWidth,
        borderColor: borderColor,
        borderRadius: borderRadius,
        dashWidth: dashWidth,
        dashSpace: dashSpace,
      ),
      child: child,
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  final double borderWidth;
  final Color borderColor;
  final double borderRadius;
  final double dashWidth;
  final double dashSpace;

  _DottedBorderPainter({
    required this.borderWidth,
    required this.borderColor,
    required this.borderRadius,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = borderColor
      ..strokeWidth = borderWidth
      ..style = PaintingStyle.stroke;

    var path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ));

    var dashPath = Path();
    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashPath.addPath(pathMetric.extractPath(distance, distance + dashWidth), Offset.zero);
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}