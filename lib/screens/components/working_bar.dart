import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/models/work.dart';

class WorkingBar extends StatelessWidget {
  static const leftOffset = 15;
  static const widthOffset = 375; // end: 390, start 15, (390 - 15)

  @override
  Widget build(BuildContext context) {
    final _value = Provider.of<Work>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: new LinearPercentIndicator(
          lineHeight: 10.0,
          percent: _value.restTime,
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: kPrimaryColor,
        ),
      ),
    );
  }
}
