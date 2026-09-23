import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/firebase_options.dart';
import 'package:open_filex/open_filex.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:simple_moment/simple_moment.dart';

final authStore = GetStorage();
late FirebaseMessaging messaging;
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  if (kDebugMode) {
    debugPrint('Handling a background message ${message.messageId}');
  }
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

// Future<void> Scheduling() async {
//   try {
//     final service = FlutterBackgroundService();
//     await service.configure(
//         iosConfiguration: IosConfiguration(),
//         androidConfiguration:
//             AndroidConfiguration(onStart: onStartPlay, isForegroundMode: true));
//     await service.startService();
//   } catch (e) {
//     print(e);
//   }
// }

// @pragma('vm:entry-point')
// final FlutterLocalNotificationsPlugin notiFPlugin =
//     FlutterLocalNotificationsPlugin();
// void onStartPlay(ServiceInstance service) async {
//   if (service is AndroidServiceInstance) {
//     service.on('setAsForeground').listen((event) {
//       service.setAsForegroundService();
//     });

//     service.on('setAsBackground').listen((event) {
//       service.setAsBackgroundService();
//     });
//   }
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });

// Timer.periodic(const Duration(seconds: 1200), (timer) async {
//   print('checking adzan');
//   if (service is AndroidServiceInstance) {
//     print('checking adzan 2');
//     notiFPlugin.show(
//       DateTime.now().microsecond + DateTime.now().minute,
//       'Adzan',
//       'Waktunya Sholat',
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           'adzan_notification',
//           'Adzan Notif',
//           channelDescription: 'channel adzan notif',
//           importance: Importance.max,
//           priority: Priority.high,
//           autoCancel: false,
//           playSound: true,
//           sound: RawResourceAndroidNotificationSound('adzan'),
//           enableVibration: false,
//           audioAttributesUsage: AudioAttributesUsage.media,
//           actions: <AndroidNotificationAction>[
//             AndroidNotificationAction(
//               'adzan_notification',
//               'Tutup Adzan',
//               // icon: DrawableResourceAndroidBitmap('@mipmap/ic_largeIcon'),
//               showsUserInterface: false,
//               // By default, Android plugin will dismiss the notification when the
//               // user tapped on a action (this mimics the behavior on iOS).
//               cancelNotification: true,
//             ),
//           ],
//         ),
//       ),
//     );

//     if (await service.isForegroundService()) {
//       service.setForegroundNotificationInfo(
//           title: 'PushNotif', content: 'updates at ${DateTime.now()}');
//     }
//   }
// });
// }

class SetupFirebase {
  // static get onDidReceiveLocalNotification => null;
  static void sendnotif({
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
              playSound: true,
              importance: Importance.high,
              setAsGroupSummary: true,
            ),
          ),
          payload: jsonString);
    }
  }

  static Future initFirebase() async {
    if (Firebase.apps.isEmpty) {
      try {
        await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform);
      } catch (e) {
        if (kDebugMode) {
          debugPrint("Firebase already initialized: $e");
        }
      }
    }
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel',
        'High Importance Notifications',
        description: 'This channel is used for important notifications.',
        importance: Importance.high,
        playSound: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      const DarwinInitializationSettings initializationSettingsMacOS =
          DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        // onDidReceiveBackgroundNotificationResponse: yourBgHandler, // opsional
      );

      // Buat notification channel Android (WAJIB untuk Android 8+)
      final androidPlugin =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(channel);

      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    messaging = FirebaseMessaging.instance;
    await messaging.subscribeToTopic("all");

    messaging.getToken().then((value) async {
      authStore.write('fcmtoken', value);
      debugPrint('token firebase: $value');
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;
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
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
            ),
          ),
          payload: jsonString,
        );
      }
    });
  }
}
