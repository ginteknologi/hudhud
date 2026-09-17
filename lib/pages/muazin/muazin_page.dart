import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:masjid_app/controllers/muazin_controller.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:url_launcher/url_launcher.dart';

class MuazinPage extends StatelessWidget {
  MuazinPage({super.key});

  final MuazinController ctrl = Get.find<MuazinController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Sahabat Muadzin"),
      ),
      body: PagingListener<int, KajianData>(
        controller: ctrl.pagingController,
        builder: (context, state, fetchNextPage) => RefreshIndicator(
          onRefresh: () async => ctrl.refresh(),
          child: PagedListView<int, KajianData>.separated(
            // v5: gunakan state + fetchNextPage dari PagingListener
            state: state,
            fetchNextPage: fetchNextPage,
            padding: EdgeInsets.zero,
            builderDelegate: PagedChildBuilderDelegate<KajianData>(
              itemBuilder: (context, item, index) {
                return ListTile(
                  onTap: () async {
                    final uri = Uri.parse(item.link);
                    final ok = await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                    if (!ok) {
                      debugPrint('Tidak dapat membuka link: ${item.link}');
                    }
                  },
                  dense: true,
                  title: AutoSizeText(
                    item.judul ?? '-',
                    maxLines: 1,
                    presetFontSizes: [Get.width / 30],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: AutoSizeText(item.subjudul ?? ''),
                  trailing: const Icon(Icons.chevron_right_rounded),
                  leading: Container(
                    width: 65,
                    height: 65,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: Colors.grey.shade100,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: item.image,
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      placeholder: (context, _) => const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, _, __) =>
                          const Icon(Icons.broken_image_outlined),
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
              padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
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
