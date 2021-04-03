import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:songaree_worktime/models/state_message.dart';
import 'package:songaree_worktime/models/time_format.dart';
import 'package:songaree_worktime/models/today_timer.dart';
import 'package:songaree_worktime/models/week_timer.dart';

enum WorkState { beforeWork, working, afterWork }

class Work with ChangeNotifier {
  WorkState _state = WorkState.beforeWork;
  bool haveLunch = false;
  Duration workingTime;
  bool isFirst = true;

  String _infoText = '';

  CollectionReference worktimes = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection('worktime');

  void initWork() async {
    isFirst = false;
    DateTime now = DateTime.now();
    DocumentSnapshot documentSnapshot =
        await worktimes.doc(DateFormat("yyyyMMdd").format(now)).get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data = documentSnapshot.data();
      haveLunch = data['haveLunch'];
      String startDtData = data['startDate'].toString().substring(0, 8) +
          "T" +
          data['startDate'].toString().substring(8);
      if (data['endDate'] != null) {
        String endDtData = data['endDate'].toString().substring(0, 8) +
            "T" +
            data['endDate'].toString().substring(8);
        DateTime startDate = DateTime.parse(startDtData);
        DateTime endDate = DateTime.parse(endDtData);

        TimeFormat timeFormat = TimeFormat(endDate.difference(startDate));
        _infoText = StateMessage.offWorkMsg(timeFormat);
        _state = WorkState.afterWork;
      } else {
        haveLunch = false;
        String startDtData = data['startDate'].toString().substring(0, 8) +
            "T" +
            data['startDate'].toString().substring(8);
        DateTime endDate = DateTime.now();
        DateTime startDate = DateTime.parse(startDtData);
        TimeFormat timeFormat = TimeFormat(endDate.difference(startDate));
        _infoText = StateMessage.workingMsg(timeFormat);

        _state = WorkState.working;
      }

      notifyListeners();
    }
  }

  String get getStateText => _infoText;
  WorkState get getState => _state;

  void startWork() async {
    DateTime now = DateTime.now();
    QuerySnapshot value = await worktimes
        .where('startDate', isEqualTo: DateFormat("yyyyMMdd").format(now))
        .get();

    if (value.docs.length == 0) {
      _state = WorkState.working;
      _infoText = StateMessage.workMsg(now);
      worktimes.doc(DateFormat("yyyyMMdd").format(now)).set(
        {
          "startDate": DateFormat("yyyyMMddHHmm").format(now),
        },
      ).then(
        (value) => print("저장됨"),
      );
    }

    notifyListeners();
  }

  void offWork() {
    _state = WorkState.afterWork;
    // todayTimer.stop();
    // weekTimer.stop();
    // weekTimer.getRestTime();

    DateTime now = DateTime.now();
    String currentDate = DateFormat("yyyyMMdd").format(now);
    worktimes.doc(currentDate).update({
      "endDate": DateFormat("yyyyMMddHHmm").format(now),
      "haveLunch": haveLunch
    }).then((value) async {
      DocumentSnapshot documentSnapshot =
          await worktimes.doc(currentDate).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data();
        String startDtData = data['startDate'].toString().substring(0, 8) +
            "T" +
            data['startDate'].toString().substring(8);
        String endDtData = data['endDate'].toString().substring(0, 8) +
            "T" +
            data['endDate'].toString().substring(8);
        bool haveLunch = data['haveLunch'];
        DateTime startDate = DateTime.parse(startDtData);
        DateTime endDate = DateTime.parse(endDtData);

        TimeFormat timeFormat = haveLunch
            ? TimeFormat(endDate.add(Duration(hours: 1)).difference(startDate))
            : TimeFormat(endDate.difference(startDate));
        _infoText = StateMessage.offWorkMsg(timeFormat);
        notifyListeners();
      }
    });
  }

  void addLunch() {
    haveLunch = !haveLunch;
    notifyListeners();
  }
}
