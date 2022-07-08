import 'package:bloc_counter/timer/bloc/timer_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeSelector extends StatelessWidget {
  const TimeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        height: 100,
        child: Row(children: [
          Expanded(
            child: CupertinoPicker(
              children: List<Text>.generate(
                100,
                (i) => Text(
                  '$i',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal),
                ),
              ),
              onSelectedItemChanged: (value) {
                debugPrint('hour $value');
                context.read<TimerBloc>().add(SetTimerTime(addDuration: value*3600));
              },
              itemExtent: 30,
              diameterRatio: 1,
              looping: true,
            ),
          ),
          Text(
            ':',
            style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal),
          ),
          Expanded(
            child: CupertinoPicker(
              children: List<Text>.generate(
                60,
                (i) => Text(
                  '$i',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal),
                ),
              ),
              onSelectedItemChanged: (value) {
                debugPrint('min $value');
                context.read<TimerBloc>().add(SetTimerTime(addDuration: value*60));
              },
              itemExtent: 30,
              diameterRatio: 1,
              looping: true,
            ),
          ),
          Text(
            ':',
            style: TextStyle(
                fontSize: 30,
                color: Colors.black,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.normal),
          ),
          Expanded(
            child: CupertinoPicker(
              children: List<Text>.generate(
                60,
                (i) => Text(
                  '$i',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal),
                ),
              ),
              onSelectedItemChanged: (value) {
                debugPrint('sec $value');
                context.read<TimerBloc>().add(SetTimerTime(addDuration: value));
              },
              itemExtent: 30,
              diameterRatio: 1,
              looping: true,
            ),
          ),
        ]),
      ),
    );
  }
}