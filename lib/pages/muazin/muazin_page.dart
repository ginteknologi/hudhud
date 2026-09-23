import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:masjid_app/providers/kajian_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MuazinPage extends ConsumerWidget {
  const MuazinPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muadzinAsync = ref.watch(muadzinListProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Sahabat Muadzin"),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(muadzinListProvider.future),
        child: muadzinAsync.when(
          data: (items) => items.isEmpty
              ? ListView(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: Text('Belum ada data.')),
                    ),
                  ],
                )
              : ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: items.length,
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth / 30),
                    child: const Divider(color: Colors.black12),
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
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
                        item.judul.isEmpty ? '-' : item.judul,
                        maxLines: 1,
                        presetFontSizes: [screenWidth / 30],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: AutoSizeText(item.subjudul),
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
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => _ErrorRetry(
            message: 'Gagal memuat data.',
            onRetry: () => ref.invalidate(muadzinListProvider),
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
