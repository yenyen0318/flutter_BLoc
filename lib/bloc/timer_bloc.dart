import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_counter/ticker.dart';
import 'package:equatable/equatable.dart';

part 'timer_event.dart';
part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  static const int _duration = 60;

  //監聽事件並提共callbacks，也可用於取消訂閱等
  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(TimerInitial(_duration)) {
    //依據各event事件加入商業邏輯
    on<TimerStarted>(_onStarted);
    on<TimerTicked>(_onTicked);
    on<TimerPaused>(_onPaused);
    on<TimerResumed>(_onResumed);
    on<TimerReset>(_onReset);
  }

  @override
  Future<void> close() {
    //關閉_tickerSubscription時取消TimerBloc
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onStarted(TimerStarted event, Emitter<TimerState> emit) {
    //當TimerBloc收到TimerStarted事件，會推送一個TimerRunInProgress事件出去
    emit(TimerRunInProgress(event.duration));
    //若已存在則進行取消以釋放記憶體
    _tickerSubscription?.cancel();
    //監聽流並推送剩餘時間事件
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
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
    //若已存在則進行取消以避免收到不必要的倒數事件
    _tickerSubscription?.cancel();
    //推送一個TimerInitial事件重新計時
    emit(TimerInitial(_duration));
  }
}