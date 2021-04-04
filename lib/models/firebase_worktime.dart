import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:songaree_worktime/models/worktime.dart';

class FirebaseWorkTime {
  CollectionReference worktimes = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('worktime');

  Future<WorkTime> getWorkLog(DateTime time) async {
    DocumentSnapshot documentSnapshot =
        await worktimes.doc(DateFormat("yyyyMMdd").format(time)).get();
    Map<String, dynamic>? data = documentSnapshot.data();
    String? startDtData;
    String? endDtData;
    startDtData = data!['startDate'].toString().substring(0, 8) +
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
