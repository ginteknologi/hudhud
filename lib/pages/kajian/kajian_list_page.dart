import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/kajian_model.dart';
import 'package:masjid_app/pages/kajian/component/kajian_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Daftar lengkap kajian — dipakai dua route:
///   /kajian/live   → [kajianLiveListProvider]
///   /kajian/tafsir → [kajianTafsirListProvider]
class KajianListPage extends ConsumerWidget {
  const KajianListPage({
    super.key,
    required this.title,
    required this.tag,
    required this.badgeColor,
    required this.provider,
  });

  final String title;
  final String tag;
  final Color badgeColor;
  final FutureProvider<List<KajianModel>> provider;

  static final List<KajianModel> _dummyItems = List.generate(
    4,
    (i) => KajianModel(
      id: i + 1,
      judul: 'Judul kajian sedang dimuat',
      ustadz: 'Ustadz',
      image: '',
    ),
  );

  void _openDetail(BuildContext context, KajianModel item) {
    context.push(
      AppRoutes.kajianDetail.replaceFirst(':id', '${item.id}'),
      extra: item,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(provider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: async.when(
            data: (items) => _buildBody(context, items, isLoading: false),
            loading: () => _buildBody(context, _dummyItems, isLoading: true),
            error: (_, __) => _buildError(ref),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<KajianModel> items, {
    required bool isLoading,
  }) {
    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2EBE8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: Color(0xFF137065),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF137065),
                          ),
                        ),
                        Text(
                          isLoading
                              ? 'Memuat kajian...'
                              : '${items.length} kajian tersedia',
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isLoading && items.isEmpty)
            SliverToBoxAdapter(child: _buildEmpty())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 140,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => KajianCard(
                    item: items[i],
                    tag: tag,
                    badgeColor: badgeColor,
                    width: null,
                    height: null,
                    onTap: () => _openDetail(context, items[i]),
                  ),
                  childCount: items.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        children: [
          Icon(Icons.video_library_outlined, size: 48, color: Colors.black26),
          SizedBox(height: 12),
          Text(
            'Belum ada kajian',
            style: TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildError(WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Colors.black38,
            ),
            const SizedBox(height: 12),
            Text(
              'Gagal memuat kajian',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF048C7C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => ref.invalidate(provider),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
