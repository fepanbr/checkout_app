import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:songaree_worktime/models/weekly_worktime.dart';
import 'package:songaree_worktime/models/worktime.dart';

class FirebaseWorkTime {
  CollectionReference worktimes = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('worktime');

  Future<DateTime?> getStartDate(DateTime time) async {
    DocumentSnapshot documentSnapshot =
        await worktimes.doc(DateFormat("yyyyMMdd").format(time)).get();
    Map<String, dynamic>? data = documentSnapshot.data();
    String? startDtData;
    if (data == null) {
      return null;
    } else {
      startDtData = data['startDate'].toString().substring(0, 8) +
          "T" +
          data['startDate'].toString().substring(8);
      DateTime startTime = DateTime.parse(startDtData);
      return startTime;
    }
  }

  Future<WorkTime?> getWorkLog(DateTime time) async {
    DocumentSnapshot documentSnapshot =
        await worktimes.doc(DateFormat("yyyyMMdd").format(time)).get();
    Map<String, dynamic>? data = documentSnapshot.data();
    String? startDtData;
    String? endDtData;
    if (data == null) {
      return null;
    } else {
      startDtData = data['startDate'].toString().substring(0, 8) +
          "T" +
          data['startDate'].toString().substring(8);
      DateTime startTime = DateTime.parse(startDtData);

      if (data['endDate'] != null) {
        endDtData = data['endDate'].toString().substring(0, 8) +
            "T" +
            data['endDate'].toString().substring(8);
        DateTime endTime = DateTime.parse(endDtData);
        bool haveLunch = data['haveLunch'];
        return WorkTime(
            startTime: startTime, endTime: endTime, haveLunch: haveLunch);
      } else {
        return WorkTime(startTime: startTime, endTime: null, haveLunch: false);
      }
    }
  }

  Future<bool> writeStartTime(WorkTime worktime) async {
    QuerySnapshot value = await worktimes
        .where('startDate',
            isEqualTo: DateFormat("yyyyMMdd").format(worktime.startTime!))
        .get();

    if (value.docs.length == 0) {
      worktimes.doc(DateFormat("yyyyMMdd").format(worktime.startTime!)).set(
        {
          "startDate": DateFormat("yyyyMMddHHmm").format(worktime.startTime!),
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

  Future<WorkTime?> writeEndTime(WorkTime workTime) async {
    print(workTime.endTime);
    print(workTime.startTime);
    print(workTime.haveLunch);
    String currentDate = DateFormat("yyyyMMdd").format(workTime.startTime!);
    await worktimes.doc(currentDate).update({
      "endDate": DateFormat("yyyyMMddHHmm").format(workTime.endTime!),
      "haveLunch": workTime.haveLunch,
      "workingTime": workTime.workingTime.inMinutes,
    });
    DocumentSnapshot documentSnapshot = await worktimes.doc(currentDate).get();
    if (documentSnapshot.exists) {
      Map<String, dynamic>? data = documentSnapshot.data();
      String startDtData = data!['startDate'].toString().substring(0, 8) +
          "T" +
          data['startDate'].toString().substring(8);
      String endDtData = data['endDate'].toString().substring(0, 8) +
          "T" +
          data['endDate'].toString().substring(8);
      bool haveLunch = data['haveLunch'];
      DateTime startDate = DateTime.parse(startDtData);
      DateTime endDate = DateTime.parse(endDtData);

      return WorkTime(
          startTime: startDate, endTime: endDate, haveLunch: haveLunch);
    } else {
      return null;
    }
  }

  Future<Duration> getWeeklyWorkLog() async {
    DateTime currentDate = DateTime.now();
    DateTime monday = findFirstDateOfTheWeek(currentDate);
    QuerySnapshot value = await worktimes
        .where('startDate',
            isGreaterThanOrEqualTo: DateFormat("yyyyMMdd").format(monday))
        .get();
    int sumMinutes = 0;

    value.docs
        .where((element) => element.data()!['workingTime'] != null)
        .forEach((element) {
      if (element.exists) {
        print(
            "workingTime: ${int.parse(element.data()!['workingTime'].toString())}");
        sumMinutes += int.parse(element.data()!['workingTime'].toString());
      }
    });
    return Duration(minutes: sumMinutes);
  }

  Future<List<WeeklyWorkTime>> getWorkLogsInThisWeek() async {
    List<WeeklyWorkTime> workTimeList = [];
    DateTime currentDate = DateTime.now();
    DateTime monday = findFirstDateOfTheWeek(currentDate);
    QuerySnapshot value = await worktimes
        .where('startDate',
            isGreaterThanOrEqualTo: DateFormat("yyyyMMdd").format(monday))
        .where('endDate', isNotEqualTo: null)
        .get();

    value.docs.forEach((element) {
      if (element.exists) {
        print(element.data()!);
        var workTimeMap = element.data()!;
        String startDtData =
            workTimeMap['startDate'].toString().substring(0, 8) +
                "T" +
                workTimeMap['startDate'].toString().substring(8);
        String endDtData = workTimeMap['endDate'].toString().substring(0, 8) +
            "T" +
            workTimeMap['endDate'].toString().substring(8);

        DateTime startDate = DateTime.parse(startDtData);
        DateTime endDate = DateTime.parse(endDtData);
        if (workTimeMap.keys.contains('endDate')) {
          workTimeList.add(WeeklyWorkTime(
              endTime: endDate, startTime: startDate, isFake: false));
        }
      }
    });

    print(workTimeList.length);
    var workTime = workTimeList.last;
    var length = workTimeList.length;
    for (var i = 0; i < 5 - length; i++) {
      workTimeList.add(WeeklyWorkTime(
          startTime: workTime.startTime.add(Duration(days: i + 1)),
          endTime: workTime.endTime.add(Duration(days: i + 1)),
          isFake: true));
    }

    return workTimeList;
  }

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: 5 - dateTime.weekday));
  }
}
