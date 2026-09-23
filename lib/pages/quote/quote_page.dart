// (masih terpakai? boleh dibiarkan)
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:masjid_app/controllers/dkm_controller.dart';
import 'package:masjid_app/controllers/quote_controller.dart';
import 'package:masjid_app/models/kajian_data.dart';

class QuotePage extends StatelessWidget {
  QuotePage({super.key});

  final QuoteController ctrl = Get.put(QuoteController());
  final DkmController dctrl = Get.find<DkmController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Quote / Kutipan'),
      ),
      body: PagingListener<int, KajianData>(
        controller: ctrl.pagingController,
        builder: (context, state, fetchNextPage) => RefreshIndicator(
          onRefresh: () async => ctrl.refresh(),
          child: PagedListView<int, KajianData>.separated(
            state: state,
            fetchNextPage: fetchNextPage,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: false,
            padding: EdgeInsets.zero,
            builderDelegate: PagedChildBuilderDelegate<KajianData>(
              itemBuilder: (context, item, index) {
                return GestureDetector(
                  onTap: () => dctrl.share(item),
                  child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: Get.width / 30,
                      vertical: Get.width / 50,
                    ),
                    width: Get.width,
                    height: Get.width / 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                        image: CachedNetworkImageProvider(item.image),
                      ),
                    ),
                  ),
                );
              },
              firstPageProgressIndicatorBuilder: (context) =>
                  const Center(child: CircularProgressIndicator()),
              newPageProgressIndicatorBuilder: (context) =>
                  const Center(child: CircularProgressIndicator()),
              firstPageErrorIndicatorBuilder: (context) => _ErrorRetry(
                message: 'Gagal memuat data.',
                onRetry: () => ctrl.refresh(),
              ),
              newPageErrorIndicatorBuilder: (context) => _ErrorRetry(
                message: 'Gagal memuat halaman berikutnya.',
                onRetry: fetchNextPage,
              ),
              noItemsFoundIndicatorBuilder: (context) => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Belum ada data.'),
                ),
              ),
              noMoreItemsIndicatorBuilder: (context) => const SizedBox.shrink(),
            ),
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
              child: const Divider(color: Colors.black12),
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorRetry({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
