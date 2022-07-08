import 'package:bloc_counter/timer/timer_theme.dart';
import 'package:flutter/material.dart';

class TimerName extends StatelessWidget {
  const TimerName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text('小時', style: TimerTheme.textTheme.bodyText1),
      SizedBox(
        width: 25,
      ),
      Text('分鐘', style: TimerTheme.textTheme.bodyText1),
      SizedBox(
        width: 30,
      ),
      Text('秒  ', style: TimerTheme.textTheme.bodyText1),
    ]);
  }
}
