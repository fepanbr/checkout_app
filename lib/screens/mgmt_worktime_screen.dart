import 'package:flutter/material.dart';
import 'package:songaree_worktime/constants.dart';

class MgmtWorkTimeScreen extends StatefulWidget {
  @override
  _MgmtWorkTimeScreenState createState() => _MgmtWorkTimeScreenState();
}

class _MgmtWorkTimeScreenState extends State<MgmtWorkTimeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: ListView.builder(
        itemExtent: 120,
        padding: EdgeInsets.only(left: 20, right: 20, top: 100),
        itemBuilder: (context, i) {
          if (i != 0) {
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
                                // bottom: BorderSide(
                                //   color: kBodyTextColorLight,
                                //   width: 3,
                                // ),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                '28',
                                style: TextStyle(
                                    fontSize: 32, color: kPrimaryColor),
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
                            child: Text('월',
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.w300)),
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
                                      '00:00',
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
                                      '00:00',
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
          } else {
            return Center(
                child: Container(
              child: Text(
                '이번주 남은 근무 시간: 23시간 59분',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              padding: EdgeInsets.only(bottom: 30),
            ));
          }
        },
        itemCount: 6,
      ),
    );
  }
}
