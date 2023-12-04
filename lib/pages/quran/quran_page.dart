import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/input/InputText.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/pages/quran/halaman/halaman_quran_page.dart';
import 'package:masjid_app/pages/quran/listAyat/listAyat_quran_page.dart';
import 'package:masjid_app/pages/quran/quran_controller.dart';
import 'package:masjid_app/theme.dart';

class QuranPage extends StatelessWidget {
  final TypeViewQuran typeView;
  QuranPage({super.key, required this.typeView});

  layout(QuranController ctrl, BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, top: 21),
                          child: Column(children: [
                            Card(
                              elevation: 0,
                              color: const Color(0xFFF5F5F5),
                              margin: const EdgeInsets.only(top: 20),
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                //set border radius more than 50% of height and width to make circle
                              ),
                              child: Container(
                                  width: Get.width,
                                  height: 135,
                                  constraints:
                                      BoxConstraints.loose(Size.infinite),
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/img/card_quran.png"),
                                          fit: BoxFit.fill)),
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.menu_book_rounded,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              "11",
                                              style: context
                                                  .textTheme.titleSmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: AutoSizeText(
                                                "Al-Fatihah",
                                                textAlign: TextAlign.start,
                                                style: context
                                                    .textTheme.titleMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                maxLines: 2,
                                              ),
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: AutoSizeText(
                                                  "Ayat No : 1",
                                                  textAlign: TextAlign.start,
                                                  style: context
                                                      .textTheme.titleSmall
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.white),
                                                  maxLines: 2,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  )), //SizedBox
                            ),
                            const SizedBox(height: 20),
                            InputText(
                              suffixIcon: Icon(Icons.search),
                              labelPosition: 'none',
                              placeholder: 'Cari',
                              radius: 5,
                              isFill: true,
                              fillColor: Colors.white,
                              placeholderStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              inputPadding: const EdgeInsets.all(15),
                              controller: ctrl.txtController,
                              onSubmit: (newValue) {},
                              onEditingComplete: () {},
                              onChanged: (newValue) {},
                              validator: (newValue) {
                                if (newValue!.isEmpty) {
                                  return "Mohon untuk diisi.";
                                }
                                return null;
                              },
                            )
                          ])),
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 21, right: 21, top: 21),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Surat"),
                                ),
                                ListView.builder(
                                  physics: const ClampingScrollPhysics(),
                                  itemCount: ctrl.list.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    // Datum model = filteredEvents[index];
                                    return FadeInUp(
                                      child: ListItemUiWidget(
                                        id: ctrl.list[index]['number'],
                                        title: ctrl.list[index]['name']
                                            ['transliteration']['id'],
                                        titleStyle: context
                                            .textTheme.titleMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                        subTitle: ctrl.list[index]['name']
                                            ['translation']['id'],
                                        hasRightContent: true,
                                        showIcon: IconPosition.left,
                                        iconLeft: Container(
                                          height: 42,
                                          width: 42,
                                          child: Stack(
                                            children: <Widget>[
                                              SvgPicture.asset(
                                                'assets/icons/start_list.svg',
                                                alignment: Alignment.center,
                                                width: 42,
                                                height: 42,
                                              ),
                                              Container(
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text("999"),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Container(
                                        //   height: 42,
                                        //   width: 42,
                                        //   decoration: BoxDecoration(
                                        //       image: DecorationImage(
                                        //     image: Svg(
                                        //       'assets/example.svg',
                                        //     ),
                                        //   )),
                                        //   child: Align(
                                        //     alignment: Alignment.center,
                                        //     child: Text("999"),
                                        //   ),
                                        // ),
                                        rightContent: [
                                          Text(
                                              ctrl.list[index]['revelation']
                                                      ['id'] +
                                                  '\n' +
                                                  ctrl.list[index]['total'] +
                                                  ' Ayat',
                                              textAlign: TextAlign.end,
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ))
                                        ],
                                      ),
                                    );
                                  },
                                )
                              ],
                            )),
                      )
                    ]))));
  }

  Widget getCurrentWidget(TypeViewQuran type, QuranController ctrl) {
    print(TypeViewQuran.perayat);
    switch (type) {
      case TypeViewQuran.perayat:
        return const ListAyatQuranPage();
      case TypeViewQuran.perhalaman:
        return const HalamanQuranPage();
      default:
        return const ListAyatQuranPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(QuranController());
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: Obx(() => ctrl.isLoadingList.value ? const Center(child: CircularProgressIndicator()) :getCurrentWidget(typeView, ctrl)),
    );
  }
}

enum TypeViewQuran { perayat, perhalaman }
