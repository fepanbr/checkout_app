import 'package:songaree_worktime/models/weekly_worktime.dart';
import 'package:songaree_worktime/models/worktime.dart';

class StateMessage {
  // static final StateMessage _stateMessage = StateMessage();

  // factory StateMessage() {
  //   return _stateMessage;
  // }

  String offWorkMsg(Duration duration) {
    var workingTime = _getWorkingTime(duration);
    return '${workingTime['hour']}시간 ${workingTime['minutes']}분 근무하셨습니다.';
  }

  String workMsg(DateTime dateTime) {
    String hours = dateTime.hour.toString().length == 1
        ? '0${dateTime.hour}'
        : dateTime.hour.toString();
    String minutes = dateTime.minute.toString().length == 1
        ? '0${dateTime.minute}'
        : dateTime.minute.toString();
    return '$hours시 $minutes분에 출근하였습니다.';
  }

  String workingMsg(WorkTime workLog) {
    DateTime now = DateTime.now();
    var duration = now.difference(workLog.startTime);
    var workingTimeMap = _getWorkingTime(duration);
    return '${workingTimeMap['hours']}시간 ${workingTimeMap['minutes']}분 근무 중!';
  }

  String restTimeInWeeklyMsg(Duration duration) {
    var workingTimeMap = _getWorkingTime(duration);
    if (!workingTimeMap['isNegative']) {
      return duration.inHours <= 40
          ? '이번주 남은 근무 시간: ${workingTimeMap['hour']}시간 ${workingTimeMap['minutes']}분'
          : '이번주 근무시간을 모두 채웠습니다.';
    } else {
      return "이번주 근무시간을 모두 채웠습니다.";
    }
  }

  String totalTimeInWeeklyMsg(Duration duration) {
    var workingTimeMap = _getWorkingTime(duration);

    return '수고하셨습니다.\n총 근무시간: ${workingTimeMap['hour']}시간 ${workingTimeMap['minutes']}분';
  }

  String workOffTimeInFriday(WorkTime workLog, Duration workTime) {
    DateTime now = DateTime.now();
    var year = now.year;
    var month = now.month;
    var day = now.day;
    var endDate = workLog.startTime
        .add(Duration(minutes: 2400 - workTime.inMinutes))
        .add(Duration(hours: 1));
    return endDate.compareTo(DateTime(year, month, day, 16, 0)) <= 0
        ? "4시에 퇴근 가능합니다! 고생했어요"
        : '${endDate.hour}시 ${endDate.minute}분에 퇴근 가능합니다';
  }

  Map<String, dynamic> _getWorkingTime(Duration duration) {
    var hour = duration.inMinutes ~/ 60;
    var minutes = duration.inMinutes % 60;
    return {
      "hour": hour,
      "minutes": minutes,
      "isNegative": duration.isNegative
    };
  }
}
