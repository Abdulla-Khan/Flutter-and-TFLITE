import 'package:flutter/material.dart';
import '../../../model/detection_model.dart';

class BoundingBoxPainter extends CustomPainter {
  final List<Detection> detections;
  final int imageWidth;
  final int imageHeight;
  final Set<int> selectedIndices;

  BoundingBoxPainter(
    this.detections,
    this.imageWidth,
    this.imageHeight,
    this.selectedIndices,
  );

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < detections.length; i++) {
      final det = detections[i];
      final left = (det.x - det.w / 2) * size.width;
      final top = (det.y - det.h / 2) * size.height;
      final right = (det.x + det.w / 2) * size.width;
      final bottom = (det.y + det.h / 2) * size.height;
      final rect = Rect.fromLTRB(left, top, right, bottom);

      final isSelected = selectedIndices.contains(i);

      final paint = Paint()
        ..color = isSelected
            ? Colors.green.withOpacity(0.4)
            : Colors.red.withOpacity(0.4)
        ..style = PaintingStyle.fill;

      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
