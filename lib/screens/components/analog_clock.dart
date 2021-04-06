import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/screens/components/clock_painter.dart';
import 'package:songaree_worktime/size_config.dart';

class AnalogClock extends StatefulWidget {
  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  DateTime _dateTime = DateTime.now();

  Timer? _timer;

  @override
  void initState() {
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
    _timer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getProportionateScreenWidth(300),
      height: getProportionateScreenHeight(300),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          width: getProportionateScreenWidth(15),
          height: getProportionateScreenWidth(10),
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
