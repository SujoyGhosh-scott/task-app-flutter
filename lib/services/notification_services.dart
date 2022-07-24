import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_app/models/task.dart';
import 'package:todo_app/ui/notified_page.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    _configureLoaclTimezone();
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings("appicon");

    final InitializationSettings initializationSettings =
        InitializationSettings(
            iOS: initializationSettingsIOS,
            android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    //display a dialog with notification details. tap ok to go...
    /**
     * showDialog(context: context, builder: (BuildContext: context) => CupertinoAlertDialog(...),);
     */

    Get.dialog(const Text("Welcome to flutter"));
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      if (kDebugMode) {
        print('notification payload: $payload');
      }
    } else {
      if (kDebugMode) {
        print("Notification Done");
      }
    }

    if (payload == "Theme Changed") {
      if (kDebugMode) {
        print("theme changed");
      }
    } else {
      Get.to(() => NotifiedPage(label: payload.toString()));
    }
  }

  displayNotification({required String title, required String body}) async {
    if (kDebugMode) {
      print("doing test");
    }
    var androidPlatformChallelSpecifics = const AndroidNotificationDetails(
        'channel id', 'channel name',
        importance: Importance.max, priority: Priority.high);
    var iOsPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChallelSpecifics,
        iOS: iOsPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: title);
  }

  scheduleNotification(int hour, int minutes, Task task) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id!.toInt(),
        task.title,
        task.note,
        _converTime(hour, minutes),
        //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails("channelId", "channelName")),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: "${task.title}|" "${task.note}|");
  }

  tz.TZDateTime _converTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);

    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }

    return scheduleDate;
  }

  Future<void> _configureLoaclTimezone() async {
    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  void requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }
}
