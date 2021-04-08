import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/models/work.dart';
import 'package:songaree_worktime/screens/components/analog_clock.dart';
import 'package:songaree_worktime/screens/components/state_button.dart';
import 'package:songaree_worktime/screens/components/time_in_hour_minute.dart';
import 'package:songaree_worktime/screens/components/working_bar.dart';
import 'package:songaree_worktime/screens/login_screen.dart';
import 'package:songaree_worktime/size_config.dart';

class HomeScreen extends StatelessWidget {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  final User? user = FirebaseAuth.instance.currentUser;
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Work _work = Provider.of<Work>(context);
    if (_work.isFirst) {
      _work.initWork();
    }
    SizeConfig().init(context);
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoginScreen();
        } else {
          users.doc(user!.uid).set({
            "name": user!.displayName,
            "phone": user!.phoneNumber,
            "email": user!.email
          }).then(
            (value) => {print("user 저장됨")},
          );

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
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    TimeInHourAndMinute(),
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    AnalogClock(),
                    SizedBox(
                      height: getProportionateScreenHeight(50),
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
