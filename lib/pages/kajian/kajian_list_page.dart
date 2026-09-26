import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/kajian_model.dart';
import 'package:masjid_app/models/pagination_state.dart';
import 'package:masjid_app/pages/kajian/component/kajian_card.dart';
import 'package:masjid_app/providers/kajian_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Daftar lengkap kajian dengan Infinite Loading — dipakai pada route:
///   /kajian/sahabat → type: 'doa_ramadhan'
///   /kajian/live    → type: 'live'
///   /kajian/tafsir  → type: 'tafsir'
class KajianListPage extends ConsumerStatefulWidget {
  const KajianListPage({
    super.key,
    required this.title,
    required this.tag,
    required this.badgeColor,
    required this.type,
  });

  final String title;
  final String tag;
  final Color badgeColor;
  final String type;

  @override
  ConsumerState<KajianListPage> createState() => _KajianListPageState();
}

class _KajianListPageState extends ConsumerState<KajianListPage> {
  late final ScrollController _scrollController;

  static final List<KajianModel> _dummyItems = List.generate(
    6,
    (i) => KajianModel(
      id: i + 1,
      judul: 'Judul kajian sedang dimuat...',
      ustadz: 'Nama Ustadz',
      image: '',
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
        ref.read(kajianInfiniteProvider(widget.type).notifier).loadNextPage();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _openDetail(BuildContext context, KajianModel item) {
    context.push(
      AppRoutes.kajianDetail.replaceFirst(':id', '${item.id}'),
      extra: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(kajianInfiniteProvider(widget.type));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: RefreshIndicator(
            color: const Color(0xFF048C7C),
            backgroundColor: Colors.white,
            onRefresh: () => ref.read(kajianInfiniteProvider(widget.type).notifier).refresh(),
            child: _buildContent(context, state),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PaginationState<KajianModel> state) {
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
    required List<KajianModel> items,
    required bool isLoading,
    required PaginationState<KajianModel> state,
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
                          widget.title,
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
                              : '${items.length} kajian dimuat',
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

          // Items Grid or Empty State
          if (!isLoading && items.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmpty(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 140,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, i) => KajianCard(
                    item: items[i],
                    tag: widget.tag,
                    badgeColor: widget.badgeColor,
                    width: null,
                    height: null,
                    onTap: () => _openDetail(context, items[i]),
                  ),
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
                      color: Color(0xFF048C7C),
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
                    'Semua kajian telah dimuat',
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
            const Icon(Icons.video_library_outlined, size: 48, color: Colors.black26),
            const SizedBox(height: 12),
            Text(
              'Belum ada kajian',
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
              onPressed: () => ref.read(kajianInfiniteProvider(widget.type).notifier).loadFirstPage(),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
