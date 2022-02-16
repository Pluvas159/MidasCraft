import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:midascraft/main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../widgets/hlasovanie/hlasovanie.dart';
import '../widgets/loading/loading.dart';



class NotificationApi {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();


  get onDidReceiveLocalNotification => null;


  void send_notification(String title, String body) async {
    if(!LoadState.prefs.getBool("notificationState")) { return;}
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, title, body, platformChannelSpecifics,
        payload: 'item x');
  }

  void initialize() async {
// initialise the plugin.
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('midascraft');
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  void selectNotification(String? payload) async {
    Navigator.of(MidasCraft.materialKey.currentContext!).pushReplacementNamed(Hlasovanie.route);
  }

  void send_timed_notification(String title, String body, DateTime time) async {
    if(!LoadState.prefs.getBool("notificationState")) { return;}
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          0, title, body, tz.TZDateTime.from(time, tz.local),
          NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                channelDescription: 'your channel description'),
          ), androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
              .absoluteTime
      );
    } on ArgumentError catch (_) {

    }
  }
}