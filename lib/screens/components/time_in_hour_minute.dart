import 'dart:async';

import 'package:flutter/material.dart';
import 'package:songaree_worktime/constants.dart';

class TimeInHourAndMinute extends StatefulWidget {
  @override
  _TimeInHourAndMinuteState createState() => _TimeInHourAndMinuteState();
}

class _TimeInHourAndMinuteState extends State<TimeInHourAndMinute> {
  TimeOfDay _timeOfDay = TimeOfDay.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeOfDay.minute != TimeOfDay.now().minute) {
        if (this.mounted) {
          setState(() {
            _timeOfDay = TimeOfDay.now();
          });
        }
      }
    });
  }

  String getHourString() {
    print("ggg,${_timeOfDay.hourOfPeriod}");
    if (_timeOfDay.hourOfPeriod == 0) {
      return "12";
    } else if (_timeOfDay.hourOfPeriod < 10) {
      return "0${_timeOfDay.hourOfPeriod}";
    } else {
      return "${_timeOfDay.hourOfPeriod}";
    }
  }

  @override
  Widget build(BuildContext context) {
    String _period = _timeOfDay.period == DayPeriod.am ? 'AM' : 'PM';
    String _hour = getHourString();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotatedBox(
          quarterTurns: 35,
          child: Text(
            '$_period',
            style: TextStyle(
              color: kBodyTextColorLight,
              fontSize: 20.0,
            ),
          ),
        ),
        Text(
          "$_hour:${_timeOfDay.minute < 10 ? "0" + _timeOfDay.minute.toString() : _timeOfDay.minute}",
          style: TextStyle(
            color: kBodyTextColorLight,
            fontSize: 65.0,
            height: 0.9,
          ),
        ),
      ],
    );
  }
}
