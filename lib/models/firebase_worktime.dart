import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
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
      print("firebase: $data");

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

  Future<Duration> getWeeklyWorkingTime() async {
    DateTime currentDate = DateTime.now();
    DateTime monday = _findFirstDateOfTheWeek(currentDate);
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

  Future<Set<WorkTime>> getWorkLogsInThisWeek() async {
    Set<WorkTime> workTimeList = Set();
    DateTime currentDate = DateTime.now();
    DateTime monday = _findFirstDateOfTheWeek(currentDate);
    QuerySnapshot value = await _worktimes
        .where('startDate',
            isGreaterThanOrEqualTo: DateFormat("yyyyMMdd").format(monday))
        .get();

    value.docs.forEach((element) {
      if (element.exists) {
        workTimeList.add(WorkTime.fromMap(element.data()!));
      }
    });
    // var startDateAtLastWorkTime = workTimeList.last.startTime;
    // var length = workTimeList.length;
    // for (var i = 1; i < 5 - length + 1; i++) {
    //   var fakeDateTime = DateTime(startDateAtLastWorkTime.year,
    //       startDateAtLastWorkTime.month, startDateAtLastWorkTime.day + i, 0, 0);

    //   workTimeList.add(WorkTime(
    //       startTime: fakeDateTime,
    //       endTime: fakeDateTime,
    //       haveLunch: false,
    //       workingTime: 0));
    // }

    // print(workTimeList.length);

    return workTimeList;
  }

  DateTime _findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  updateWorkTime(DateTime dateTime) {
    _worktimes
        .doc(DateFormat("yyyyMMdd").format(dateTime))
        .update({"startDate": dateTime});
  }
}
