import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/sedekah/detail/detailsedekah_service.dart';

class DetailSedekahController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isLoadingList = true.obs;
  var detail = {}.obs;
  final List<Tab> tabDetailSedekah = <Tab>[
    const Tab(
      text: 'Donatur',
    ),
    const Tab(text: 'Laporan'),
  ];

  late TabController tabController;
  late ScrollController scrollController;
  List listDonatur = [].obs;
  List listPenyaluran = [].obs;
  List listLaporan = [].obs;

  getData() async {
    final result = await DetailSedekahService().getList();
    detail.value = result['data'];
    listDonatur = result['data']['sedekahs'];
    listPenyaluran = result['data']['penyalur_campaigns'];
    print(listPenyaluran);
    isLoadingList.value = false;
  }

  getListLaporan() {
    return listLaporan = [
      {
        "tanggal": "25 Oktober 2023",
        "title": "Penyaluran Pembangunan Masjid Tempat Wudhu",
        "description":
            "Lorem ipsum dolor sit amet consectetur. Semper tempus condimentum ut aliquet. Mauris vitae posuere duis ac dis mauris massa nunc.Lorem ipsum dolor sit amet consectetur. Semper tempus condimentum ut aliquet. Mauris vitae posuere duis ac dis mauris massa nunc.Lorem ipsum dolor sit amet consectetur. Semper tempus condimentum ut aliquet. Mauris vitae posuere duis ac dis mauris massa nunc.",
        "dana": 7000000,
        "image": "assets/img/artikel_5.png",
      }
    ];
  }

  @override
  void onInit() {
    getData();
    tabController = TabController(vsync: this, length: tabDetailSedekah.length);
    scrollController = ScrollController();
    getListLaporan();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
