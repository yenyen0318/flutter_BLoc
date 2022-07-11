class Ticker {
  const Ticker();
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }
}

List<String> TimeTransform(int duration) {
  final hoursStr = ((duration / 3600) % 60).floor().toString().padLeft(2, '0');
  final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
  final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
  return [hoursStr, minutesStr, secondsStr];
}

int CalTotalDuration(int hour, int min, int sec) {
  return hour * 3600 + min * 60 + sec;
}
