import 'package:flutter/material.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/models/firebase_worktime.dart';
import 'package:songaree_worktime/models/weekly_worktime.dart';

class MgmtWorkTimeScreen extends StatefulWidget {
  @override
  _MgmtWorkTimeScreenState createState() => _MgmtWorkTimeScreenState();
}

class _MgmtWorkTimeScreenState extends State<MgmtWorkTimeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getWorkLogsInThisWeek() async {
    weeklyWorkTimeList = await FirebaseWorkTime().getWorkLogsInThisWeek();
    print(weeklyWorkTimeList.length);
  }

  List<WeeklyWorkTime> weeklyWorkTimeList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          children: [
            Container(
              child: Center(
                child: Text(
                  '이번주 남은 근무시간: 22시간 20분',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              height: 120,
            ),
            FutureBuilder(
              future: getWorkLogsInThisWeek(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    width: double.infinity,
                    height: 600,
                    child: ListView.builder(
                      padding: EdgeInsets.only(left: 40, right: 40),
                      itemBuilder: (context, index) {
                        return MgmtCard(
                            weeklyWorkTime: weeklyWorkTimeList[index]);
                      },
                      itemCount: 5,
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MgmtCard extends StatelessWidget {
  const MgmtCard({
    Key? key,
    required this.weeklyWorkTime,
  }) : super(key: key);

  final WeeklyWorkTime weeklyWorkTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 30),
      elevation: 5,
      child: Container(
        width: 200,
        height: 80,
        child: Row(
          children: [
            Column(
              children: [
                Expanded(
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border(
                        right: BorderSide(
                          color: kBodyTextColorLight,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        '28',
                        style: TextStyle(fontSize: 32, color: kPrimaryColor),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: kBodyTextColorLight,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      weeklyWorkTime.dayOfWeekToString,
                      style:
                          TextStyle(fontSize: 32, fontWeight: FontWeight.w300),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            '출근 :',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 20, top: 5),
                            child: Text(
                              weeklyWorkTime.getStartTime(),
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            '퇴근 :',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 20, top: 5),
                            child: Text(
                              weeklyWorkTime.getEndTime(),
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
