import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/models/work.dart';
import 'package:songaree_worktime/size_config.dart';

class StateButton extends StatefulWidget {
  @override
  _StateButtonState createState() => _StateButtonState();
}

class _StateButtonState extends State<StateButton> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final Work _work = Provider.of<Work>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _work.getStateText,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(170)),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: kPrimaryColor),
                ),
                onPressed: () {
                  if (_work.getState == WorkState.afterWork) return;
                  if (_work.getState == WorkState.beforeWork) {
                    _work.startWork();
                  } else {
                    _work.offWork();
                  }
                },
                padding: EdgeInsets.all(10.0),
                color: kPrimaryColor,
                child: Consumer<Work>(
                  builder: (context, workTimeState, child) {
                    return Text(
                      _work.getState == WorkState.working ? '퇴근하기' : '출근하기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: InkWell(
                onTap: () {
                  _work.addLunch();
                  // firestore.collection('worktime').doc()
                },
                child: Icon(
                  Icons.lunch_dining,
                  size: 40,
                  color: _work.haveLunch
                      ? Colors.deepOrangeAccent
                      : kBodyTextColorLight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
