import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/pages/hadits/content/content_hadits_controller.dart';
import 'package:share_plus/share_plus.dart';

class ContentHaditsPage extends StatelessWidget {
  ContentHaditsPage({super.key});

  layout(ContentHaditsController ctrl, BuildContext context) {
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
                            'Hadits No.1',
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
                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                ctrl.arguments['content']['Kitab_Indonesia'],
                                style: context.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Share.share("${ctrl.arguments['detail']['longNama']}\n\n${ctrl.arguments['content']['Kitab_Indonesia']}\n\n${ctrl.list[0]['Isi_Arab']}\n\n${ctrl.list[0]['Isi_Indonesia']} \n\n Dibagikan dari aplikasi\n\n Marbot App",
                              subject: ctrl.arguments['detail']['longNama']);
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
                        Container(
                          height: 300,
                          child: Text(
                            ctrl.list[0]['Isi_Arab'],
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AutoSizeText(
                          ctrl.list[0]['Isi_Indonesia'],
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                          softWrap: true,
                        ),
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
