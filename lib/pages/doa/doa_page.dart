import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/pages/doa/doa_controller.dart';
import 'package:masjid_app/routes/doa/index.dart';

class DoaPage extends StatelessWidget {
  const DoaPage({super.key});

  layout(BuildContext context, DoaController ctrl) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 21),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: ctrl.list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // Datum model = filteredEvents[index];
                    return FadeInUp(
                      child: ListItemUiWidget(
                        id: ctrl.list[index].id,
                        title: ctrl.list[index].name,
                        onTap: () {
                          Get.toNamed('${RoutesDoa.root}/${ctrl.list[index].id}');
                        },
                        titleStyle: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        // subTitle: ctrl.list[index]['subtitle'],
                        subtitleStyle: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.black),
                        hasRightContent: true,
                        showIcon: IconPosition.both,
                        // iconLeft: SvgPicture.asset(
                        //     ctrl.list[index]['icon'],
                        //     height: 35,
                        //     width: 35),
                        iconRight: Icon(Icons.chevron_right_rounded),
                      ),
                    );
                  },
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DoaController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Do'a", context: context, elevation: 0),
      body: Obx(() => ctrl.isLoadingList.value ? const Center(child: CircularProgressIndicator()) : layout(context, ctrl)),
    );
  }
}
