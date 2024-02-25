import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/controllers/dashboard_controller.dart';

class KajianLivePage extends StatelessWidget {
  const KajianLivePage({super.key});

  layout(DashboardController ctrl, BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  children: [],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DashboardController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Sedekah", context: context, elevation: 0),
      body: layout(ctrl, context),
    );
  }
}
