import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:masjid_app/configs/main_controller.dart';
import 'package:masjid_app/routes/quran/index.dart';

class AlquranController extends GetxController {
  final dataStore = GetStorage();
  final gctrl = Get.find<MainController>();
  var isLoadingList = true.obs;
  var list = {}.obs;
  late BuildContext context;

  var txtController = TextEditingController();
  var indonesiaSaatIni = 'Belum baca Al-quran'.obs;
  var tajwidSaatIni = 'Belum baca Al-quran'.obs;
  var madinahSaatIni = 'Belum baca Al-quran'.obs;
  var ayatSaatIni = 'Belum baca Al-quran'.obs;
  var listMenu = [].obs;
  getData() async {
    try {
    final result = await AlquranService().getRandom();
    list.value = result['data'];
      print('<<<<random>>>>');
    isLoadingList.value = false;
    } catch (e) {
      print(e);
    }
  }

  lastRead() async {
    isLoadingList.value = true;
    print(ayatSaatIni);
    ayatSaatIni.value = dataStore.read('perAyatLastRead')['id'] > 0
        ? dataStore.read('perAyatLastRead')['suratName'] +
            ' Ayat: ' +
            dataStore.read('perAyatLastRead')['ayatNumber'].toString()
        : 'Belum baca Al-quran';
    indonesiaSaatIni.value = dataStore.read('indonesiaLastRead')['id'] > 0
        ? dataStore.read('indonesiaLastRead')['surat'] +
            ' Hal: ' +
            dataStore.read('indonesiaLastRead')['hal'].toString()
        : 'Belum baca Al-quran';
    tajwidSaatIni.value = dataStore.read('tajwidLastRead')['id'] > 0
        ? dataStore.read('tajwidLastRead')['surat'] +
            ' Hal: ' +
            dataStore.read('tajwidLastRead')['hal'].toString()
        : 'Belum baca Al-quran';
    madinahSaatIni.value = dataStore.read('madinahLastRead')['id'] > 0
        ? dataStore.read('madinahLastRead')['surat'] +
            ' Hal: ' +
            dataStore.read('madinahLastRead')['hal'].toString()
        : 'Belum baca Al-quran';
    isLoadingList.value = false;
  }

  // showPopup(context, Widget? content, double? height) {
  //   print('tests');
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return Dialog(
  //           elevation: 0,
  //           backgroundColor: Colors.white,
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(7.0)),
  //           child: Container(
  //               child: content ??
  //                   Column(
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       Container(
  //                         padding: const EdgeInsets.all(10),
  //                         decoration: BoxDecoration(
  //                             color: Color(0xFFF5F5F5),
  //                             borderRadius: BorderRadius.only(
  //                                 topLeft: Radius.circular(7),
  //                                 topRight: Radius.circular(7))),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Icon(
  //                               Icons.arrow_back,
  //                               color: Colors.black,
  //                             ),
  //                             Text(
  //                               '${list['surat']} : ${list['nomor_ayat']} ',
  //                               // "Q.S Al-Muthaffifiin :  34",
  //                               style: bc.textTheme.titleMedium?.copyWith(
  //                                   letterSpacing: 1,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.black),
  //                             ),
  //                             SvgPicture.asset("assets/icons/share.svg",
  //                                 height: 15, width: 15)
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 20,
  //                       ),
  //                       Padding(
  //                           padding: EdgeInsets.symmetric(horizontal: 10),
  //                           child: AutoSizeText("${list['arab']}",
  //                               overflow: TextOverflow.ellipsis,
  //                               textAlign: TextAlign.start,
  //                               maxLines: 2,
  //                               style: TextStyle(
  //                                   fontSize: Theme.of(context)
  //                                       .textTheme
  //                                       .labelLarge
  //                                       ?.fontSize,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.w900))),
  //                       SizedBox(
  //                         height: 15,
  //                       ),
  //                       Padding(
  //                           padding: EdgeInsets.symmetric(horizontal: 10),
  //                           child: AutoSizeText("${list['indonesia']}",
  //                               textAlign: TextAlign.start,
  //                               style: TextStyle(
  //                                   fontSize: Theme.of(context)
  //                                       .textTheme
  //                                       .labelMedium
  //                                       ?.fontSize,
  //                                   fontStyle: FontStyle.italic,
  //                                   color: Colors.black,
  //                                   fontWeight: FontWeight.w300))),
  //                       SizedBox(
  //                         height: 15,
  //                       ),
  //                       ButtonElevated(
  //                         iconLeft: Icon(
  //                           Icons.refresh_outlined,
  //                           size: 20,
  //                           color: Colors.white,
  //                         ),
  //                         showIcon: 'left',
  //                         title: 'Acak Lagi',
  //                         width: 129,
  //                         bgcolor: Theme.of(bc).primaryColor,
  //                         height: 45,
  //                         color: Colors.white,
  //                         radius: 7,
  //                         shadow: false,
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                         },
  //                       ),
  //                       SizedBox(
  //                         height: 15,
  //                       ),
  //                     ],
  //                   )),
  //         );
  //       });
  // }

  @override
  void onInit() async {
    await getData();
    await lastRead();
    listMenu.value = [
      {
        'title': 'Per Ayat',
        'onTap': () {
          Get.toNamed(RoutesQuran.perayat)?.then((result) {
            if (result == 'refresh') {
              lastRead();
            }
          });
        },
        'image': 'assets/icons/perayat.png'
      },
      {
        'title': 'Indonesia',
        'onTap': () {
          Get.toNamed(RoutesQuran.perpage)?.then((result) {
            if (result == 'refresh') {
              lastRead();
            }
          });
        },
        'image': 'assets/icons/indonesia.png'
      },
      {
        'title': 'Madinah',
        'onTap': () {
          Get.toNamed(RoutesQuran.perpagemadinah)?.then((result) {
            if (result == 'refresh') {
              lastRead();
            }
          });
        },
        'image': 'assets/icons/madinah_2.png'
      },
      {
        'title': 'Tajwid Indonesia',
        'onTap': () {
          Get.toNamed(RoutesQuran.perpagetajwid)?.then((result) {
            if (result == 'refresh') {
              lastRead();
            }
          });
        },
        'image': 'assets/icons/tajwid.png'
      },
      {
        'title': 'Ayat Kejutan',
        'onTap': null,
        'image': 'assets/icons/kejutan.png'
      },
      {
        'title': 'Pengaturan',
        'onTap': () {
          Get.toNamed(RoutesQuran.pengaturan)?.then((result) {});
        },
        'image': 'assets/icons/pengaturan.png'
      }
    ];
    print("listMenu.length");
    update();
    super.onInit();
  }
}
