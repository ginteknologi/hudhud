import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mesjid_app/configs/firebase_message_setup.dart';
import 'package:mesjid_app/routes/index.dart';
import 'package:mesjid_app/configs/main_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mesjid_app/theme.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:easy_localization/easy_localization.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('id_ID');

  if (!kIsWeb) {
    SetupFirebase.initFirebase();
    await [
      Permission.location,
      Permission.storage,
      // Permission.camera,
      Permission.notification,
      // Permission.appTrackingTransparency,
    ].request();
  }
  // InAppUpdate.checkForUpdate().then((updateInfo) {
  //   if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
  //     InAppUpdate.performImmediateUpdate()
  //         .then((value) => {
  //               Fluttertoast.showToast(
  //                   msg: "Silahkah buka ulang aplikasi ...",
  //                   toastLength: Toast.LENGTH_LONG,
  //                   gravity: ToastGravity.CENTER)
  //             })
  //         .catchError((e) {});
  //   }
  // });
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
        path: 'assets/lang', // <-- change the path of the translation files
        child: MyApp()),
    // MyApp()
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  // final gctrl = Get.put(SocketController());
  final mainCtrl = Get.put(MainController());
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    return GetMaterialApp(
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.cupertino,
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      themeMode: ThemeMode.light,
      initialRoute: AppPages.root,
      getPages: AppPages.list,
    );
  }
}
