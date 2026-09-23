import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:masjid_app/configs/firebase_message_setup.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/theme.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await PreferencesService.init();
  await initializeDateFormatting('id_ID', null);

  try {
    await [
      Permission.notification,
      Permission.location,
    ].request();
    await SetupFirebase.initFirebase();
  } catch (e) {
    debugPrint('Firebase init error: $e');
  }

  if (!kIsWeb && kReleaseMode && Platform.isAndroid) {
    try {
      InAppUpdate.checkForUpdate().then((updateInfo) async {
        if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
          try {
            await InAppUpdate.performImmediateUpdate();
            Fluttertoast.showToast(
                msg: "Silahkah buka ulang aplikasi ...",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.CENTER);
          } catch (e) {
            debugPrint('Update error: $e');
          }
        }
      }, onError: (e) => debugPrint('Check update error: $e'));
    } catch (e) {
      debugPrint('InAppUpdate error: $e');
    }
  }

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
        path: 'assets/lang',
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      routerConfig: router,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      themeMode: ThemeMode.light,
    );
  }
}
