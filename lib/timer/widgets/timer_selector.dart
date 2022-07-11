import 'package:bloc_counter/timer/bloc/timer_bloc.dart';
import 'package:bloc_counter/timer/timer_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../ticker.dart';

class TimeSelector extends StatelessWidget {
  const TimeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FixedExtentScrollController hourScrollController =
        new FixedExtentScrollController();
    FixedExtentScrollController minScrollController =
        new FixedExtentScrollController();
    FixedExtentScrollController secScrollController =
        new FixedExtentScrollController();

    return Container(
      child: SizedBox(
        height: 100,
        //只有在卷軸滾動完才觸發
        child: Row(
          children: [
            NotificationListener<ScrollEndNotification>(
              onNotification: (scrollNotification) {
                context.read<TimerBloc>().add(SetTimerTime(
                    addDuration: CalTotalDuration(
                        hourScrollController.selectedItem,
                        minScrollController.selectedItem,
                        secScrollController.selectedItem)));
                return true;
              },
              child: Expanded(
                child: CupertinoPicker(
                  itemExtent: 30,
                  scrollController: hourScrollController,
                  children: List<Text>.generate(
                    100,
                    (i) => Text(
                      '$i',
                      style: TimerTheme.textTheme.bodyText2,
                    ),
                  ),
                  onSelectedItemChanged: (_) {},
                  looping: true,
                ),
              ),
            ),
            NotificationListener<ScrollEndNotification>(
              onNotification: (scrollNotification) {
                context.read<TimerBloc>().add(SetTimerTime(
                    addDuration: CalTotalDuration(
                        hourScrollController.selectedItem,
                        minScrollController.selectedItem,
                        secScrollController.selectedItem)));
                return true;
              },
              child: Expanded(
                child: CupertinoPicker(
                  itemExtent: 30,
                  scrollController: minScrollController,
                  children: List<Text>.generate(
                    59,
                    (i) => Text(
                      '$i',
                      style: TimerTheme.textTheme.bodyText2,
                    ),
                  ),
                  onSelectedItemChanged: (_) {},
                  looping: true,
                ),
              ),
            ),
            NotificationListener<ScrollEndNotification>(
              onNotification: (scrollNotification) {
                context.read<TimerBloc>().add(SetTimerTime(
                    addDuration: CalTotalDuration(
                        hourScrollController.selectedItem,
                        minScrollController.selectedItem,
                        secScrollController.selectedItem)));
                return true;
              },
              child: Expanded(
                child: CupertinoPicker(
                  itemExtent: 30,
                  scrollController: secScrollController,
                  children: List<Text>.generate(
                    59,
                    (i) => Text(
                      '$i',
                      style: TimerTheme.textTheme.bodyText2,
                    ),
                  ),
                  onSelectedItemChanged: (_) {},
                  looping: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
