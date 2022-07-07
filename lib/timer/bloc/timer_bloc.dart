import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_counter/timer/ticker.dart';
import 'package:equatable/equatable.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  static int _duration = 0; //當前秒數

  //監聽事件並提共callbacks，也可用於取消訂閱等
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(TimerInitial(0)) {
    //依據各event事件加入商業邏輯
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
    on<SetTimerTime>(_setTime);
  }

  @override
  Future<void> close() {
    //關閉_tickerSubscription時取消TimerBloc
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    if (state.duration > 0) {
      //當TimerBloc收到TimerStarted事件，會推送一個TimerRunInProgress事件出去
      emit(TimerRunInProgress(state.duration));
      //若已存在則進行取消以釋放記憶體
      _tickerSubscription?.cancel();
      //監聽流並推送剩餘時間事件
      _tickerSubscription = _ticker
          .tick(ticks: state.duration)
          .listen((duration) => add(TimerTicked(duration: duration)));
    }
  }

  void _setTime(SetTimerTime event, Emitter<TimerState> emit) {
    if (state is TimerRunInProgress || state is TimerRunPause) {
      //若已存在則進行取消以釋放記憶體
      _tickerSubscription?.cancel();
      //重設倒數秒數
      _duration = _durationValidator(state.duration + event.addDuration);
      //監聽流並推送剩餘時間事件
      _tickerSubscription = _ticker
          .tick(ticks: _duration)
          .listen((duration) => add(TimerTicked(duration: duration)));

      //主動告知使用者當前狀態，避免停頓
      if (state is TimerRunInProgress) {
        emit(TimerRunInProgress(_duration));
      } else {
        _tickerSubscription?.pause();
        emit(TimerRunPause(_duration));
      }
    } else {
      _duration = _durationValidator(_duration + event.addDuration);
      emit(TimerInitial(_duration));
    }
  }

  ///檢查時間是否合理
  int _durationValidator(int duration) {
    return duration < 0
        ? 3600 + duration
        : duration >= 3600
            ? 3600 - duration
            : duration;
  }

  void _onTicked(TimerTicked event, Emitter<TimerState> emit) {
    //當時間大於0推送一個TimerRunInProgress事件，小於0則推送一個TimerRunComplete事件
    emit(
      event.duration > 0
          ? TimerRunInProgress(event.duration)
          : TimerRunComplete(),
    );
  }

  void _onPaused(TimerPaused event, Emitter<TimerState> emit) {
    //若當前狀態時間正在倒數中則暫停並推送一個TimerRunPause事件
    if (state is TimerRunInProgress) {
      _tickerSubscription?.pause();
      emit(TimerRunPause(state.duration));
    }
  }

  void _onResumed(TimerResumed event, Emitter<TimerState> emit) {
    //若當前狀態暫停中則繼續倒數並推送一個TimerRunInProgress事件
    if (state is TimerRunPause) {
      _tickerSubscription?.resume();
      emit(TimerRunInProgress(state.duration));
    }
  }

  void _onReset(TimerEvent event, Emitter<TimerState> emit) {
    _duration = 0;
    //若已存在則進行取消以避免收到不必要的倒數事件
    _tickerSubscription?.cancel();
    //推送一個TimerInitial事件重新計時
    emit(TimerInitial(0));
  }
}
