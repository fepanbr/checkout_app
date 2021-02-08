import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/models/work.dart';
import 'package:songaree_worktime/size_config.dart';

class WorkingBar extends StatelessWidget {
  static const leftOffset = 15;
  static const widthOffset = 375; // end: 390, start 15, (390 - 15)

  @override
  Widget build(BuildContext context) {
    final _value = Provider.of<Work>(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        getProportionateScreenWidth(20.0),
        getProportionateScreenHeight(10.0),
        getProportionateScreenHeight(20.0),
        getProportionateScreenWidth(30.0),
      ),
      child: new LinearPercentIndicator(
        lineHeight: 10.0,
        percent: _value.restTime,
        linearStrokeCap: LinearStrokeCap.roundAll,
        progressColor: kPrimaryColor,
      ),
    );
  }
}
