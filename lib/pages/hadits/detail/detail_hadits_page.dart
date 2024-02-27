import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/pages/hadits/detail/detail_hadits_controller.dart';
import 'package:masjid_app/routes/hadits/index.dart';

class DetailHaditsPage extends StatelessWidget {
  DetailHaditsPage({super.key});

  layout(DetailHaditsController ctrl, BuildContext context) {
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
                        left: 25, right: 25, bottom: 30, top: 40),
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
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              ctrl.arguments['detail']['longNama'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  height: 1,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.fontSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/thumb_quran2x.png",
                              width: 103,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ctrl.arguments['detail']['longNama'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      height: 1,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.fontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  ctrl.arguments['detail']['hadits'].toString() + ' Hadits',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      height: 1,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.fontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                  maxLines: 1,
                                ),
                              ],
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
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: ctrl.list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // Datum model = filteredEvents[index];
                      return FadeInUp(
                        child: ListItemUiWidget(
                          id: ctrl.list[index].ID_Kitab,
                          title: ctrl.list[index].Kitab_Indonesia,
                          onTap: () {
                            if (ctrl.arguments['detail']['namaTabel'] == 'arbain') {
                              Get.toNamed(RoutesHadits.content, arguments: {'content': ctrl.list[index], 'detail' : ctrl.arguments['detail'], 'bab': ctrl.list[index]});
                            } else{
                              Get.toNamed(RoutesHadits.bab, arguments: {'content': ctrl.list[index], 'detail': ctrl.arguments['detail']});
                            }
                          },
                          titleStyle: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          subTitle: null,
                          showIcon: IconPosition.left,
                          iconLeft: SizedBox(
                            height: 42,
                            width: 42,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: 42.0,
                                  height: 42.0,
                                  decoration: new BoxDecoration(
                                    color: Color.fromARGB(103, 19, 112, 101),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          ctrl.list[index].ID_Kitab.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.fontSize,
                                              color: Color(0xFF137065)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          widthContent: MediaQuery.of(context).size.width * 0.7,
                          // iconLeft: SvgPicture.asset(
                          //     ctrl.listTypesDoa[index]['icon'],
                          //     height: 35,
                          //     width: 35),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DetailHaditsController());
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
