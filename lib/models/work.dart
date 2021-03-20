import 'package:flutter/material.dart';
import 'package:songaree_worktime/models/state_message.dart';
import 'package:songaree_worktime/models/today_timer.dart';
import 'package:songaree_worktime/models/week_timer.dart';

enum WorkState { beforeWork, working, afterWork }

class Work with ChangeNotifier {
  String _infoText = '';
  WorkState _state = WorkState.beforeWork;
  TodayTimer todayTimer;
  WeekTimer weekTimer;

  double restTime = 0.0;

  Work(this.todayTimer, this.weekTimer) {
    restTime = weekTimer.getRestTimeToDouble();
  }

  String get getStateText => _infoText;
  WorkState get getState => _state;
  TodayTimer get getTodayTimer => todayTimer;

  void startWork() {
    _state = WorkState.working;
    todayTimer.start();
    weekTimer.start();
    _infoText = StateMessage.workMsg(todayTimer.startTime);
    notifyListeners();
  }

  void offWork() {
    _state = WorkState.afterWork;
    todayTimer.stop();
    weekTimer.stop();
    weekTimer.getRestTime();
    _infoText = StateMessage.offWorkMsg(todayTimer.getWorkTime());
    notifyListeners();
  }

  void addLunch() {
    todayTimer.toggleLunch();
    notifyListeners();
  }
}
