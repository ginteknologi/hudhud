import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mesjid_app/firebase_options.dart';
import 'package:open_filex/open_filex.dart';

final authStore = GetStorage();
late FirebaseMessaging messaging;
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  final String? payload = notificationResponse.payload;
  if (notificationResponse.payload != null) {
    debugPrint('notification payload: $payload');
    Map zz = jsonDecode(payload!);
    if (zz['jenis'] == "file") {
      OpenFilex.open(zz['path']);
    }
  }
}

class SetupFirebase {
  static get onDidReceiveLocalNotification => null;

  static sendnotif({
    required String title,
    required String pesan,
    dynamic payload,
    String? group,
  }) {
    final String jsonString = jsonEncode(payload);
    // print(jsonString);
    if (!kIsWeb) {
      flutterLocalNotificationsPlugin.show(
          DateTime.now().microsecond + DateTime.now().minute,
          title,
          pesan,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              groupKey: group,
              icon: '@mipmap/ic_launcher',
              playSound: true,
              importance: Importance.high,
              setAsGroupSummary: true,
              // sound: const UriAndroidNotificationSound("assets/suara.mp3"),
            ),
          ),
          payload: jsonString);
    }
  }

  static initFirebase() async {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    print("<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>");
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          description:
              'This channel is used for important notifications.', // description
          importance: Importance.high,
          playSound: true);
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
              requestSoundPermission: false,
              requestBadgePermission: false,
              requestAlertPermission: false,
              onDidReceiveLocalNotification: onDidReceiveLocalNotification);
      const DarwinInitializationSettings initializationSettingsMacOS =
          DarwinInitializationSettings();
      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS,
              macOS: initializationSettingsMacOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) async {
      authStore.write('fcmtoken', value);
      print('token firebase: ${value!}');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('weiiii');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      final String jsonString = jsonEncode(message.data);
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            payload: jsonString);
      }
    });
  }
}
