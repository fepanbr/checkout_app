import 'package:flutter/material.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/screens/components/analog_clock.dart';
import 'package:songaree_worktime/screens/components/state_button.dart';
import 'package:songaree_worktime/screens/components/time_in_hour_minute.dart';
import 'package:songaree_worktime/screens/components/working_bar.dart';
import 'package:songaree_worktime/size_config.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Container(
          margin: EdgeInsets.only(top: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wb_cloudy_outlined,
                    color: kBodyTextColorLight,
                    size: 70.0,
                  ),
                ],
              ),
              TimeInHourAndMinute(),
              AnalogClock(),
              WorkingBar(),
              StateButton(),
            ],
          ),
        ),
      ),
    );
  }
}
