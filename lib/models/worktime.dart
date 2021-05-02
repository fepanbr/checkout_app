class WorkTime {
  static Duration _lunchTime = Duration(hours: 1);
  static Duration _offsetWorkTime = Duration(hours: 1);

  DateTime startTime;
  DateTime? endTime;
  late bool haveLunch;
  late int? workingTime;

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
    String endTime = workTimeMap["endDate"];
    bool haveLunch = workTimeMap["haveLunch"];
    int workingTime = workTimeMap["workingTime"];
    return WorkTime(
        startTime: _toDateTime(startTime),
        endTime: _toDateTime(endTime),
        haveLunch: haveLunch,
        workingTime: workingTime);
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
    if (haveLunch == null)
      haveLunch = false;
    else
      haveLunch = lunch!;
  }

  static DateTime _toDateTime(String time) {
    var timeData = time.substring(0, 8) + "T" + time.substring(8);
    return DateTime.parse(timeData);
  }
}
