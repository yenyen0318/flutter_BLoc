import 'package:bloc_counter/timer/bloc/timer_bloc.dart';
import 'package:bloc_counter/timer/timer_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ticker.dart';

class TimeSelector extends StatelessWidget {
  const TimeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FixedExtentScrollController _hourScrollController =
        new FixedExtentScrollController();
    FixedExtentScrollController _minuteScrollController =
        new FixedExtentScrollController();
    FixedExtentScrollController _secondScrollController =
        new FixedExtentScrollController();

    int _hour = 0;
    int _minute = 0;
    int _second = 0;

    return Container(
        child: SizedBox(
            height: 100,
            //只有在卷軸滾動完才觸發
            child: NotificationListener<ScrollEndNotification>(
              onNotification: (scrollNotification) {
                debugPrint(
                    '${_hour} ${_minute} ${_second} ');
                //直接取用hourScrollController.selectedItem向上滾動或轉超過一圈會有超出設定範圍的情況發生(例如:負值等)
                context.read<TimerBloc>().add(SetTimerTime(
                    resetDuration: CalTotalDuration(_hour, _minute, _second)));
                return true;
              },
              child: Row(children: [
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 33,
                    scrollController: _hourScrollController,
                    children: List<Text>.generate(
                      100,
                      (i) => Text(
                        '$i',
                        style: TimerTheme.textTheme.bodyText2,
                      ),
                    ),
                    onSelectedItemChanged: (value) {
                      _hour = value;
                    },
                    looping: true,
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 33,
                    scrollController: _minuteScrollController,
                    children: List<Text>.generate(
                      60,
                      (i) => Text(
                        '$i',
                        style: TimerTheme.textTheme.bodyText2,
                      ),
                    ),
                    onSelectedItemChanged: (value) {
                      _minute = value;
                    },
                    looping: true,
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 33,
                    scrollController: _secondScrollController,
                    children: List<Text>.generate(
                      60,
                      (i) => Text(
                        '$i',
                        style: TimerTheme.textTheme.bodyText2,
                      ),
                    ),
                    onSelectedItemChanged: (value) {
                      _second = value;
                    },
                    looping: true,
                  ),
                ),
              ]),
            )));
  }
}
