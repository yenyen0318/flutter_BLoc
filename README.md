# Flutter - BLoC
Bloc 可以讓頁面與邏輯分離變得容易管理，你可以想像他是頁面與邏輯的橋樑，一般會有全局的BLoC，每一個頁面也會對應有一個獨立的BLoC。

| 設定時間 | 倒數計時 | 通知時間 |
| -------- | -------- | -------- |
| ![](https://i.imgur.com/ATFphWa.png)     | ![](https://i.imgur.com/RiDoIOk.png)     | ![](https://i.imgur.com/oWSMUBZ.png)     |

## 安裝相關套件
### 主要
```
flutter pub add flutter_bloc
flutter pub add bloc

//語法糖
flutter pub add equatable
```
### VSCode相關
bloc : 可以為你生成基本架構
![](https://i.imgur.com/uL1BgaZ.png)

#### 使用方式
1. 右鍵
![](https://i.imgur.com/PZejkkq.png)
2. 輸入bloc名稱
![](https://i.imgur.com/q2NWcLr.png)
3. 就可以自動建出Bloc 的基本架構，分別為 Event、State 和Bloc。
![](https://i.imgur.com/sRMTLiC.png)

## BLoC流程
![](https://i.imgur.com/Gnv1HnZ.png)

以倒數計時為例: 
一個倒數計時器，有暫停、重新開始兩顆按鈕。(如圖)



| 開始計時 | 正在倒數 | 暫停倒數 |計時完成 |
| -------- | -------- | -------- |-------- |
| ![](https://i.imgur.com/bhFKxdj.png)     |  ![](https://i.imgur.com/ulHHzNF.png)   | ![](https://i.imgur.com/cASS4jk.png)      |![](https://i.imgur.com/js0x6bc.png)     |


### 先思考會有哪些狀態(State)
* `TimerInitial` 開始計時
* `TimerRunInProgress` 正在倒數計時
* `TimerRunPause` 計時器暫停
* `TimerRunComplete` 計時完成

bloc/timer_state.dart
```dart
part of 'timer_bloc.dart';

abstract class TimerState extends Equatable {
  final int duration;   //當前秒數

  const TimerState(this.duration);

  @override
  List<Object> get props => [duration];
}

class TimerInitial extends TimerState {
  const TimerInitial(int duration) : super(duration);

  @override
  String toString() => 'TimerInitial { duration: $duration }';
}

class TimerRunPause extends TimerState {
  const TimerRunPause(int duration) : super(duration);

  @override
  String toString() => 'TimerRunPause { duration: $duration }';
}

class TimerRunInProgress extends TimerState {
  const TimerRunInProgress(int duration) : super(duration);

  @override
  String toString() => 'TimerRunInProgress { duration: $duration }';
}

class TimerRunComplete extends TimerState {
  const TimerRunComplete() : super(0);
}
```


### 思考可以觸發的事件(Event)
可以從狀態推測可能會有以下事件:
* `TimerInitial` 開始計時 >> **`TimerStarted`**
* `TimerRunInProgress` 正在倒數計時 >> **`TimerTicked`**
* `TimerRunPause` 計時器暫停
    * **`TimerPaused`** >> 正在倒數變成暫停
    * **`TimerResumed`** >> 正在暫停變成倒數
* `TimerRunComplete` 計時完成 >> **`TimerReset`** 重新計時

bloc/timer_event.dart
```dart
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

class TimerPaused extends TimerEvent {
  const TimerPaused();
}

class TimerResumed extends TimerEvent {
  const TimerResumed();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}

class TimerTicked extends TimerEvent {
  const TimerTicked({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}
```

### 每個事件(Event)的商業邏輯(BLoC)
* `TimerStarted` 開始計時 >> 通知計時器開始計時，StreamSubscription開始每秒監聽事件
* `TimerTicked` 正在倒數計時 >> 若時間小於0告知計時器倒數完成，反之則告知正在倒數中
* `TimerPaused` 計時器暫停 >> 通知計時器暫停計時，StreamSubscription暫停監聽事件
* `TimerResumed` 計時器從暫停變為繼續 >> 通知計時器繼續計時，StreamSubscription繼續監聽事件
* `TimerReset` 重新計時 >> 通知計時器初始化，並取消原有StreamSubscription監聽事件

bloc/timer_bloc.dart
```dart
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
```


## flutter_bloc內提供的widget
### BlocBuilder
當Bloc的State有變化，他會根據你的設計重建App的介面。使用BlocBuilder就不再需要使用setState()幫我們重繪介面了。
#### buildWhen
`buildWhen`參數表示，獲取先前的buildWhenbloc 狀態和當前 bloc 狀態，如果buildWhen返回true，widget將重建。如果buildWhen返回false，widget不會進行重建(如圖，每次重建背景顏色改變)。

| 未使用buildWhen(隨上方倒數進行重建) | 使用buildWhen(有點擊按鈕列時才重建) |
| -------- | -------- | 
| ![](https://i.imgur.com/vnSref7.gif)     |  ![](https://i.imgur.com/UEQSgyM.gif)|


```dart
class Actions extends StatelessWidget {
  const Actions({Key? key}) : super(key: key);

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
            ],if (state is TimerRunInProgress) ...[
              FloatingActionButton(
                child: Icon(Icons.pause),
                onPressed: () => context.read<TimerBloc>().add(TimerPaused()),
              ),
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => context.read<TimerBloc>().add(TimerReset()),
              ),
            ],
            if (state is TimerRunPause) ...[
              FloatingActionButton(
                child: Icon(Icons.play_arrow),
                onPressed: () => context.read<TimerBloc>().add(TimerResumed()),
              ),
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => context.read<TimerBloc>().add(TimerReset()),
              ),
            ],
            if (state is TimerRunComplete) ...[
              FloatingActionButton(
                child: Icon(Icons.replay),
                onPressed: () => context.read<TimerBloc>().add(TimerReset()),
              ),
            ]
            ],
          );
          
        });
  }
}

```


### BlocProvider
BlocProvider負責供應Bloc給其他widget。它可以將Bloc給他widget tree下的children使用。

```dart
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
```


## 參考資料
https://github.com/Daviswww/triathlon_flutter/tree/master/day13
https://bloclibrary.dev/#/fluttertimertutorial
https://ithelp.ithome.com.tw/articles/10219370
https://juejin.cn/post/6844903689082109960
https://www.raywenderlich.com/31973428-getting-started-with-the-bloc-pattern

###### tags: `flutter`

