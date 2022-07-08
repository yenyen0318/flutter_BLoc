import 'package:bloc_counter/timer/widgets/timer_widgets.dart';
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
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (BuildContext context, TimerState state) {
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //判斷目前的State是哪種，顯示對應的畫面給使用者
              if (state is TimerInitial) ...[
                Text(
                  '計時器',
                  style: TextStyle(
                      fontSize: 50,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(
                  height: 60,
                ),
                TimerName(),
                SizedBox(
                  height: 10,
                ),
                TimeSelector(),
                SizedBox(
                  height: 100,
                ),
                TimerActionButton()
              ] else ...[
                TimerText(),
                SizedBox(
                  height: 100,
                ),
                TimerActionCard(),
                SizedBox(
                  height: 100,
                ),
                TimerActionButton()
              ],
            ],
          ),
        );
      },
    );
  }
}