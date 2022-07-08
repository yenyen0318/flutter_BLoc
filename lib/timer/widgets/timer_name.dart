import 'package:flutter/material.dart';

class TimerName extends StatelessWidget {
  const TimerName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Text('小時',
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal)),
      SizedBox(
        width: 25,
      ),
      Text('分鐘',
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal)),
      SizedBox(
        width: 30,
      ),
      Text('秒 ',
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal)),
    ]);
  }
}