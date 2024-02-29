import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/outlinebutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/pages/quran/pengaturan/alquran_pengaturan_controller.dart';
import 'package:masjid_app/controllers/main_controller.dart';

class AlquranPengaturanPage extends StatelessWidget {
  const AlquranPengaturanPage({Key? key}) : super(key: key);

  layout(AlquranPengaturanController ctrl, MainController gctrl,
      BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Umum",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      AutoSizeText(
                        "Pengaturan umum Al Quran",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF929292),
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              "Qori Murotal",
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.fontSize,
                              ),
                            ),
                            AutoSizeText(
                              "Pilih Qori untuk murotal Quran",
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Color(0xFF929292),
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.fontSize,
                              ),
                            ),
                          ],
                        ),
                        ButtonOutline(
                            onPressed: () {},
                            radius: 5,
                            title: "Mishari",
                            shadow: false,
                            width: Get.width / 3.5)
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Quran Media",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      AutoSizeText(
                        "Download data quran & murotal untuk pemkaian tanpa internet",
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF929292),
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Mushaf",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: Icon(
                          Icons.import_contacts_rounded,
                          color: Color(0xFFADADAD),
                        ),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mushaf Indonesia",
                        titleStyle: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.black),
                        iconRight: Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {},
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor: Colors.green.withOpacity(0.5),
                                  child: Icon(
                                    Icons.delete_rounded,
                                    color: Colors.black,
                                  )),
                            )
                          ],
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: Icon(
                          Icons.import_contacts_rounded,
                          color: Color(0xFFADADAD),
                        ),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mushaf Indonesia Tajwid",
                        titleStyle: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.black),
                        iconRight: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () async {
                                    showPopup(ctrl, gctrl, context);
                                    ctrl.downloadFile("halaman");
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor: Colors.green.withOpacity(0.5),
                                  child: Icon(
                                    Icons.download_rounded,
                                    color: Colors.black,
                                  )),
                            )
                          ],
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: Icon(
                          Icons.import_contacts_rounded,
                          color: Color(0xFFADADAD),
                        ),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mushaf Indonesia",
                        titleStyle: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.black),
                        iconRight: Row(
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    showPopup(ctrl, gctrl, context);
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  splashColor: Colors.green.withOpacity(0.5),
                                  child: Icon(
                                    Icons.download_rounded,
                                    color: Colors.black,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        "Murotal",
                        maxLines: 1,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall?.fontSize,
                        ),
                      ),
                      ListItemUiWidget(
                        showIcon: IconPosition.both,
                        iconLeft: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              "assets/img/murotal/mishari.jpg",
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            )),
                        id: 1,
                        typeDivider: TypeDivider.none,
                        title: "Mishari Alafasy",
                        subTitle: "Mishari bin Rashed Alafasy",
                        titleStyle: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void showPopup(
      AlquranPengaturanController ctrl, gctrl, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Obx(() => Dialog(
                elevation: 0,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7.0)),
                child: Container(
                    padding: const EdgeInsets.all(10),
                    width: Get.width,
                    height: 170,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mendownload",
                          style: bc.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        LinearProgressIndicator(
                          borderRadius: BorderRadius.all(Radius.zero),
                          color: Theme.of(bc).primaryColor,
                          backgroundColor: Color(0xFFD9D9D9),
                          value: ctrl.progresDownload.value,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              "${ctrl.totalTerDownload}/604",
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.fontSize,
                              ),
                            ),
                            AutoSizeText(
                              "${ctrl.persenDownload}%",
                              maxLines: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.fontSize,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Obx(() => ctrl.paused.value
                                ? Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          ctrl.resumeDownload();
                                          // Navigator.pop(context);
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        splashColor:
                                            Colors.green.withOpacity(0.5),
                                        child: Text("Lanjutkan",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.fontSize,
                                            ))),
                                  )
                                : Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                        onTap: () {
                                          ctrl.cancelDownload();
                                          // Navigator.pop(context);
                                        },
                                        borderRadius: BorderRadius.circular(20),
                                        splashColor:
                                            Colors.green.withOpacity(0.5),
                                        child: Text("Pause",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.fontSize,
                                            ))),
                                  ))

                            // ButtonElevated(
                            //   title: 'Lanjutkan Nanti',
                            //   width: Get.width / 3,
                            //   bgcolor: Colors.transparent,
                            //   height: 45,
                            //   color: Colors.black,
                            //   radius: 7,
                            //   shadow: false,
                            //   onPressed: () {
                            //     Navigator.pop(context);
                            //   },
                            // ),
                            )
                      ],
                    )),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AlquranPengaturanController());
    final gctrl = Get.find<MainController>();
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Pengaturan Alquran",
          context: context,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          color: Colors.white,
          titleAlign: Alignment.centerLeft,
          backgroundColor: Color(0xFF048C7C)),
      body: Obx(() => ctrl.isLoadingList.value
          ? const Center(child: CircularProgressIndicator())
          : layout(ctrl, gctrl, context)),
    );
  }
}
