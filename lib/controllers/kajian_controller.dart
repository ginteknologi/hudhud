import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/service/kajian_service.dart';
import 'package:masjid_app/models/kajianData.dart';

class KajianController extends GetxController {
  static const _pageSize = 20;

  final PagingController<int, KajianData> pagingController =
      PagingController(firstPageKey: 1);

  DateTime sekarang = DateTime.now();
  DateFormat formatter = DateFormat.yMMMM();

  var isLoading = true.obs;
  var listData = [].obs;
  var listKajian = <KajianData>[].obs;

  Future<void> _fetchPage(int pageKey) async {
    try {
      var newItems;
      newItems = await KajianService.getListKajian(type:Get.arguments['type'], pageKey: pageKey, pageSize: _pageSize);
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

  @override
  void onClose() {
    super.onClose();
    pagingController.dispose();
  }
}
