import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/screens/components/clock_painter.dart';

class AnalogClock extends StatefulWidget {
  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  DateTime _dateTime = DateTime.now();

  Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          _dateTime = DateTime.now();
        });
      }
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    // TODO: implement deactivate
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 30,
        horizontal: 40,
      ),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                color: kShadowColor.withOpacity(0.14),
                blurRadius: 64,
              ),
            ],
          ),
          child: Transform.rotate(
            angle: -pi / 2,
            child: CustomPaint(
              painter: ClockPainter(context, _dateTime),
            ),
          ),
        ),
      ),
    );
  }
}
