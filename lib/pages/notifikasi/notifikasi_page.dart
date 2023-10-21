import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/pages/doa/doa_controller.dart';
import 'package:mesjid_app/pages/notifikasi/notifikasi_controller.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(NotifikasiController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Notifikasi", context: context, elevation: 0),
      body: Text('notif'),
    );
  }
}
