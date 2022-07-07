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
          TimerName(),
          SizedBox(
            height: 10,
          ),
          TimerText(),
          SizedBox(
            height: 100,
          ),
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


class TimerText extends StatelessWidget {
  const TimerText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //讓widget監聽TimerBloc的變化
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    return Text(
      TimeTransform(duration),
      style: TextStyle(
          fontSize: 70,
          color: Colors.black,
          decoration: TextDecoration.none,
          fontWeight: FontWeight.normal),
    );
  }
}

class TimerName extends StatelessWidget {
  const TimerName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      Text('小時',
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal)),
      Text('分鐘',
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal)),
      Text('秒  ',
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal)),
    ]);
  }
}

class editTimerActions extends StatelessWidget {
  editTimerActions({Key? key}) : super(key: key);
  final addTextItems = [10, 30, 60, 300, 600, 3600];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: addTextItems.length,
        itemBuilder: (context, index) {
          return TimerCard(duration: addTextItems[index]);
        },
      ),
    );
  }
}

class TimerCard extends StatelessWidget {
  final int duration;

  const TimerCard({
    Key? key,
    required this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<TimerBloc>().add(SetTimerTime(addDuration: duration));
      },
      child: Card(
          elevation: 0,
          child: Center(
            child: Container(
                alignment: Alignment.center,
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.blue[100]),
                child: Text(TimeTransform(duration)),
          )),
    ));
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
                ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(100, 45)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                  child: Text('開始'),
                  onPressed: () => context
                      .read<TimerBloc>()
                      .add(TimerStarted(duration: state.duration)),
                ),
              ],
              if (state is TimerRunInProgress) ...[
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      minimumSize: MaterialStateProperty.all(Size(100, 45)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                  child: Text('暫停'),
                  onPressed: () => context.read<TimerBloc>().add(TimerPaused()),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      minimumSize: MaterialStateProperty.all(Size(100, 45)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                  child: Icon(Icons.replay),
                  onPressed: () => context.read<TimerBloc>().add(TimerReset()),
                ),
              ],
              if (state is TimerRunPause) ...[
                ElevatedButton(
                  style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(100, 45)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                  child: Text('繼續'),
                  onPressed: () =>
                      context.read<TimerBloc>().add(TimerResumed()),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      minimumSize: MaterialStateProperty.all(Size(100, 45)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                  child: Icon(Icons.replay),
                  onPressed: () => context.read<TimerBloc>().add(TimerReset()),
                ),
              ],
              if (state is TimerRunComplete) ...[
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      minimumSize: MaterialStateProperty.all(Size(100, 45)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)))),
                  child: Icon(Icons.replay),
                  onPressed: () => context.read<TimerBloc>().add(TimerReset()),
                ),
              ]
            ],
          );
        });
  }
}


String TimeTransform(int duration){
  final hoursStr =
        ((duration / 3600) % 60).floor().toString().padLeft(2, '0');
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
  return '$hoursStr:$minutesStr:$secondsStr';
}