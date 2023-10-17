import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/pages/sedekah/sedekah_service.dart';

class DetailSedekahController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var isLoadingList = true.obs;
  var list = {}.obs;
  final List<Tab> tabDetailSedekah = <Tab>[
    const Tab(
      text: 'Donatur',
    ),
    const Tab(text: 'Laporan'),
  ];

  late TabController tabController;
  late ScrollController scrollController;
  List listDonatur = [].obs;

  getData() async {
    final result = await SedekahService().getList(page: 0, limit: 10);
    list.value = result['data'];
    isLoadingList.value = false;
  }

  getKajianLive() async {
    return listDonatur = [
      {
        "id": 2,
        "title": 2400000,
        "subTitle": "Semoga diberikan keberkahan",
        "category": "Donatur",
        "date": "10/10/2023",
        "time": "10.10"
      },
      {
        "id": 3,
        "title": 2400000,
        "subTitle": "Semoga diberikan keberkahan",
        "category": "Donatur",
        "date": "10/10/2023",
        "time": "10.10"
      },
      {
        "id": 4,
        "title": 2400000,
        "subTitle": "Semoga diberikan keberkahan",
        "category": "Donatur",
        "date": "10/10/2023",
        "time": "10.10"
      },
      {
        "id": 5,
        "title": 2400000,
        "subTitle": "Semoga diberikan keberkahan",
        "category": "Donatur",
        "date": "10/10/2023",
        "time": "10.10"
      },
      {
        "id": 6,
        "title": 2400000,
        "subTitle": "Semoga diberikan keberkahan",
        "category": "Donatur",
        "date": "10/10/2023",
        "time": "10.10"
      },
      {
        "id": 7,
        "title": 189000,
        "subTitle": "Semoga diberikan keberkahan terus menerus yaaa",
        "category": "Donatur",
        "date": "09/09/2023",
        "time": "10.10"
      },
      {
        "id": 8,
        "title": 189000,
        "subTitle": "Semoga diberikan keberkahan",
        "category": "Donatur",
        "date": "09/09/2023",
        "time": "10.10"
      },
      {
        "id": 9,
        "title": 189000,
        "subTitle": "Semoga diberikan keberkahan",
        "category": "Donatur",
        "date": "09/09/2023",
        "time": "15.10"
      },
      {
        "id": 10,
        "title": 7800000,
        "subTitle": "Semoga diberikan keberkahan",
        "category": "Donatur",
        "date": "09/09/2023",
        "time": "15.10"
      },
      {
        "id": 11,
        "title": 7800000,
        "subTitle": "Semoga diberikan keberkahan",
        "category": "Donatur",
        "date": "10/10/2023",
        "time": "15.10"
      },
    ];
  }

  @override
  void onInit() {
    tabController = TabController(vsync: this, length: tabDetailSedekah.length);
    scrollController = ScrollController();
    getKajianLive();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
