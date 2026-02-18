import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:masjid_app/service/muazin_service.dart';

class MuazinController extends GetxController {
  static const int _pageSize = 20;

  late final PagingController<int, KajianData> pagingController;

  @override
  void onInit() {
    super.onInit();

    pagingController = PagingController<int, KajianData>(
      // Pola resmi v5: berhenti saat halaman kosong berikutnya.
      getNextPageKey: (state) =>
          state.lastPageIsEmpty ? null : state.nextIntPageKey,
      // Cukup return list item; lib yang urus state append/last page.
      fetchPage: (pageKey) async {
        final items = await MuazinService.getMuadzin(
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
