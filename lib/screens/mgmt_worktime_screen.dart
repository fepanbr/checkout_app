import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/models/firebase_worktime.dart';
import 'package:songaree_worktime/models/time_format.dart';
import 'package:songaree_worktime/models/weeklyWork.dart';
import 'package:songaree_worktime/models/weekly_worktime.dart';

class MgmtWorkTimeScreen extends StatefulWidget {
  @override
  _MgmtWorkTimeScreenState createState() => _MgmtWorkTimeScreenState();
}

class _MgmtWorkTimeScreenState extends State<MgmtWorkTimeScreen> {
  FirebaseWorkTime _firebaseWorkTime = FirebaseWorkTime();

  getWorkLogsInThisWeek() async {
    weeklyWorkTimeList = await FirebaseWorkTime().getWorkLogsInThisWeek();
    print(weeklyWorkTimeList.length);
  }

  void updateWorkTime(DateTime workTime) {}

  Future<void> getWeeklyWork() async {
    Duration workingTimeInWeekly = await _firebaseWorkTime.getWeeklyWorkLog();
    print("아무말");
    print(workingTimeInWeekly.inMinutes);
    Duration workingTime = workingTimeInWeekly.inMinutes > 2400
        ? Duration(minutes: 0)
        : Duration(minutes: 2400 - workingTimeInWeekly.inMinutes);
    TimeFormat timeFormat = TimeFormat(workingTime);
    print(timeFormat.hours);
    print(timeFormat.minutes);
    Provider.of<WeeklyWork>(context, listen: false)
        .restTimeInWeeklyMsg(timeFormat);
  }

  List<WeeklyWorkTime> weeklyWorkTimeList = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWeeklyWork(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SafeArea(
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: Text(
                        Provider.of<WeeklyWork>(context).restTimeInfo,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                                weeklyWorkTime: weeklyWorkTimeList[index],
                                updateWorkTime: (DateTime value) {
                                  updateWorkTime(value);
                                },
                              );
                            },
                            itemCount: 5,
                          ),
                        );
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class MgmtCard extends StatelessWidget {
  const MgmtCard({
    Key? key,
    required this.weeklyWorkTime,
    required Function updateWorkTime,
  }) : super(key: key);

  final WeeklyWorkTime weeklyWorkTime;

  void updateWorkTime() {}

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 30),
      elevation: 5,
      child: InkWell(
        onTap: () {
          updateWorkTime();
        },
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
                          weeklyWorkTime.getDay,
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
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.w300),
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
      ),
    );
  }
}
