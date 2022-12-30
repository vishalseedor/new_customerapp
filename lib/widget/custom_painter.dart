import 'package:flutter/material.dart';

class DrawDottedhorizontalline extends CustomPainter {
  Paint _paint;
  DrawDottedhorizontalline() {
    _paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
  }


  @override
  void paint(Canvas canvas, Size size) {
    for(double i = -300; i < 300; i = i + 15){
      if(i% 3 == 0)
      canvas.drawLine(Offset(i, 0.3), Offset(i+9, 0.0), _paint);
    }
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

