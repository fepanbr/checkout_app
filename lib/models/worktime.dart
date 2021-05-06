import 'package:intl/intl.dart';

class WorkTime {
  static Duration _lunchTime = Duration(hours: 1);
  static Duration _offsetWorkTime = Duration(hours: 1);

  DateTime startTime;
  DateTime? endTime;
  bool haveLunch;
  int? workingTime;

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

  get getStartTime => DateFormat("HH:mm").format(startTime);
  get getEndTime =>
      endTime != null ? DateFormat("HH:mm").format(endTime!) : "00:00";

  WorkTime(
      {required this.startTime,
      required this.endTime,
      required this.haveLunch,
      this.workingTime}) {
    this._setLunch(haveLunch);
    this._calculateTodayWokingTime();
    this._setEndTime();
  }

  static WorkTime fromMap(Map<String, dynamic> workTimeMap) {
    String startTime = workTimeMap["startDate"];
    String? endTime = workTimeMap["endDate"];
    bool haveLunch =
        workTimeMap["haveLunch"] ? workTimeMap["haveLunch"] : false;
    int? workingTime = workTimeMap["workingTime"];
    return WorkTime(
      startTime: _toDateTime(startTime)!,
      endTime: _toDateTime(endTime),
      haveLunch: haveLunch,
      workingTime: workingTime,
    );
  }

  static DateTime? _toDateTime(String? time) {
    if (time == null) return null;
    var timeData = time.substring(0, 8) + "T" + time.substring(8);
    return DateTime.parse(timeData);
  }

  void _calculateTodayWokingTime() {
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
}
