import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:songaree_worktime/models/firebase_worktime.dart';
import 'package:songaree_worktime/models/state_message.dart';
import 'package:songaree_worktime/models/time_format.dart';
import 'package:songaree_worktime/models/worktime.dart';

enum WorkState { beforeWork, working, afterWork }

class Work with ChangeNotifier {
  WorkState _state = WorkState.beforeWork;
  bool haveLunch = false;
  // Duration workingTime;
  bool isFirst = true;
  String _infoText = '';
  FirebaseWorkTime firebaseWorkTime = FirebaseWorkTime();

  void initWork() async {
    isFirst = false;
    DateTime now = DateTime.now();
    WorkTime? worktime = await firebaseWorkTime.getWorkLog(now);

    DateTime? startTime = worktime?.startTime;
    DateTime? endTime = worktime?.endTime;

    // 출근전
    if (startTime == null && endTime == null) {
      _state = WorkState.beforeWork;
      haveLunch = false;
    } else if (startTime != null && endTime == null) {
      // 출근 후
      _infoText =
          StateMessage.workingMsg(TimeFormat(now.difference(startTime)));
      _state = WorkState.working;
      notifyListeners();
    } else {
      // 퇴근
      _state = WorkState.afterWork;
      haveLunch = false;
      _infoText = '수고하셨습니다.';
      notifyListeners();
    }

    // DocumentSnapshot documentSnapshot =
    //     await worktimes.doc(DateFormat("yyyyMMdd").format(now)).get();

    // if (documentSnapshot.exists) {
    //   Map<String, dynamic> data = documentSnapshot.data();
    //   haveLunch = data['haveLunch'];
    //   String startDtData = data['startDate'].toString().substring(0, 8) +
    //       "T" +
    //       data['startDate'].toString().substring(8);
    //   if (data['endDate'] != null) {
    //     String endDtData = data['endDate'].toString().substring(0, 8) +
    //         "T" +
    //         data['endDate'].toString().substring(8);
    //     DateTime startDate = DateTime.parse(startDtData);
    //     DateTime endDate = DateTime.parse(endDtData);

    //     TimeFormat timeFormat = TimeFormat(endDate.difference(startDate));
    //     _infoText = StateMessage.offWorkMsg(timeFormat);
    //     _state = WorkState.afterWork;
    //   } else {
    //     haveLunch = false;
    //     String startDtData = data['startDate'].toString().substring(0, 8) +
    //         "T" +
    //         data['startDate'].toString().substring(8);
    //     DateTime endDate = DateTime.now();
    //     DateTime startDate = DateTime.parse(startDtData);
    //     TimeFormat timeFormat = TimeFormat(endDate.difference(startDate));
    //     _infoText = StateMessage.workingMsg(timeFormat);

    //     _state = WorkState.working;
    //   }
  }

  String get getStateText => _infoText;
  WorkState get getState => _state;

  void startWork() async {
    DateTime now = DateTime.now();
    firebaseWorkTime.writeStartTime(WorkTime(now, null, haveLunch));
    _state = WorkState.working;
    _infoText = StateMessage.workMsg(now);
    notifyListeners();
  }

  void offWork() async {
    DateTime now = DateTime.now();
    var workTime =
        await firebaseWorkTime.writeEndTime(WorkTime(null, now, haveLunch));
    TimeFormat timeFormat = TimeFormat(workTime!.workingTime!);
    _infoText = StateMessage.offWorkMsg(timeFormat);
    _state = WorkState.afterWork;
    notifyListeners();
    // todayTimer.stop();
    // weekTimer.stop();
    // weekTimer.getRestTime();
  }

  void addLunch() {
    haveLunch = !haveLunch;
    notifyListeners();
  }
}
