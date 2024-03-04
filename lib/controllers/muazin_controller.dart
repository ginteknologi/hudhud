import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/service/muazin_service.dart';
import 'package:masjid_app/models/kajianData.dart';

class MuazinController extends GetxController {
  static const _pageSize = 20;
  final PagingController<int, KajianData> pagingController =
      PagingController(firstPageKey: 1);
  // DateTime sekarang = DateTime.now();
  // DateFormat formatter = DateFormat.yMMMM();

  // var isLoading = true.obs;
  // var listData = [].obs;
  // var listMuadzin = <KajianData>[].obs;

  // Future<void> getData() async {
  //   try {
  //     isLoading = true.obs;
  //     final result = await MuazinService.getMuadzin();
  //     listMuadzin.value = [];
  //     for (var element in result['data']) {
  //       listMuadzin.add(KajianData(
  //           id: element['id'],
  //           judul: element['judul'],
  //           subjudul: element['subjudul'],
  //           image: element['image'],
  //           link: element['link']));
  //     }
  //     isLoading.value = false;
  //   } catch (e) {
  //     print("error");
  //     print(e);
  //   }
  // }
  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems =
          await MuazinService.getMuadzin(pageKey: pageKey, pageSize: _pageSize);
      if (newItems.isNotEmpty) {
        if (newItems.length < _pageSize) {
          pagingController.appendLastPage(newItems);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController.appendPage(newItems, nextPageKey);
        }
      } else {
        pagingController.appendLastPage(newItems);
      }
    } catch (e) {
      print("error");
      print(e);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }
}
