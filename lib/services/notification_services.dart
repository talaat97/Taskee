import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:to_do_app/models/task.dart';
import 'package:to_do_app/ui/pages/notification_screen.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String selectedNotificationPayload = '';

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  Future<void> initializeNotification() async {
    tz.initializeTimeZones();
    _configureSelectNotificationSubject();
    await _configureLocalTimeZone();
    // await requestIOSPermissions(flutterLocalNotificationsPlugin);
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsIOS,
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.payload != null) {
          debugPrint('notification payload: ${response.payload}');
        }
        selectNotificationSubject.add(response.payload!);
      },
    );
  }

  void displayNotification(
      {required String title, required String body}) async {
    print('doing test');
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your_channel_id', 'your_channel_name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

//////////////////////////////////
  void showScudleNotification(timee) async {
    tz.initializeTimeZones();

    ////////set the local notifaction
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    var schudelDate = tz.TZDateTime.now(tz.local).add(Duration(seconds: timee));
    await flutterLocalNotificationsPlugin.zonedSchedule(
      2,
      'Scudle Notification',
      'Scudle Notification body',
      schudelDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'id 3',
          'Scudle notifcation',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print('Scudle notifcation work with schudel date $schudelDate');
  }

///////////////////////////////////
  Future<void> scheduledNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!,
      task.title,
      task.note,
      _nextInstanceOfTenAM(
          hour, minutes, task.remind!, task.repeat!, task.date!),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: '${task.title}|${task.note}|${task.startTime}|',
    );
  }

  tz.TZDateTime _nextInstanceOfTenAM(
      int hour, int minutes, int remind, String repeat, String date) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print('now = $now');
    var formattedDate = DateFormat.yMd().parse(date);

    final tz.TZDateTime fd = tz.TZDateTime.from(formattedDate, tz.local);

    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, fd.year, fd.month, fd.day, hour, minutes);

    print("schudelDate$scheduledDate");

    scheduledDate = afterRemind(remind, scheduledDate);

    if (scheduledDate.isBefore(now)) {
      if (repeat == 'daily') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            formattedDate.day + 1, hour, minutes);
      }
      if (repeat == 'weekly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
            (formattedDate.day) + 7, hour, minutes);
      }
      if (repeat == 'monthly') {
        scheduledDate = tz.TZDateTime(tz.local, now.year,
            (formattedDate.month) + 1, formattedDate.day, hour, minutes);
      }
      scheduledDate = afterRemind(remind, scheduledDate);
    }

    print("next schudelDate$scheduledDate");

    return scheduledDate;
  }

  tz.TZDateTime afterRemind(int remind, tz.TZDateTime scheduledDate) {
    if (remind == 5) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 5));
    }
    if (remind == 10) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 10));
    }
    if (remind == 15) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 15));
    }
    if (remind == 20) {
      scheduledDate = scheduledDate.subtract(const Duration(minutes: 20));
    }
    return scheduledDate;
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(Text(body!));
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload) async {
      debugPrint('My payload is $payload');
      await Get.to(() => NotificationScreen(payload: payload));
    });
  }

  void dispose() {
    selectNotificationSubject.close();
  }

  void cancelNotifaction(Task task) async {
    await flutterLocalNotificationsPlugin.cancel(task.id!);
  }

  void cancelAllNotifaction() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

// class NotifyHelper {
//   static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static onTap(NotificationResponse notificationResponse) {}
//   static Future init() async {
//     InitializationSettings settings = const InitializationSettings(
//       iOS: DarwinInitializationSettings(),
//       android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//     );
//     flutterLocalNotificationsPlugin.initialize(
//       settings,
//       onDidReceiveBackgroundNotificationResponse: onTap,
//       onDidReceiveNotificationResponse: onTap,
//     );
//   }

//   static void showBasicNotification() async {
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'basic notifcation',
//       'body',
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'id 1',
//           'basic notifcation',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//     );
//   }

//   static void showPeriodicallyNotification() async {
//     await flutterLocalNotificationsPlugin.periodicallyShow(
//       1,
//       'periodic notifcation',
//       'body',
//       RepeatInterval.everyMinute,
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'id 2',
//           'periodic notifcation',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//     );
//     print('periodic notifcation work');
//   }

//   static void showScudleNotification() async {
//     tz.initializeTimeZones();
//     log(tz.TZDateTime.now(tz.local).hour.toString());
//     log(tz.local.toString());
//     ////////set the local notifaction
//     final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(currentTimeZone));
//     log(tz.TZDateTime.now(tz.local).hour.toString());
//     log(tz.TZDateTime.now(tz.local).minute.toString());
//     log(tz.local.toString());
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       2,
//       'Scudle Notification',
//       'Scudle Notification body',
//        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 3)),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'id 3',
//           'Scudle notifcation',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//         print('Scudle notifcation work');
//   }

//   static void cancelNotifaction(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
// }
