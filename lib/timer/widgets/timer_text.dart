import 'package:bloc_counter/timer/bloc/timer_bloc.dart';
import 'package:bloc_counter/timer/ticker.dart';
import 'package:bloc_counter/timer/timer_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //讓widget監聽TimerBloc的變化
    final timer = context.select((TimerBloc bloc) => bloc.state);
    final duration = timer.duration;
    final total = timer.total;
    return CircularPercentIndicator(
      radius: 150.0,
      lineWidth: 10.0,
      percent: (total - duration) / total,
      center: Text(
        duration > 0 ?TimeTransform(duration).join(":") : '倒數完成',
        style: TimerTheme.textTheme.headline1,
      ),
      backgroundColor: Colors.blue,
      progressColor: Colors.grey,
    );
  }
}
