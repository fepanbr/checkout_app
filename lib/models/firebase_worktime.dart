import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class FirebaseWork {
  CollectionReference worktimes = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('worktime');

  getTodayLog() async {
    DateTime now = DateTime.now();
    DocumentSnapshot documentSnapshot =
        await worktimes.doc(DateFormat("yyyyMMdd").format(now)).get();
    Map<String, dynamic>? data = documentSnapshot.data();
    String? startDtData;
    String? endDtData;
    startDtData = data!['startDate'].toString().substring(0, 8) +
        "T" +
        data['startDate'].toString().substring(8);
    endDtData = data['endDate'].toString().substring(0, 8) +
        "T" +
        data['endDate'].toString().substring(8);
    DateTime endDate = DateTime.parse(endDtData);
    DateTime startDate = DateTime.parse(startDtData);
  }
}
