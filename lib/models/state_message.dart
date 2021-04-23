import 'package:songaree_worktime/models/time_format.dart';

class StateMessage<T> {
  static String offWorkMsg(TimeFormat timeFormat) {
    String hours = timeFormat.hours.toString().length == 1
        ? '0${timeFormat.hours}'
        : timeFormat.hours.toString();
    String minutes = timeFormat.minutes.toString().length == 1
        ? '0${timeFormat.minutes}'
        : timeFormat.minutes.toString();
    return '$hours시간 $minutes분 근무하셨습니다.';
  }

  static String workMsg(DateTime dateTime) {
    String hours = dateTime.hour.toString().length == 1
        ? '0${dateTime.hour}'
        : dateTime.hour.toString();
    String minutes = dateTime.minute.toString().length == 1
        ? '0${dateTime.minute}'
        : dateTime.minute.toString();
    return '$hours시 $minutes분에 출근하였습니다.';
  }

  static String workingMsg(TimeFormat timeFormat) {
    String hours = timeFormat.hours.toString().length == 1
        ? '0${timeFormat.hours}'
        : timeFormat.hours.toString();
    String minutes = timeFormat.minutes.toString().length == 1
        ? '0${timeFormat.minutes}'
        : timeFormat.minutes.toString();
    return '$hours시간 $minutes분 근무 중!';
  }

  static String restTimeInWeeklyMsg(TimeFormat timeFormat) {
    String hours = timeFormat.hours.toString().length == 1
        ? '0${timeFormat.hours}'
        : timeFormat.hours.toString();
    String minutes = timeFormat.minutes.toString().length == 1
        ? '0${timeFormat.minutes}'
        : timeFormat.minutes.toString();
    var duration =
        Duration(hours: timeFormat.hours, minutes: timeFormat.minutes);

    return duration.inHours <= 40
        ? '이번주 남은 근무 시간: $hours시간 $minutes분'
        : '이번주 근무시간을 모두 채웠습니다.';
  }

  static String totalTimeInWeeklyMsg(TimeFormat timeFormat) {
    String hours = timeFormat.hours.toString().length == 1
        ? '0${timeFormat.hours}'
        : timeFormat.hours.toString();
    String minutes = timeFormat.minutes.toString().length == 1
        ? '0${timeFormat.minutes}'
        : timeFormat.minutes.toString();

    return '수고하셨습니다.\n총 근무시간: $hours시간 $minutes분';
  }

  static String workOffTimeInFriday(DateTime startTime, Duration workTime) {
    DateTime now = DateTime.now();
    var year = now.year;
    var month = now.month;
    var day = now.day;
    var endDate = startTime
        .add(Duration(minutes: 2400 - workTime.inMinutes))
        .add(Duration(hours: 1));
    return endDate.compareTo(DateTime(year, month, day, 16, 0)) <= 0
        ? "4시에 퇴근 가능합니다! 고생했어요"
        : '${endDate.hour}시 ${endDate.minute}분에 퇴근 가능합니다';
  }
}
