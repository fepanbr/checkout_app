import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/screens/components/analog_clock.dart';
import 'package:songaree_worktime/screens/components/state_button.dart';
import 'package:songaree_worktime/screens/components/time_in_hour_minute.dart';
import 'package:songaree_worktime/screens/components/working_bar.dart';
import 'package:songaree_worktime/screens/login_screen.dart';
import 'package:songaree_worktime/size_config.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData == null) {
          return LoginScreen();
        } else {
          print('login user: ${FirebaseAuth.instance.currentUser}');
          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: SizeConfig.screenHeight,
              child: Container(
                margin: EdgeInsets.only(top: 15.0),
                height: SizeConfig.screenHeight,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wb_cloudy_outlined,
                          color: kBodyTextColorLight,
                          size: getProportionateScreenWidth(70),
                        ),
                      ],
                    ),
                    TimeInHourAndMinute(),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    AnalogClock(),
                    SizedBox(
                      height: getProportionateScreenHeight(40),
                    ),
                    WorkingBar(),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    StateButton(),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
