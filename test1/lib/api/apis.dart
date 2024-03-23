import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Tiêu đề: ${message.notification?.title}');
  print('Nội dung: ${message.notification?.body}');
  print('Nội dung: ${message.data}');
}

final DatabaseReference _database = FirebaseDatabase.instance.ref(
    'device_tokens');

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(provisional: true);

    FirebaseMessaging.instance.setAutoInitEnabled(true);
    if (await hasFCMToken()) {
      final fCMToken = await _firebaseMessaging.getToken();
      print("Token: $fCMToken");

      _database.child(fCMToken.toString()).set({
        'token': fCMToken,
        'timestamp': DateTime.now().toString(),
      });
    } else {
      print("FCM token không khả dụng.");
    }
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<bool> hasFCMToken() async {
    final token = await _firebaseMessaging.getToken();
    return token != null;
  }
}

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void requestNotificationPermission() async {
  }

  Future<void> initLocalNotification(BuildContext context, RemoteMessage message) async {
    var android = const AndroidInitializationSettings('@mipmap/ic_laucher');
    var initializationSetting = InitializationSettings(
      android: android,
    );
    await _flutterLocalNotificationsPlugin.initialize(
        initializationSetting, onDidReceiveBackgroundNotificationResponse: (payload) {

    });
  }

  void firebaseInit() {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
      }
    }
    );
  }

}