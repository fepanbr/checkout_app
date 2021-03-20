import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songaree_worktime/constants.dart';
import 'package:songaree_worktime/models/work.dart';

class StateButton extends StatefulWidget {
  @override
  _StateButtonState createState() => _StateButtonState();
}

class _StateButtonState extends State<StateButton> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    final Work _work = Provider.of<Work>(context);

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
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
                padding: const EdgeInsets.only(left: 150.0),
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
                  padding: EdgeInsets.all(20.0),
                  color: kPrimaryColor,
                  child: Consumer<Work>(
                    builder: (context, workTimeState, child) {
                      return Text(
                        _work.getState == WorkState.working ? '퇴근하기' : '출근하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
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
                  },
                  child: Icon(
                    Icons.lunch_dining,
                    size: 62,
                    color: _work.todayTimer.haveLunch
                        ? Colors.deepOrangeAccent
                        : kBodyTextColorLight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
