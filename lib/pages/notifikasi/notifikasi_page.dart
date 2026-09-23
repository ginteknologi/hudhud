import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/pages/notifikasi/notifikasi_controller.dart';
import 'package:masjid_app/routes/notifikasi/index.dart';
import 'package:easy_localization/easy_localization.dart';
class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({super.key});

  SafeArea layout(BuildContext context, NotifikasiController ctrl) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 21),
                child: ctrl.list.isNotEmpty ? 
                ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: ctrl.list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return FadeInUp(
                      child: ListItemUiWidget(
                        id: ctrl.list[index]['id'],
                        title: ctrl.list[index]['judul'],
                        onTap: () {
                          if (ctrl.list[index]['jenis_notifikasi'] == 'transaksi') {
                            Get.toNamed('${RoutesNotifikasi.root}/detail/${ctrl.list[index]['id']}');
                          } 
                        },
                        titleStyle: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                        category: ctrl.list[index]['jenis_notifikasi'],
                        hasRightContent: true,
                        rightContent: [
                          // Text(
                          //     ctrl.list[index]['type'] == "success"
                          //         ? "Berhasil"
                          //         : ctrl.list[index]['type'] == "pending"
                          //             ? "Menunggu Pembayaran"
                          //             : "Dibatalkan",
                          //     textAlign: TextAlign.end,
                          //     style: context.textTheme.bodySmall?.copyWith(
                          //         fontWeight: FontWeight.bold,
                          //         color:
                          //             ctrl.list[index]['type'] == "success"
                          //                 ? Theme.of(context).primaryColor
                          //                 : ctrl.list[index]['type'] ==
                          //                         "pending"
                          //                     ? Color(0xFFFFA800)
                          //                     : Color(0xFFFF0000))),
                          Text(DateFormat('HH:mm, dd MMMM yyyy').format(DateTime.parse(ctrl.list[index]['createdAt'])),
                              textAlign: TextAlign.end,
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.normal,
                              ))
                        ],
                      ),
                    );
                  },
                ) 
                :
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 100,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada notifikasi',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),                
                  ),
                )
              )
            )
          );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(NotifikasiController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Notifikasi", context: context, elevation: 0),
      body: Obx(() => ctrl.isLoadingList.value ? Center(child: CircularProgressIndicator()) : layout(context, ctrl)),
    );
  }
}
