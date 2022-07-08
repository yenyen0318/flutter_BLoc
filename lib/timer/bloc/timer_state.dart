part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration; 
  final int total; 
  const TimerState(this.duration, this.total);
  
  @override
  List<Object> get props => [duration, total];
}

class TimerInitial extends TimerState {
  const TimerInitial(int duration, int total) : super(duration, total);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

class TimerRunInProgress  extends TimerState{
  const TimerRunInProgress(int duration, int total) : super(duration, total);
  
  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

class TimerRunPause extends TimerState{
  const TimerRunPause(int duration, int total) : super(duration, total);

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}

class TimerRunComplete extends TimerState{
  const TimerRunComplete() : super(0,0);

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}