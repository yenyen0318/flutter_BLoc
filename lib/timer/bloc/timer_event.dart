part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration});
  final int duration;
}

class TimerTicked extends TimerEvent {
  const TimerTicked({required this.duration, required this.total});
  final int duration;
  final int total;

  @override
  List<Object> get props => [duration, total];
}

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class SetTimerTime extends TimerEvent {
  const SetTimerTime({this.addDuration = 0, this.resetDuration = 0});
  final int addDuration;
  final int resetDuration;
}