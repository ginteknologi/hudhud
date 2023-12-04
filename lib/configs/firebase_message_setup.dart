import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/firebase_options.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:simple_moment/simple_moment.dart';

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

Future<void> Scheduling() async {
  try {
  final service = FlutterBackgroundService();
  await service.configure(
    iosConfiguration: IosConfiguration(), 
    androidConfiguration: AndroidConfiguration(
      onStart: onStartPlay, 
      isForegroundMode: false
    )
  );
  await service.startService();
    
  } catch (e) {
    print(e);
  }
}

@pragma('vm:entry-point')
final FlutterLocalNotificationsPlugin notiFPlugin = FlutterLocalNotificationsPlugin();
void onStartPlay(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }
  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Timer.periodic(const Duration(seconds: 60), (timer) async{ 
    print('checking adzan');
    if(service is AndroidServiceInstance){
        var timeleft = DateTime.now();
        int hourminutes = int.parse("${timeleft.hour}${timeleft.minute}");
        var sholatSaatIni;
        if (authStore.read('waktusolat') != null) {
          for (var element in authStore.read('waktusolat')) {
            if (element['active']) {
              sholatSaatIni = element;
            }
          }
          String resultString = sholatSaatIni['waktu'].replaceAll(':', '');
          print(sholatSaatIni);
          if (hourminutes == int.parse(resultString)) {
              notiFPlugin.show(
                  DateTime.now().microsecond + DateTime.now().minute,
                  'Adzan',
                  'Waktunya Sholat ${sholatSaatIni['label']}',
                  NotificationDetails(
                    android: AndroidNotificationDetails(
                      'adzan_notification',
                      'Adzan Notif',
                      channelDescription: 'channel adzan notif',
                      importance: Importance.max,
                      priority: Priority.high,
                      playSound: true,
                      sound: RawResourceAndroidNotificationSound('adzan'),
                      enableVibration: false,
                      audioAttributesUsage: AudioAttributesUsage.alarm,
                      actions: <AndroidNotificationAction>[
                        AndroidNotificationAction(
                          'adzan_notification',
                          'Tutup Adzan',
                          // icon: DrawableResourceAndroidBitmap('@mipmap/ic_largeIcon'),
                          showsUserInterface: false,
                          // By default, Android plugin will dismiss the notification when the
                          // user tapped on a action (this mimics the behavior on iOS).
                          cancelNotification: true,
                        ),
                      ],
                    ),
                  ),
                );
          }
        }

      if(await service.isForegroundService()){
        service.setForegroundNotificationInfo(
          title: 'PushNotif', 
          content: 'updates at ${DateTime.now()}'
        );
      }
    }
  });    
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
              playSound: true,
              importance: Importance.high,
              setAsGroupSummary: true,
            ),
          ),
          payload: jsonString);
    }
  }

  static Future initFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          description:
              'This channel is used for important notifications.', // description
          importance: Importance.high,
          playSound: true);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      final DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
              requestSoundPermission: false,
              requestBadgePermission: false,
              requestAlertPermission: false,
              onDidReceiveLocalNotification: onDidReceiveLocalNotification
              );
      const DarwinInitializationSettings initializationSettingsMacOS =
          DarwinInitializationSettings();

      final InitializationSettings initializationSettings =
          InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: initializationSettingsIOS,
              macOS: initializationSettingsMacOS
              );

      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
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
    // await Scheduling();
  }
}
