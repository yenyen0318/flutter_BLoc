import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationUtils {
  static Future<void> initNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'alarm_channel',
          channelName: '倒數計時器',
          defaultColor: Colors.blue,
          importance: NotificationImportance.High,
          playSound: true,
          channelShowBadge: false,
          channelDescription: '倒數計時器提醒通知',
        ),
      ],
    );
  }

  static void allowedNotification(context) {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Allow Notifications'),
              content: Text('Our app would like to send you notifications'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Don\'t Allow',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () => AwesomeNotifications()
                      .requestPermissionToSendNotifications()
                      .then((_) => Navigator.pop(context)),
                  child: Text(
                    'Allow',
                    style: TextStyle(
                      color: Colors.teal,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  static void listenNotification(BuildContext context) {
    AwesomeNotifications().actionStream.listen((receivedAction) {
      switch (receivedAction.channelKey) {
        case 'alarm_channel':
          switch (receivedAction.buttonKeyPressed) {
            case 'OK':
              debugPrint('OK');
              break;
            default:
              if(receivedAction.buttonKeyPressed.startsWith('SLEEP')){
                int duration = int.parse(receivedAction.buttonKeyPressed.split('_')[1]);
                debugPrint('$duration');
              }
              break;
          }
          break;
      }
    });
  }

  static Future<void> timerNotification(int sec) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'alarm_channel',
          title: '倒數計時',
          body: '時間到囉!!時間到囉!!時間到囉!!時間到囉!!時間到囉!!',
          wakeUpScreen: true,
          color: Colors.blueGrey,
          category: NotificationCategory.Alarm,
          autoDismissible: true,
        ),
        schedule: NotificationInterval(interval: sec, preciseAlarm: true),
        actionButtons: [
          NotificationActionButton(
              key: 'SLEEP_10',
              label: '延遲10秒',
              showInCompactView: false,
              enabled: true,
              buttonType: ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'SLEEP_30',
              label: '延遲30秒',
              showInCompactView: false,
              enabled: true,
              buttonType: ActionButtonType.KeepOnTop),
          NotificationActionButton(
              key: 'OK',
              label: '完成',
              showInCompactView: false,
              enabled: true,
              buttonType: ActionButtonType.KeepOnTop),
        ]);
  }
}
