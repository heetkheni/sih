import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class NotificationServices {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Request notification permissions
  void notificationPermission() async {
    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      provisional: true,
      sound: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission.");
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional permission.");
    } else {
      print("User denied permission.");
    }
  }

  // Retrieve the Firebase Cloud Messaging token
  Future<String> getToken() async {
    String? token = await firebaseMessaging.getToken();
    return token!;
  }

  // Listen for token refresh events
  void isTokenRefresh() async {
    firebaseMessaging.onTokenRefresh.listen((event) {
      print("Token refreshed: $event");
    });
  }

  // Initialize local notifications
  void initLocalNotification(BuildContext context, RemoteMessage message) async {
    var androidInitialization = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(android: androidInitialization);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        // Handle notification response
      },
    );
  }

  // Initialize Firebase messaging
  void firebaseInit() async {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print("Message title: ${message.notification!.title}");
        print("Message body: ${message.notification!.body}");
      }

      showNotification(message);
    });
  }

  // Show local notification
  Future<void> showNotification(RemoteMessage message) async {
    var androidNotificationChannel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'sih_practice',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    var androidNotificationDetails = AndroidNotificationDetails(
      androidNotificationChannel.id,
      androidNotificationChannel.name,
      channelDescription: androidNotificationChannel.description,
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: BigPictureStyleInformation(
        FilePathAndroidBitmap("assets/images/heart.png"),
        largeIcon: FilePathAndroidBitmap("assets/images/heart.png"),
      ),
    );

    var notificationDetails = NotificationDetails(android: androidNotificationDetails);

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    });
  }
}
