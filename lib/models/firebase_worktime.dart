import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:songaree_worktime/models/weekly_worktime.dart';
import 'package:songaree_worktime/models/worktime.dart';

class FirebaseWorkTime {
  CollectionReference _worktimes = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('worktime');

  Future<WorkTime?> getStartTime(DateTime time) async {
    DocumentSnapshot documentSnapshot =
        await _worktimes.doc(DateFormat("yyyyMMdd").format(time)).get();
    Map<String, dynamic>? data = documentSnapshot.data();
    if (data == null) {
      return null;
    } else {
      return WorkTime.fromMap(data);
    }
  }

  Future<WorkTime?> getWorkLog(DateTime time) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _worktimes.doc(DateFormat("yyyyMMdd").format(time)).get();
      Map<String, dynamic>? data = documentSnapshot.data();
      if (data == null)
        return null;
      else
        return WorkTime.fromMap(data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> writeStartTime(WorkTime worktime) async {
    QuerySnapshot value = await _worktimes
        .where('startDate',
            isEqualTo: DateFormat("yyyyMMdd").format(worktime.startTime))
        .get();

    if (value.docs.length == 0) {
      _worktimes.doc(DateFormat("yyyyMMdd").format(worktime.startTime)).set(
        {
          "startDate": DateFormat("yyyyMMddHHmm").format(worktime.startTime),
        },
      ).then(
        (value) {
          print("저장됨");
          return true;
        },
      ).catchError((e) {
        return false;
      });
    }
    return false;
  }

  Future<void> writeEndTime(WorkTime workTime) async {
    String currentDate = DateFormat("yyyyMMdd").format(workTime.startTime);
    await _worktimes.doc(currentDate).update({
      "endDate": DateFormat("yyyyMMddHHmm").format(workTime.endTime!),
      "haveLunch": workTime.haveLunch,
      "workingTime": workTime.workingTime,
    });
  }

  Future<Duration> getWeeklyWorkTimes() async {
    DateTime currentDate = DateTime.now();
    DateTime monday = findFirstDateOfTheWeek(currentDate);
    QuerySnapshot value = await _worktimes
        .where('startDate',
            isGreaterThanOrEqualTo: DateFormat("yyyyMMdd").format(monday))
        .get();
    int sumMinutes = 0;

    value.docs
        .where((element) => element.data()!['workingTime'] != null)
        .forEach((element) {
      if (element.exists) {
        sumMinutes += int.parse(element.data()!['workingTime'].toString());
      }
    });
    return Duration(minutes: sumMinutes);
  }

  Future<List<WeeklyWorkTime>> getWorkLogsInThisWeek() async {
    List<WeeklyWorkTime> workTimeList = [];
    DateTime currentDate = DateTime.now();
    DateTime monday = findFirstDateOfTheWeek(currentDate);
    QuerySnapshot value = await _worktimes
        .where('startDate',
            isGreaterThanOrEqualTo: DateFormat("yyyyMMdd").format(monday))
        .get();

    if (value.docs.length > 0) {
      value.docs.forEach((element) {
        if (element.exists) {
          print(element.data()!);
          var workTimeMap = element.data()!;
          late DateTime startDate;
          DateTime? endDate;
          String startDtData =
              workTimeMap['startDate'].toString().substring(0, 8) +
                  "T" +
                  workTimeMap['startDate'].toString().substring(8);
          startDate = DateTime.parse(startDtData);
          if (workTimeMap['endDate'] != null) {
            String endDtData =
                workTimeMap['endDate'].toString().substring(0, 8) +
                    "T" +
                    workTimeMap['endDate'].toString().substring(8);
            endDate = DateTime.parse(endDtData);
          } else {
            endDate = null;
          }
          workTimeList.add(WeeklyWorkTime(
              endTime: endDate, startTime: startDate, isFake: false));
        }
      });
      var workTime = workTimeList.last;
      var length = workTimeList.length;
      for (var i = 0; i < 5 - length; i++) {
        workTimeList.add(WeeklyWorkTime(
            startTime: workTime.startTime.add(Duration(days: i + 1)),
            endTime: workTime.endTime!.add(Duration(days: i + 1)),
            isFake: true));
      }
    } else {
      for (var i = 0; i < 5; i++) {
        workTimeList.add(
            WeeklyWorkTime(startTime: monday, endTime: monday, isFake: true));
      }
    }

    print(workTimeList.length);

    return workTimeList;
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: 5 - dateTime.weekday));
  }

  updateWorkTime(DateTime dateTime) {
    _worktimes
        .doc(DateFormat("yyyyMMdd").format(dateTime))
        .update({"startDate": dateTime});
  }
}
