import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/service/kajian_service.dart';

class KajianController extends GetxController {
  static const int _pageSize = 20;

  late final PagingController<int, KajianData> pagingController;

  @override
  void onInit() {
    super.onInit();
    final type = Get.arguments?['type'];

    // v5 style: controller memegang PagingController + fetchPage
    pagingController = PagingController<int, KajianData>(
      // Stop ketika page terakhir kosong (sesuai contoh dokumentasi v5)
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) async {
        // Kembalikan list item; lib akan urus state & append.
        final items = await KajianService.getListKajian(
          type: type,
          pageKey: pageKey,
          pageSize: _pageSize,
        );
        return items;
      },
    );
  }

  void refresh() => pagingController.refresh();

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
