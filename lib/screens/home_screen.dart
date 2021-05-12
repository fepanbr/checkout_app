import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songaree_worktime/models/work.dart';
import 'package:songaree_worktime/screens/components/analog_clock.dart';
import 'package:songaree_worktime/screens/components/state_button.dart';
import 'package:songaree_worktime/screens/components/time_in_hour_minute.dart';
import 'package:songaree_worktime/screens/components/working_bar.dart';
import 'package:songaree_worktime/screens/login_screen.dart';
import 'package:songaree_worktime/size_config.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  final User? user = FirebaseAuth.instance.currentUser;

  final DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  initWork() {
    final Work _work = Provider.of<Work>(context, listen: false);
    _work.initFirebase();
    _work.initWork();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LoginScreen();
        } else {
          if (user != null) {
            users.doc(user!.uid).set({
              "name": user!.displayName,
              "phone": user!.phoneNumber,
              "email": user!.email
            });
            initWork();
          }

          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: SizeConfig.screenHeight,
              child: Container(
                margin: EdgeInsets.only(top: 50.0),
                height: SizeConfig.screenHeight,
                child: Column(
                  children: [
                    TimeInHourAndMinute(),
                    SizedBox(
                      height: getProportionateScreenHeight(30),
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
