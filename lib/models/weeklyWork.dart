import 'package:flutter/material.dart';

class WeeklyWork with ChangeNotifier {
  String restTimeInfo = '';

  void restTimeInWeeklyMsg(TimeFormat timeFormat) {
    String hours = timeFormat.hours.toString().length == 1
        ? '0${timeFormat.hours}'
        : timeFormat.hours.toString();
    String minutes = timeFormat.minutes.toString().length == 1
        ? '0${timeFormat.minutes}'
        : timeFormat.minutes.toString();
    var duration =
        Duration(hours: timeFormat.hours, minutes: timeFormat.minutes);

    restTimeInfo = duration.inHours <= 40
        ? '이번주 남은 근무 시간: $hours시간 $minutes분'
        : '이번주 근무시간을 모두 채웠습니다.';
    notifyListeners();
  }
}
