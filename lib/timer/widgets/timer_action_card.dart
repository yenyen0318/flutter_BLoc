import 'package:bloc_counter/timer/bloc/timer_bloc.dart';
import 'package:bloc_counter/timer/ticker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerActionCard extends StatelessWidget {
  TimerActionCard({Key? key}) : super(key: key);
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
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.blue[100]),
            child: Text(TimeTransform(duration).join(":")),
          )),
        ));
  }
}