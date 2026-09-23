import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:masjid_app/models/kajian_data.dart';
import 'package:masjid_app/service/kajian_service.dart';

class QuoteController extends GetxController {
  static const int _pageSize = 20;

  late final PagingController<int, KajianData> pagingController;

  @override
  void onInit() {
    super.onInit();
    // v5: controller pegang PagingController dengan getNextPageKey + fetchPage
    pagingController = PagingController<int, KajianData>(
      // Ikuti contoh dokumentasi v5:
      // berhenti saat last page kosong; kalau tidak kosong, lanjut ke nextIntPageKey
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: (pageKey) async {
        // Kembalikan List<KajianData> dari API
        final items = await KajianService.getListKajian(
          type: 'quotes',
          pageKey: pageKey,
          pageSize: _pageSize,
        );
        return items;
      },
    );
  }

  @override
  void refresh() => pagingController.refresh();

  @override
  void onClose() {
    pagingController.dispose();
    super.onClose();
  }
}
