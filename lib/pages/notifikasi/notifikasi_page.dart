import 'package:animate_do/animate_do.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/doa/doa_controller.dart';
import 'package:mesjid_app/pages/notifikasi/notifikasi_controller.dart';
import 'package:mesjid_app/theme.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  layout(context, ctrl) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 21),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: ctrl.listNotif.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // Datum model = filteredEvents[index];
                    return FadeInUp(
                      child: ListItemUiWidget(
                        id: ctrl.listNotif[index]['id'],
                        title:
                            priceFormat.format(ctrl.listNotif[index]['title']),
                        onTap: () {
                          ctrl.goToDetail(ctrl.listNotif[index]);
                        },
                        titleStyle: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                        category: ctrl.listNotif[index]['category'],
                        hasRightContent: true,
                        rightContent: [
                          Text(
                              ctrl.listNotif[index]['type'] == "success"
                                  ? "Berhasil"
                                  : ctrl.listNotif[index]['type'] == "pending"
                                      ? "Menunggu Pembayaran"
                                      : "Dibatalkan",
                              textAlign: TextAlign.end,
                              style: context.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color:
                                      ctrl.listNotif[index]['type'] == "success"
                                          ? Theme.of(context).primaryColor
                                          : ctrl.listNotif[index]['type'] ==
                                                  "pending"
                                              ? Color(0xFFFFA800)
                                              : Color(0xFFFF0000))),
                          Text(
                              ctrl.listNotif[index]['date'] +
                                  ', ' +
                                  ctrl.listNotif[index]['time'],
                              textAlign: TextAlign.end,
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.normal,
                              ))
                        ],
                      ),
                    );
                  },
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(NotifikasiController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Notifikasi", context: context, elevation: 0),
      body: layout(context, ctrl),
    );
  }
}
