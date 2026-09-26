import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/artikel_data.dart';
import 'package:masjid_app/models/pagination_state.dart';
import 'package:masjid_app/pages/artikel/component/artikel_card.dart';
import 'package:masjid_app/providers/artikel_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Daftar lengkap artikel dengan Infinite Loading — dibuka dari tombol "Lihat Semua" di home.
class ArtikelPage extends ConsumerStatefulWidget {
  const ArtikelPage({super.key});

  @override
  ConsumerState<ArtikelPage> createState() => _ArtikelPageState();
}

class _ArtikelPageState extends ConsumerState<ArtikelPage> {
  late final ScrollController _scrollController;

  static final List<ArtikelData> _dummyItems = List.generate(
    4,
    (i) => ArtikelData(
      id: i + 1,
      judul: 'Judul artikel sedang dimuat...',
      image: '',
      updatedAt: '',
      publishDate: '',
    ),
  );

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      // Trigger load more saat user mencapai 200px sebelum dasar list
      if (currentScroll >= maxScroll - 200) {
        ref.read(artikelInfiniteProvider.notifier).loadNextPage();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _openDetail(BuildContext context, ArtikelData item) {
    context.push(AppRoutes.artikelDetail.replaceFirst(':id', '${item.id}'));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(artikelInfiniteProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: RefreshIndicator(
            color: artikelTitle,
            backgroundColor: Colors.white,
            onRefresh: () => ref.read(artikelInfiniteProvider.notifier).refresh(),
            child: _buildContent(context, state),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PaginationState<ArtikelData> state) {
    if (state.isLoading && state.items.isEmpty) {
      return _buildScrollView(
        context,
        items: _dummyItems,
        isLoading: true,
        state: state,
      );
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return _buildError();
    }

    return _buildScrollView(
      context,
      items: state.items,
      isLoading: false,
      state: state,
    );
  }

  Widget _buildScrollView(
    BuildContext context, {
    required List<ArtikelData> items,
    required bool isLoading,
    required PaginationState<ArtikelData> state,
  }) {
    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // Header Row
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
                        border: Border.all(color: artikelBorder),
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
                        color: artikelTitle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Artikel / Informasi',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: artikelTitle,
                          ),
                        ),
                        Text(
                          isLoading
                              ? 'Memuat artikel...'
                              : '${items.length} artikel dimuat',
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

          // Items List or Empty State
          if (!isLoading && items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmpty(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final item = items[i];
                    return ArtikelCard(
                      judul: item.judul,
                      image: item.image,
                      dateLabel: formatArtikelDate(
                        item.publishDate.isNotEmpty
                            ? item.publishDate
                            : item.updatedAt,
                      ),
                      featured: i == 0,
                      onTap: () => _openDetail(context, item),
                    );
                  },
                  childCount: items.length,
                ),
              ),
            ),

          // Bottom Loading Indicator (Infinite Scroll feedback)
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: artikelTitle,
                    ),
                  ),
                ),
              ),
            )
          else if (!state.hasMore && items.isNotEmpty && !isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 28, top: 12),
                child: Center(
                  child: Text(
                    'Semua artikel telah dimuat',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.article_outlined, size: 48, color: Colors.black26),
            const SizedBox(height: 12),
            Text(
              'Belum ada artikel',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
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
              'Gagal memuat artikel',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: artikelTitle,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => ref.read(artikelInfiniteProvider.notifier).loadFirstPage(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
