import 'package:bloc_counter/timer/bloc/timer_bloc.dart';
import 'package:bloc_counter/timer/timer_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerActionButton extends StatelessWidget {
  TimerActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
        buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
        builder: (BuildContext context, TimerState state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //判斷目前的State是哪種，顯示對應的畫面給使用者
              if (state is TimerInitial) ...[
                ElevatedButton(
                  style: TimerTheme.primaryButton,
                  child: Text('開始'),
                  onPressed: () => context
                      .read<TimerBloc>()
                      .add(TimerStarted(duration: state.duration)),
                ),
              ],
              if (state is TimerRunInProgress) ...[
                ElevatedButton(
                  style: TimerTheme.redButton,
                  child: Text('暫停'),
                  onPressed: () => context.read<TimerBloc>().add(TimerPaused()),
                ),
                ElevatedButton(
                  style: TimerTheme.greyButton,
                  child: Icon(Icons.replay),
                  onPressed: () => context.read<TimerBloc>().add(TimerReset()),
                ),
              ],
              if (state is TimerRunPause) ...[
                ElevatedButton(
                  style: TimerTheme.primaryButton,
                  child: Text('繼續'),
                  onPressed: () =>
                      context.read<TimerBloc>().add(TimerResumed()),
                ),
                ElevatedButton(
                  style: TimerTheme.greyButton,
                  child: Icon(Icons.replay),
                  onPressed: () => context.read<TimerBloc>().add(TimerReset()),
                ),
              ]
            ],
          );
        });
  }
}