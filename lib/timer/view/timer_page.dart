import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/timer_bloc.dart';
import '../ticker.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //使用BlocProvider訪問TimerBloc
    return BlocProvider(
      create: (_) => TimerBloc(ticker: Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimerText(),
          editTimerActions(),
          SizedBox(
            height: 100,
          ),
          TimerActions()
        ],
      ),
    );
  }
}

class TimerSelect extends StatelessWidget {
  const TimerSelect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView(
      itemExtent: 50,
      children: List.generate(1000, (index) => index)
          .map(
            (text) => Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              color:
                  Colors.primaries[Random().nextInt(Colors.primaries.length)],
              child: Center(child: Text(text.toString())),
            ),
          )
          .toList(),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //讓widget監聽TimerBloc的變化
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text(
      '$minutesStr:$secondsStr',
      style: Theme.of(context).textTheme.headline1,
    );
  }
}

class editTimerActions extends StatelessWidget {
  editTimerActions({Key? key}) : super(key: key);
  final addTextItems = [1, 5, 10, 30, 60, -1, -5, -10, -30, -60];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: addTextItems.length,
        itemBuilder: (context, index) {
          return TextButton(
              onPressed: () {
                debugPrint('${addTextItems[index]}');
                context
                    .read<TimerBloc>()
                    .add(SetTimerTime(addDuration: addTextItems[index]));
              },
              child: Text(addTextItems[index] > 0
                  ? '+${addTextItems[index]}'
                  : '${addTextItems[index]}'));
        },
      ),
    );
  }
}

class TimerActions extends StatelessWidget {
  TimerActions({Key? key}) : super(key: key);

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
                FloatingActionButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: () => context
                      .read<TimerBloc>()
                      .add(TimerStarted(duration: state.duration)),
                ),
              ],
              if (state is TimerRunInProgress) ...[
                FloatingActionButton(
                  child: Icon(Icons.pause),
                  onPressed: () =>
                      context.read<TimerBloc>().add(TimerPaused()),
                ),
                FloatingActionButton(
                  child: Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(TimerReset()),
                ),
              ],
              if (state is TimerRunPause) ...[
                FloatingActionButton(
                  child: Icon(Icons.play_arrow),
                  onPressed: () =>
                      context.read<TimerBloc>().add(TimerResumed()),
                ),
                FloatingActionButton(
                  child: Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(TimerReset()),
                ),
              ],
              if (state is TimerRunComplete) ...[
                FloatingActionButton(
                  child: Icon(Icons.replay),
                  onPressed: () =>
                      context.read<TimerBloc>().add(TimerReset()),
                ),
              ]
            ],
          );
        });
  }
}
