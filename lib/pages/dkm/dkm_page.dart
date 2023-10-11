import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/dkm/dkm_controller.dart';

class DkmPage extends StatelessWidget {
  const DkmPage({super.key});

  layout(DkmController ctrl, BuildContext context) {
    return const SafeArea(
      child: Text("Ini Dkm"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DkmController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: layout(ctrl, context),
    );
  }
}
