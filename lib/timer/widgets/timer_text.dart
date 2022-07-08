import 'package:bloc_counter/timer/bloc/timer_bloc.dart';
import 'package:bloc_counter/timer/ticker.dart';
import 'package:bloc_counter/timer/timer_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //讓widget監聽TimerBloc的變化
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    return Text(
      TimeTransform(duration).join(":"),
      style: TimerTheme.textTheme.headline1,
    );
  }
}