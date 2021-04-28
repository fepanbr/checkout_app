import 'package:intl/intl.dart';

class WeeklyWorkTime {
  DateTime startTime;
  DateTime? endTime;
  int _dayOfWeek = 0;
  String dayOfWeekToString = '';
  bool isFake = false;

  get getDayOfWeek => dayOfWeekToString;
  get getDay => DateFormat("dd").format(startTime);

  WeeklyWorkTime(
      {required this.startTime, this.endTime, required this.isFake}) {
    if (this.endTime == null) {
      this.endTime =
          DateTime(startTime.year, startTime.month, startTime.day, 0, 0);
    }
    _dayOfWeek = startTime.weekday;
    _getDayOfWeek();
  }

  void _getDayOfWeek() {
    String dayOfWeekToString = '';
    if (_dayOfWeek == 1) {
      dayOfWeekToString = '월';
    } else if (_dayOfWeek == 2) {
      dayOfWeekToString = '화';
    } else if (_dayOfWeek == 3) {
      dayOfWeekToString = '수';
    } else if (_dayOfWeek == 4) {
      dayOfWeekToString = '목';
    } else if (_dayOfWeek == 5) {
      dayOfWeekToString = '금';
    } else if (_dayOfWeek == 6) {
      dayOfWeekToString = '토';
    } else if (_dayOfWeek == 7) {
      dayOfWeekToString = '일';
    } else {
      throw Exception();
    }
    print("dayOfWeekToString");
    print(dayOfWeekToString);
    this.dayOfWeekToString = dayOfWeekToString;
  }

  // String getDate() {
  //   return startTime != null ? startTime.day.toString() : ;
  // }

  String getStartTime() {
    return isFake == false ? DateFormat("HH:mm").format(startTime) : "00:00";
  }

  String getEndTime() {
    return isFake == false ? DateFormat("HH:mm").format(endTime!) : "00:00";
  }
}