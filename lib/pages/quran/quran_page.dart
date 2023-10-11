import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/pages/quran/quran_controller.dart';

class QuranPage extends StatelessWidget {
  const QuranPage({super.key});

  layout(QuranController ctrl, BuildContext context) {
    return SafeArea(
      child: Text("Ini Quran"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(QuranController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: layout(ctrl, context),
    );
  }
}
