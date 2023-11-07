import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/input/InputText.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/quran/listAyat/listAyat_quran_controller.dart';
// import 'package:mesjid_app/theme.dart';
import 'package:mesjid_app/routes/quran/index.dart';

class ListAyatQuranPage extends StatelessWidget {
  const ListAyatQuranPage({super.key});

  layout(ListAyatQuranController ctrl, BuildContext context) {
    return 
    SafeArea(
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
                                            Text(ctrl.lastRead['id'] > 0 ? '${ctrl.lastRead['id']}' : '-',
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
                                              child: AutoSizeText(ctrl.lastRead['ayatNumber'] > 0 ? '${ctrl.lastRead['suratName']}' : 'Belum baca',
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
                                                child: AutoSizeText('Ayat No : ' "${ctrl.lastRead['ayatNumber'] > 0 ? '${ctrl.lastRead['ayatNumber']}' : '-'}",
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
                              controller: ctrl.searchController,
                              onSubmit: (newValue) {},
                              onEditingComplete: () {},
                              onChanged: (newValue) {
                                print('asdasdsad');
                                ctrl.getDataSearch();
                              },
                              validator: (newValue) {
                                if (newValue!.isEmpty) {
                                  return "Mohon untuk diisi.";
                                }
                                return null;
                              },
                            )
                          ])),
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 21, right: 21, top: 21),
                            child: Column(
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text("Surat"),
                                ),
                                Obx(() => !ctrl.isLoadingList.value ?
                                  ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: ctrl.list.length,
                                    // itemCount: 114,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      // Datum model = filteredEvents[index];
                                      return FadeInUp(
                                        child: ListItemUiWidget(
                                          id: ctrl.list[index]['number'],
                                          title: ctrl.list[index]['name']['transliteration']['id'],
                                          onTap: () {
                                            // print(ctrl.list[index]);
                                            Get.toNamed('${RoutesQuran.detail.replaceAll(':id', ctrl.list[index]['number'].toString())}?nama_surah=${ctrl.list[index]['name']['transliteration']['id']}');                                       
                                            // ctrl.goToDetail(ctrl.list[index]['number']);
                                          },
                                          titleStyle: context.textTheme.titleMedium?.
                                            copyWith(fontWeight: FontWeight.bold,
                                              color: Theme.of(context).primaryColor),
                                          subTitle: ctrl.list[index]['name']['translation']['id'],
                                          hasRightContent: true,
                                          showIcon: IconPosition.left,
                                          iconLeft: SizedBox(
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
                                                Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(ctrl.list[index]['number'].toString()),
                                                      ),
                                                    )
                                                  ],
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
                                                ctrl.list[index]['revelation']['id'] +
                                                    '\n' +
                                                    ctrl.list[index]['numberOfVerses'].toString() +
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
                                  : const Text('Loading')
                                ) 
                              ],
                            )),
                      )
                    ]
                )
            )
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ListAyatQuranController());
    print(ctrl.list.length);

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: 
        layout(ctrl, context)
    );
  }
}
