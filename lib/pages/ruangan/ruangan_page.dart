import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/ruangan/ruangan_controller.dart';

class RuanganPage extends StatelessWidget {
  const RuanganPage({super.key});

  layout(RuanganController ctrl, BuildContext context) {
    return const SafeArea(
      child: Text("Ini Ruangan"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(RuanganController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: layout(ctrl, context),
    );
  }
}
