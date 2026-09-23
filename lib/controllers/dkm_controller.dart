import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:masjid_app/configs/file_setup.dart';
import 'package:masjid_app/models/kajian_data.dart';
import 'package:masjid_app/models/sosmed_data.dart';
import 'package:masjid_app/pages/dkm/dkm_service.dart';
import 'package:masjid_app/service/dashboard_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:share_plus/share_plus.dart';

class DkmController extends GetxController {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);
  late PackageInfo packageInfo;
  var isLoadingList = true.obs;
  var isLoadingSlider = true.obs;
  RxList<SosmedData> listKontak = <SosmedData>[].obs;
  RxList<KajianData> listQuotes = <KajianData>[
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
    KajianData(
        id: 1,
        judul: 'judul',
        subjudul: 'subjudul',
        image: 'https://dummyimage.com/600x400/000/fff',
        link: 'link'),
  ].obs;
  var version = "0.0.0".obs;
  Future<void> getData() async {
    try {
      final data = await DkmService().getList();
      listKontak.value = data;
      isLoadingList.value = false;
    } catch (e) {
      isLoadingList.value = false;
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> share(KajianData item) async {
    Get.defaultDialog(
        title: item.judul!,
        titleStyle: TextStyle(fontSize: Get.width / 25),
        textConfirm: 'Share Sekarang',
        confirmTextColor: Colors.black,
        buttonColor: Color(0xFF92E3A9),
        backgroundColor: Colors.white,
        radius: Get.width / 50,
        onConfirm: () async {
          final result = await downloadAndSaveFile(
            url: item.image,
            pathsave: '/quote',
          );
          final resultShare = await SharePlus.instance.share(
            ShareParams(
              files: [XFile(result)],
              text: '#Dikirim dari Marbot app https://s.id/downloadmarbotapp',
            ),
          );

          if (resultShare.status == ShareResultStatus.success) {
            Fluttertoast.showToast(msg: "Berhasil dishare");
          }
          Get.back();
        },
        content: Container(
          width: Get.width / 1.4,
          height: Get.height / 4.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Get.width / 50),
              image: DecorationImage(
                image: CachedNetworkImageProvider(item.image),
                fit: BoxFit.fitWidth,
              )),
        ));
  }

  Future<void> getSlider() async {
    try {
      final result = await DashboardService().getSliderKajian('quotes');
      listQuotes.value = [];
      for (var element in result['data']) {
        listQuotes.add(KajianData(
            id: element['id'],
            judul: element['judul'],
            subjudul: element['subjudul'],
            image: element['image'],
            link: element['link']));
      }
      isLoadingSlider.value = false;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> getVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }

  @override
  void onInit() {
    getData();
    getSlider();
    getVersion();
    super.onInit();
  }
}
