import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:songaree_worktime/models/work.dart';

class WorkTime {
  static final Duration _lunchTime = Duration(hours: 1);
  static const Duration _offsetWorkTime = Duration(hours: 1);
  static const int WEEK_COUNT = 5;

  DateTime startTime;
  DateTime? endTime;
  bool haveLunch;
  int? workingTime;
  late WorkState _state;

  get getStartTime => DateFormat("HH:mm").format(startTime);
  get getEndTime =>
      endTime != null ? DateFormat("HH:mm").format(endTime!) : "00:00";
  get getWorkState => _state;

  bool get isValidWorkTime => workingTime! >= 0;

  @override
  String toString() {
    return 'WorkTime: {startTime: $startTime, endTime: $endTime}';
  }

  WorkTime(
      {required this.startTime,
      required this.endTime,
      required this.haveLunch,
      this.workingTime}) {
    this._setLunch(haveLunch);
    this._calculateTodayWokingTime();
    this._setEndTime();
    this._setWorkState();
  }

  static WorkTime fromMap(Map<String, dynamic> workTimeMap) {
    String startTime = workTimeMap["startDate"];
    String? endTime = workTimeMap["endDate"];
    bool haveLunch =
        workTimeMap["haveLunch"] != null ? workTimeMap["haveLunch"] : false;
    int? workingTime = workTimeMap["workingTime"];
    return WorkTime(
      startTime: _toDateTime(startTime)!,
      endTime: _toDateTime(endTime),
      haveLunch: haveLunch,
      workingTime: workingTime,
    );
  }

  static Map<String, TimeOfDay> toTimeOfDay(WorkTime workTime) {
    return {
      "startTime": TimeOfDay.fromDateTime(workTime.startTime),
      "endTime": workTime.endTime != null
          ? TimeOfDay.fromDateTime(workTime.endTime!)
          : TimeOfDay(hour: 0, minute: 0),
    };
  }

  static Map<String, dynamic> toMap(WorkTime workTime) {
    return {
      "startDate": DateFormat("yyyyMMddHHmm").format(workTime.startTime),
      "endDate": DateFormat("yyyyMMddHHmm").format(workTime.endTime!),
      "haveLunch": workTime.haveLunch,
      "workingTime": workTime.workingTime,
    };
  }

  static DateTime? _toDateTime(String? time) {
    if (time == null) return null;
    var timeData = time.substring(0, 8) + "T" + time.substring(8);
    return DateTime.parse(timeData);
  }

  static DateTime _findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  /*
   * 일주일 치 근무시간 만들기
   */
  static Set<WorkTime> createWeeksDummyWorkTimes(DateTime date) {
    var monday = _findFirstDateOfTheWeek(date);
    Set<WorkTime> list = Set();
    DateTime dummyWorkTime =
        DateTime(monday.year, monday.month, monday.day, 0, 0);
    for (var i = 0; i < WEEK_COUNT; i++) {
      var workTime = dummyWorkTime.add(Duration(days: i));
      list.add(
          WorkTime(startTime: workTime, endTime: workTime, haveLunch: false));
    }
    return list;
  }

  String getDayOfWeekToString() {
    var dayOfWeek = startTime.weekday;
    if (dayOfWeek == 1) {
      return '월';
    } else if (dayOfWeek == 2) {
      return '화';
    } else if (dayOfWeek == 3) {
      return '수';
    } else if (dayOfWeek == 4) {
      return '목';
    } else if (dayOfWeek == 5) {
      return '금';
    } else if (dayOfWeek == 6) {
      return '토';
    } else if (dayOfWeek == 7) {
      return '일';
    } else {
      throw 'no valid parameters dayOfWeek';
    }
  }

  void _calculateTodayWokingTime() {
    if (DateFormat("HH:mm").format(startTime) == "00:00") return;
    if (endTime != null) {
      workingTime = haveLunch
          ? endTime!
              .subtract(_offsetWorkTime)
              .add(_lunchTime)
              .difference(startTime)
              .inMinutes
          : endTime!.subtract(_offsetWorkTime).difference(startTime).inMinutes;
    } else {
      workingTime = 0;
    }
  }

  void _setEndTime() {
    if (endTime == null) {
      endTime =
          DateTime(startTime.year, startTime.month, startTime.day, 0, 0, 0);
    } else {
      endTime = endTime;
    }
  }

  void _setLunch(bool? lunch) {
    if (lunch == null)
      haveLunch = false;
    else
      haveLunch = lunch;
  }

  void _setWorkState() {
    if (DateFormat("HH:mm").format(startTime) == "00:00" &&
        DateFormat("HH:mm").format(endTime!) == "00:00") {
      _state = WorkState.beforeWork;
    } else if (DateFormat("HH:mm").format(startTime) != "00:00" &&
        DateFormat("HH:mm").format(endTime!) == "00:00") {
      _state = WorkState.working;
    } else {
      _state = WorkState.afterWork;
    }
  }
}
