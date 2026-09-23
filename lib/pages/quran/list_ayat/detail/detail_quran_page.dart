import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_card_ayat.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:masjid_app/pages/quran/list_ayat/detail/detail_quran_controller.dart';

class DetailAyatQuranPage extends StatelessWidget {
  const DetailAyatQuranPage({super.key});

  SafeArea layout(DetailAyatQuranController ctrl, MainController gctrl,
      BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: getList(ctrl, gctrl, context)
                  // Card(
                  //   elevation: 3,
                  //   color: Colors.white,
                  //   margin: const EdgeInsets.only(top: 20),
                  //   clipBehavior: Clip.antiAlias,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10),
                  //     //set border radius more than 50% of height and width to make circle
                  //   ),
                  //   child: Container(
                  //       width: Get.width,
                  //       // height: 210,
                  //       constraints: BoxConstraints.loose(Size.infinite),
                  //       child: Padding(
                  //         padding: EdgeInsets.all(15),
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.max,
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Container(
                  //               width: double.infinity,
                  //               height: 45,
                  //               padding: EdgeInsets.all(5),
                  //               decoration: BoxDecoration(
                  //                   color: Color(0xFF92E3A9),
                  //                   borderRadius: BorderRadius.all(
                  //                       Radius.circular(7))),
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Container(
                  //                     height: 42,
                  //                     width: 42,
                  //                     child: Stack(
                  //                       children: <Widget>[
                  //                         SvgPicture.asset(
                  //                           'assets/icons/list_star.svg',
                  //                           alignment: Alignment.center,
                  //                           width: 42,
                  //                           height: 42,
                  //                         ),
                  //                         Container(
                  //                           child: Column(
                  //                             children: <Widget>[
                  //                               Expanded(
                  //                                 child: Align(
                  //                                   alignment:
                  //                                       Alignment.center,
                  //                                   child: Text(
                  //                                     "999",
                  //                                     style: context
                  //                                         .textTheme
                  //                                         .bodySmall
                  //                                         ?.copyWith(
                  //                                       fontWeight:
                  //                                           FontWeight
                  //                                               .normal,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               )
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Material(
                  //                       color: Colors.transparent,
                  //                       child: Row(
                  //                         children: [
                  //                           Obx(() => InkWell(
                  //                                 onTap: () {
                  //                                   ctrl.isChecked.value =
                  //                                       !ctrl.isChecked
                  //                                           .value;
                  //                                   if (ctrl.isChecked
                  //                                       .value) {
                  //                                     ctrl.bookmark();
                  //                                   }
                  //                                 },
                  //                                 child: SvgPicture.asset(
                  //                                   ctrl.isChecked.value
                  //                                       ? 'assets/icons/active_bookmark.svg'
                  //                                       : 'assets/icons/bookmark.svg',
                  //                                   alignment:
                  //                                       Alignment.center,
                  //                                   width: 28,
                  //                                   height: 28,
                  //                                 ),
                  //                               )),
                  //                           const SizedBox(
                  //                             width: 10,
                  //                           ),
                  //                           InkWell(
                  //                             onTap: () {
                  //                               print("clicked play");
                  //                             },
                  //                             child: Icon(
                  //                               Icons.play_arrow_rounded,
                  //                               color: Theme.of(context)
                  //                                   .primaryColor,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ))
                  //                 ],
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: 20,
                  //             ),
                  //             // Container(
                  //             //   height: 500,
                  //             //   decoration:
                  //             //       BoxDecoration(color: Colors.red),
                  //             // )
                  //             Column(
                  //               mainAxisSize: MainAxisSize.max,
                  //               children: [
                  //                 Align(
                  //                   alignment: Alignment.centerRight,
                  //                   child: AutoSizeText(
                  //                     "بسم الله الرحمن الرحيم",
                  //                     textAlign: TextAlign.end,
                  //                     style: context.textTheme.titleMedium
                  //                         ?.copyWith(
                  //                             fontWeight:
                  //                                 FontWeight.bold),
                  //                     maxLines: 15,
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 20,
                  //                 ),
                  //                 Align(
                  //                     alignment: Alignment.centerLeft,
                  //                     child: AutoSizeText(
                  //                       "In the name of Allah, the Entirely Merciful, the Especially Merciful.",
                  //                       textAlign: TextAlign.start,
                  //                       style: context
                  //                           .textTheme.labelMedium
                  //                           ?.copyWith(
                  //                               fontWeight:
                  //                                   FontWeight.w300,
                  //                               fontStyle:
                  //                                   FontStyle.italic),
                  //                     )),
                  //                 SizedBox(
                  //                   height: 20,
                  //                 ),
                  //                 Align(
                  //                     alignment: Alignment.centerLeft,
                  //                     child: AutoSizeText(
                  //                       "Dengan menyebut nama Allah Yang Maha Penyayang lagi Maha Penyayang.",
                  //                       textAlign: TextAlign.start,
                  //                       style: context
                  //                           .textTheme.labelMedium
                  //                           ?.copyWith(
                  //                         fontWeight: FontWeight.w300,
                  //                       ),
                  //                     ))
                  //               ],
                  //             )
                  //           ],
                  //         ),
                  //       )), //SizedBox
                  // ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Card(
                  //   elevation: 3,
                  //   color: Colors.white,
                  //   margin: const EdgeInsets.only(top: 20),
                  //   clipBehavior: Clip.antiAlias,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10),
                  //     //set border radius more than 50% of height and width to make circle
                  //   ),
                  //   child: Container(
                  //       width: Get.width,
                  //       // height: 210,
                  //       constraints: BoxConstraints.loose(Size.infinite),
                  //       child: Padding(
                  //         padding: EdgeInsets.all(15),
                  //         child: Column(
                  //           mainAxisSize: MainAxisSize.max,
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Container(
                  //               width: double.infinity,
                  //               height: 45,
                  //               padding: EdgeInsets.all(5),
                  //               decoration: BoxDecoration(
                  //                   color: Color(0xFF92E3A9),
                  //                   borderRadius: BorderRadius.all(
                  //                       Radius.circular(7))),
                  //               child: Row(
                  //                 mainAxisAlignment:
                  //                     MainAxisAlignment.spaceBetween,
                  //                 children: [
                  //                   Container(
                  //                     height: 42,
                  //                     width: 42,
                  //                     child: Stack(
                  //                       children: <Widget>[
                  //                         SvgPicture.asset(
                  //                           'assets/icons/list_star.svg',
                  //                           alignment: Alignment.center,
                  //                           width: 42,
                  //                           height: 42,
                  //                         ),
                  //                         Container(
                  //                           child: Column(
                  //                             children: <Widget>[
                  //                               Expanded(
                  //                                 child: Align(
                  //                                   alignment:
                  //                                       Alignment.center,
                  //                                   child: Text(
                  //                                     "999",
                  //                                     style: context
                  //                                         .textTheme
                  //                                         .bodySmall
                  //                                         ?.copyWith(
                  //                                       fontWeight:
                  //                                           FontWeight
                  //                                               .normal,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               )
                  //                             ],
                  //                           ),
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                   Material(
                  //                       color: Colors.transparent,
                  //                       child: Row(
                  //                         children: [
                  //                           Obx(() => InkWell(
                  //                                 onTap: () {
                  //                                   ctrl.isChecked.value =
                  //                                       !ctrl.isChecked
                  //                                           .value;
                  //                                   if (ctrl.isChecked
                  //                                       .value) {
                  //                                     ctrl.bookmark();
                  //                                   }
                  //                                 },
                  //                                 child: SvgPicture.asset(
                  //                                   ctrl.isChecked.value
                  //                                       ? 'assets/icons/active_bookmark.svg'
                  //                                       : 'assets/icons/bookmark.svg',
                  //                                   alignment:
                  //                                       Alignment.center,
                  //                                   width: 28,
                  //                                   height: 28,
                  //                                 ),
                  //                               )),
                  //                           const SizedBox(
                  //                             width: 10,
                  //                           ),
                  //                           InkWell(
                  //                             onTap: () {
                  //                               print("clicked play");
                  //                             },
                  //                             child: Icon(
                  //                               Icons.play_arrow_rounded,
                  //                               color: Theme.of(context)
                  //                                   .primaryColor,
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       ))
                  //                 ],
                  //               ),
                  //             ),
                  //             SizedBox(
                  //               height: 20,
                  //             ),
                  //             // Container(
                  //             //   height: 500,
                  //             //   decoration:
                  //             //       BoxDecoration(color: Colors.red),
                  //             // )
                  //             Column(
                  //               mainAxisSize: MainAxisSize.max,
                  //               children: [
                  //                 Align(
                  //                   alignment: Alignment.centerRight,
                  //                   child: AutoSizeText(
                  //                     // "بسم الله الرحمن الرحيم",
                  //                     "يٰۤـاَيُّهَا الَّذِيۡنَ اٰمَنُوۡۤا اِذَا تَدَايَنۡتُمۡ بِدَيۡنٍ اِلٰٓى اَجَلٍ مُّسَمًّى فَاكۡتُبُوۡهُ ​ؕ وَلۡيَكۡتُب بَّيۡنَكُمۡ كَاتِبٌۢ بِالۡعَدۡلِ​ وَلَا يَاۡبَ كَاتِبٌ اَنۡ يَّكۡتُبَ كَمَا عَلَّمَهُ اللّٰهُ​ فَلۡيَكۡتُبۡ ​ۚ وَلۡيُمۡلِلِ الَّذِىۡ عَلَيۡهِ الۡحَـقُّ وَلۡيَتَّقِ اللّٰهَ رَبَّهٗ وَلَا يَبۡخَسۡ مِنۡهُ شَيۡـــًٔا ​ؕ فَاِنۡ كَانَ الَّذِىۡ عَلَيۡهِ الۡحَـقُّ سَفِيۡهًا اَوۡ ضَعِيۡفًا اَوۡ لَا يَسۡتَطِيۡعُ اَنۡ يُّمِلَّ هُوَ فَلۡيُمۡلِلۡ وَلِيُّهٗ بِالۡعَدۡلِ​ؕ وَاسۡتَشۡهِدُوۡا شَهِيۡدَيۡنِ مِنۡ رِّجَالِكُمۡ​ۚ فَاِنۡ لَّمۡ يَكُوۡنَا رَجُلَيۡنِ فَرَجُلٌ وَّامۡرَاَتٰنِ مِمَّنۡ تَرۡضَوۡنَ مِنَ الشُّهَدَآءِ اَنۡ تَضِلَّ اِحۡدٰٮهُمَا فَتُذَكِّرَ اِحۡدٰٮهُمَا الۡاُخۡرٰى​ؕ وَ لَا يَاۡبَ الشُّهَدَآءُ اِذَا مَا دُعُوۡا ​ؕ وَلَا تَسۡـــَٔمُوۡۤا اَنۡ تَكۡتُبُوۡهُ صَغِيۡرًا اَوۡ كَبِيۡرًا اِلٰٓى اَجَلِهٖ​ؕ ذٰ لِكُمۡ اَقۡسَطُ عِنۡدَ اللّٰهِ وَاَقۡوَمُ لِلشَّهَادَةِ وَاَدۡنٰۤى اَلَّا تَرۡتَابُوۡٓا اِلَّاۤ اَنۡ تَكُوۡنَ تِجَارَةً حَاضِرَةً تُدِيۡرُوۡنَهَا بَيۡنَكُمۡ فَلَيۡسَ عَلَيۡكُمۡ جُنَاحٌ اَلَّا تَكۡتُبُوۡهَا ​ؕ وَاَشۡهِدُوۡۤا اِذَا تَبَايَعۡتُمۡ وَلَا يُضَآرَّ كَاتِبٌ وَّلَا شَهِيۡدٌ  ؕ وَاِنۡ تَفۡعَلُوۡا فَاِنَّهٗ فُسُوۡقٌ ۢ بِكُمۡ ؕ وَ اتَّقُوا اللّٰهَ​ ؕ وَيُعَلِّمُكُمُ اللّٰهُ​ ؕ وَاللّٰهُ بِكُلِّ شَىۡءٍ عَلِيۡمٌ",
                  //                     textAlign: TextAlign.end,
                  //                     style: context.textTheme.titleMedium
                  //                         ?.copyWith(
                  //                             fontWeight:
                  //                                 FontWeight.bold),
                  //                     maxLines: 15,
                  //                   ),
                  //                 ),
                  //                 SizedBox(
                  //                   height: 20,
                  //                 ),
                  //                 Align(
                  //                     alignment: Alignment.centerLeft,
                  //                     child: AutoSizeText(
                  //                       "O you who believe! If you have debts and receivables for a specified period of time, you should write them down. And let a writer among you write it correctly. Let the writer not refuse to write it as Allah has taught him, so let him write it. And let the person who owes it dictate, and let him fear Allah, his Lord, and let him not deduct anything from it. If the debtor is someone who lacks intelligence or is weak (in his condition), or is unable to dictate himself, then let his guardian dictate it correctly. And testify with two male witnesses among you. If there are not two male (witnesses), then (may be) a man and two women among the people you like from the (existing) witnesses, so that if one forgets, the other will remind him. And don't let the witnesses refuse when called. And don't get bored of writing it down, for the deadline, whether (the debt) is small or large. That is more just in the sight of Allah, more able to strengthen testimony, and closer to you being beyond doubt, except if it is a cash trade that you carry out between yourselves, then there is no sin for you if you do not write it down. And take witnesses when you buy and sell, and do not make writing difficult and neither are witnesses. If you do (that), then indeed, it is an act of wickedness on your part. And fear Allah, Allah teaches you, and Allah is All-Knowing of everything.",
                  //                       textAlign: TextAlign.start,
                  //                       style: context
                  //                           .textTheme.labelMedium
                  //                           ?.copyWith(
                  //                               fontWeight:
                  //                                   FontWeight.w300,
                  //                               fontStyle:
                  //                                   FontStyle.italic),
                  //                     )),
                  //                 SizedBox(
                  //                   height: 20,
                  //                 ),
                  //                 Align(
                  //                     alignment: Alignment.centerLeft,
                  //                     child: AutoSizeText(
                  //                       "Wahai orang-orang yang beriman! Apabila kamu melakukan utang piutang untuk waktu yang ditentukan, hendaklah kamu menuliskannya. Dan hendaklah seorang penulis di antara kamu menuliskannya dengan benar. Janganlah penulis menolak untuk menuliskannya sebagaimana Allah telah mengajarkan kepadanya, maka hendaklah dia menuliskan. Dan hendaklah orang yang berutang itu mendiktekan, dan hendaklah dia bertakwa kepada Allah, Tuhannya, dan janganlah dia mengurangi sedikitpun daripadanya. Jika yang berutang itu orang yang kurang akalnya atau lemah (keadaannya), atau tidak mampu mendiktekan sendiri, maka hendaklah walinya mendiktekannya dengan benar. Dan persaksikanlah dengan dua orang saksi laki-laki diantara kamu. Jika tidak ada (saksi) dua orang laki-laki, maka (boleh) seorang laki-laki dan dua orang perempuan diantara orang-orang yang kamu sukai dari para saksi (yang ada), agar jika yang seorang lupa maka yang lain mengingatkannya. Dan janganlah saksi-saksi itu menolak apabila dipanggil. Dan janganlah kamu bosan menuliskannya, untuk batas waktunya baik (utang itu) kecil maupun besar. Yang demikian itu, lebih adil di sisi Allah, lebih dapat menguatkan kesaksian, dan lebih mendekatkan kamu kepada ketidakraguan, kecuali jika hal itu merupakan perdagangan tunai yang kamu jalankan diantara kamu, maka tidak ada dosa bagi kamu jika kamu tidak menuliskannya. Dan ambillah saksi apabila kamu berjual beli, dan janganlah menulis dipersulit dan begitu juga saksi. Jika kamu lakukan (yang demikian), maka sungguh, hal itu suatu kefasikan pada kamu. Dan bertakwalah kepada Allah, Allah memberikan pengajaran kepadamu, dan Allah Maha Mengetahui segala sesuatu.",
                  //                       textAlign: TextAlign.start,
                  //                       style: context
                  //                           .textTheme.labelMedium
                  //                           ?.copyWith(
                  //                         fontWeight: FontWeight.w300,
                  //                       ),
                  //                     ))
                  //               ],
                  //             )
                  //           ],
                  //         ),
                  //       )), //SizedBox
                  // ),
                  ),
            )));
  }

  Obx getList(DetailAyatQuranController ctrl, MainController gctrl, context) {
    return Obx(() => !ctrl.isLoadingDetail.value
        ? ListView.builder(
            physics: const ClampingScrollPhysics(),
            itemCount: ctrl.detail['numberOfVerses'],
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // Datum model = filteredEvents[index];
              var item = ctrl.listAyat[index];
              return FadeInUp(
                  child: Obx(
                () => ctrl.isLoadingDetail.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListCardAyatWidget(
                        id: item['number']['inSurah'],
                        ayat: item['text']['arab'],
                        descEN: item['text']['transliteration']['en'],
                        descIDN: item['translation']['id'],
                        nomor: item['number']['inSurah'].toString(),
                        bookmarked: ctrl.surahBookmarked.value
                            ? gctrl.perAyatLastRead['ayatNumber'] ==
                                    item['number']['inSurah']
                                ? true
                                : false
                            : false,
                        audioFile: item['audio']['primary'],
                        activeColor: ctrl.surahBookmarked.value
                            ? gctrl.perAyatLastRead['ayatNumber'] ==
                                    item['number']['inSurah']
                                ? Colors.green[50]
                                : Colors.white
                            : Colors.white,
                        onTap: () {
                          ctrl.ayatBookmarked.value =
                              gctrl.perAyatLastRead['ayatNumber'] ==
                                      item['number']['inSurah']
                                  ? true
                                  : false;
                          ctrl.bookmark(item, index);
                        },
                      ),
              ));
            },
          )
        : const Center(
            child: CircularProgressIndicator(),
          ));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DetailAyatQuranController());
    final gctrl = Get.find<MainController>();
    return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: ctrl.surahName.toString(), context: context, elevation: 0),
        body: Obx(() => ctrl.isLoadingDetail.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : layout(ctrl, gctrl, context)));
  }
}
