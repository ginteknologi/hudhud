import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/pages/hadits/content/content_hadits_controller.dart';
import 'package:share_plus/share_plus.dart';

class ContentHaditsPage extends StatelessWidget {
  const ContentHaditsPage({super.key});

  SafeArea layout(ContentHaditsController ctrl, BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Hadits No. ${ctrl.list.isNotEmpty ? ctrl.list[ctrl.currentIndex.value].noHdt : "-"}',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            softWrap: true,
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset("assets/icons/book_mark.svg",
                                  height: 20, width: 20),
                              SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.6, // Batasi lebar maksimal
                                child: Text(
                                  ctrl.arguments['content'].kitabIndonesia,
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: 2, // Agar tetap rapi
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.6, // Batasi lebar maksimal
                                child: Text(
                                  ctrl.arguments['babIndonesia'] ?? "",
                                  style: context.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: 2, // Agar tetap rapi
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Obx(() => ElevatedButton(
                                    onPressed: ctrl.currentIndex.value > 0
                                        ? () => ctrl.previousHadits()
                                        : null,
                                    child: Text("Previous"),
                                  )),
                              Obx(() => ElevatedButton(
                                    onPressed: ctrl.currentIndex.value <
                                            ctrl.list.length - 1
                                        ? () => ctrl.nextHadits()
                                        : null,
                                    child: Text("Next"),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          if (ctrl.list.isEmpty) return;
                          final hadits = ctrl.list[ctrl.currentIndex.value];
                          SharePlus.instance.share(ShareParams(
                              text:
                                  "${ctrl.arguments['detail']['longNama']}\n\n${ctrl.arguments['content'].kitabIndonesia}\n\n${hadits.isiArab}\n\n${hadits.isiIndonesia} \n\n Dibagikan dari aplikasi\n\n Marbot App",
                              subject: ctrl.arguments['detail']['longNama']));
                        },
                        child: Icon(
                          Icons.share,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 5,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                          child: Obx(() => Text(
                                ctrl.list.isNotEmpty
                                    ? ctrl.list[ctrl.currentIndex.value].isiArab
                                    : "Tidak ada data",
                                textAlign: TextAlign.center,
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Obx(() => AutoSizeText(
                              ctrl.list.isNotEmpty
                                  ? ctrl
                                      .list[ctrl.currentIndex.value].isiIndonesia
                                  : "Tidak ada data",
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: 10,
                                color: Colors.black,
                              ),
                              softWrap: true,
                            )),
                      ],
                    )),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ContentHaditsController());
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: ctrl.arguments['detail']['longNama'],
          context: context,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          color: Colors.white,
          titleAlign: Alignment.centerLeft,
          backgroundColor: Color(0xFF048C7C)),
      body: Obx(() => ctrl.isLoadingList.value
          ? const Center(child: CircularProgressIndicator())
          : layout(ctrl, context)),
    );
  }
}

enum TypeViewQuran { perayat, perhalaman }
