import 'dart:math';

import 'package:flutter/material.dart';

class ClockPainter extends CustomPainter {
  final BuildContext context;
  final DateTime datetime;

  ClockPainter(this.context, this.datetime);
  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);

    double minX =
        centerX + size.width * 0.35 * cos((datetime.minute * 6) * pi / 180);
    double minY =
        centerY + size.width * 0.35 * sin((datetime.minute * 6) * pi / 180);

    canvas.drawLine(
      center,
      Offset(minX, minY),
      Paint()
        ..color = Theme.of(context).accentColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );

    double hourX = centerX +
        size.width *
            0.3 *
            cos((datetime.hour * 30 + datetime.minute * 0.5) * pi / 180);
    double hourY = centerY +
        size.width *
            0.3 *
            sin((datetime.hour * 30 + datetime.minute * 0.5) * pi / 180);

    canvas.drawLine(
      center,
      Offset(hourX, hourY),
      Paint()
        ..color = Theme.of(context).colorScheme.secondary
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10,
    );

    double secondX =
        centerX + size.width * 0.4 * cos((datetime.second * 6) * pi / 180);
    double secondY =
        centerY + size.width * 0.4 * sin((datetime.second * 6) * pi / 180);

    // Second Line
    canvas.drawLine(
        center, Offset(secondX, secondY), Paint()..color = Colors.red);

    Paint dotPaint = Paint()..color = Theme.of(context).primaryIconTheme.color;
    canvas.drawCircle(center, 24, dotPaint);
    canvas.drawCircle(
        center, 23, Paint()..color = Theme.of(context).backgroundColor);
    canvas.drawCircle(center, 10, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }
}
