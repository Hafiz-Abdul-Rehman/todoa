import 'dart:io';
import 'dart:math';
import 'package:timezone/timezone.dart';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todoa/screens/profile_screen.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: true,
      sound: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Granted Permission!");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User Granted Provisional Permission!");
    } else {
      AppSettings.openNotificationSettings();
      // AppSettings.openAppSettings(type: AppSettingsType.notification);
      print("User Rejected Permission!");
    }
  }

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitialization =
        const AndroidInitializationSettings("@mipmap/ic_launcher");
    var drawinInitialization = const DarwinInitializationSettings();
    var intializationSettings = InitializationSettings(
        android: androidInitialization, iOS: drawinInitialization);
    await flutterLocalNotificationsPlugin.initialize(
      intializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
        Random.secure().nextInt(100000).toString(),
        "High Important Notifications",
        importance: Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: "your channel Description!",
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentBadge: true,
      presentAlert: true,
      presentSound: true,
    );
    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          1,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  Future<void> setupInteractMessage(BuildContext context)async{
    // When app is Terminated!
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if(initialMessage != null){
      handleMessage(context, initialMessage);
    }
    // When App is in Background!
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      handleMessage(context, msg);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    await messaging.onTokenRefresh.listen((event) {
      print("Event: $event");
      event.toString();
      print("Refresh");
    });
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data["type"] == 'msg') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
    }
  }
  // Future<void> scheduleNotification(int id, String title, String body,
  //     DateTime scheduledTime) async {
  //   AndroidNotificationChannel channel = AndroidNotificationChannel(
  //       Random.secure().nextInt(100000).toString(),
  //       "High Important Notifications",
  //       importance: Importance.max);
  //   var androidPlatformChannelSpecifics =  AndroidNotificationDetails(
  //     channel.id.toString(),
  //     channel.name.toString(),
  //     channelDescription: 'Your Channel Description',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  //   var platformChannelSpecifics = NotificationDetails(
  //       android: androidPlatformChannelSpecifics,);
  //
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     TZDateTime.from(scheduledTime, getLocation('your_timezone')),
  //     platformChannelSpecifics,
  //     androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //     UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );
  // }

// Usage example

}
