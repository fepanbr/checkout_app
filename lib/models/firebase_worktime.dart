import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:songaree_worktime/models/worktime.dart';

class FirebaseWorkTime {
  CollectionReference worktimes = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('worktime');

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
      endDtData = data['endDate'].toString().substring(0, 8) +
          "T" +
          data['endDate'].toString().substring(8);
      DateTime endTime = DateTime.parse(endDtData);
      DateTime startTime = DateTime.parse(startDtData);
      bool haveLunch = data['haveLunch'];

      return WorkTime(startTime, endTime, haveLunch);
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
      ).catchError(() {
        return false;
      });
    }
    return false;
  }

  Future<WorkTime?> writeEndTime(WorkTime workTime) async {
    String currentDate = DateFormat("yyyyMMdd").format(workTime.startTime!);
    worktimes.doc(currentDate).update({
      "endDate": DateFormat("yyyyMMddHHmm").format(workTime.endTime!),
      "haveLunch": workTime.haveLunch!,
      "workingTime": workTime.workingTime!.inMinutes,
    }).then((value) async {
      DocumentSnapshot documentSnapshot =
          await worktimes.doc(currentDate).get();
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

        return WorkTime(startDate, endDate, haveLunch);
      } else {
        return null;
      }
    });
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

  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: 5 - dateTime.weekday));
  }
}
