import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/pages/hadits/hadits_controller.dart';
import 'package:masjid_app/routes/hadits/index.dart';

class HaditsPage extends StatelessWidget {
  HaditsPage({super.key});

  layout(HaditsController ctrl, BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: Get.width,
                  height: 260,
                  constraints: BoxConstraints.loose(Size.infinite),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xFF137065),
                            Color(0xFF4CB4A7),
                          ])),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, bottom: 10, top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(); // Navigate back to the previous page
                                },
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                ))
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/img/quran_banner.png",
                              // height: 85,
                              width: 160,
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      'Kumpulan \nKitab-kitab Hadits',
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AutoSizeText(
                                    'Bacalah kalian Al-Quran. Karen ia akan datang pada hari kiamat kelak sebagai pemberi syafa’at bagi orang-orang yang rajin membacanya.',
                                    style: context.textTheme.labelMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                    softWrap: true,
                                    maxLines: 8,
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      children: [
                        DataGrid(),
                      ],
                    ))
              ],
            ),
          )),
    );
  }

  DataGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: (55 / 90),
        crossAxisCount: 3,
        mainAxisSpacing: 15,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return SizedBox(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () {
                          Get.toNamed(RoutesHadits.detail);
                        },
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.green.withOpacity(0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/icons/thumb_quran2x.png",
                              width: 103,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 5),
                            AutoSizeText(
                              'Hadits Arbain',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  height: 0.5,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.fontSize,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            AutoSizeText(
                              '42 Hadits',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  height: 0.5,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.fontSize,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w300),
                              maxLines: 1,
                            ),                            
                            // AutoSizeText(
                            //   '42 Hadits',  
                            //   textAlign: TextAlign.start,
                            //   style: context.textTheme.labelMedium?.copyWith(
                            //       fontWeight: FontWeight.w300,
                            //       fontStyle: FontStyle.italic),
                            // )
                            // Text(
                            //   '42 Hadits',
                            //   textAlign: TextAlign.left,
                            //   style: TextStyle(
                            //       height: 1,
                            //       fontSize: Theme.of(context)
                            //           .textTheme
                            //           .bodySmall
                            //           ?.fontSize,
                            //       color: Colors.black87,
                            //       fontWeight: FontWeight.w300),
                            //   maxLines: 1,
                            // ),
                          ],
                        )))));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HaditsController());
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: Obx(() => ctrl.isLoadingList.value
          ? const Center(child: CircularProgressIndicator())
          : layout(ctrl, context)),
    );
  }
}

enum TypeViewQuran { perayat, perhalaman }
