import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/models/work.dart';
import 'package:songaree_worktime/size_config.dart';

class WorkingBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final work = Provider.of<Work>(context);

    return InkWell(
      onTap: () {
        work.getRestWeeklyWorkTime();
      },
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenWidth(16.0)),
        child: Center(
          child: new LinearPercentIndicator(
            lineHeight: 10.0,
            // percent: _value.restTime,
            linearStrokeCap: LinearStrokeCap.roundAll,
            progressColor: kPrimaryColor,
            percent: work.percentage,
          ),
        ),
      ),
    );
  }
}
