import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/doa/doa_controller.dart';

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
                  itemCount: ctrl.listTypesDoa.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // Datum model = filteredEvents[index];
                    return FadeInUp(
                      child: ListItemUiWidget(
                        id: ctrl.listTypesDoa[index]['id'],
                        title: ctrl.listTypesDoa[index]['title'],
                        onTap: () {
                          ctrl.goToDetail(ctrl.listTypesDoa[index]);
                        },
                        titleStyle: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        subTitle: ctrl.listTypesDoa[index]['subtitle'],
                        subtitleStyle: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.black),
                        hasRightContent: true,
                        showIcon: IconPosition.both,
                        iconLeft: SvgPicture.asset(
                            ctrl.listTypesDoa[index]['icon'],
                            height: 35,
                            width: 35),
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
      body: layout(context, ctrl),
    );
  }
}
