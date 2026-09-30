import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/hudhud_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/artikel_data.dart';
import 'package:masjid_app/models/pagination_state.dart';
import 'package:masjid_app/pages/artikel/component/artikel_card.dart';
import 'package:masjid_app/providers/artikel_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Daftar artikel dengan infinite loading.
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
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(artikelInfiniteProvider.notifier).loadNextPage();
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
    final t = context.hudhud;

    return Scaffold(
      backgroundColor: t.sand,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Artikel / Informasi'),
            Text(
              state.isLoading && state.items.isEmpty
                  ? 'Memuat artikel...'
                  : '${state.items.length} artikel dimuat',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: t.terracotta,
          backgroundColor: t.surface,
          onRefresh: () => ref.read(artikelInfiniteProvider.notifier).refresh(),
          child: _buildContent(context, state),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PaginationState<ArtikelData> state) {
    if (state.isLoading && state.items.isEmpty) {
      return _buildScrollView(context, items: _dummyItems, isLoading: true, state: state);
    }
    if (state.errorMessage != null && state.items.isEmpty) return _buildError();
    return _buildScrollView(context, items: state.items, isLoading: false, state: state);
  }

  Widget _buildScrollView(
    BuildContext context, {
    required List<ArtikelData> items,
    required bool isLoading,
    required PaginationState<ArtikelData> state,
  }) {
    final t = context.hudhud;
    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          if (!isLoading && items.isEmpty)
            SliverFillRemaining(hasScrollBody: false, child: _buildEmpty())
          else
            SliverPadding(
              padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceMd, t.spaceLg, t.spaceMd),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final item = items[i];
                    return ArtikelCard(
                      judul: item.judul,
                      image: item.image,
                      dateLabel: formatArtikelDate(
                        item.publishDate.isNotEmpty ? item.publishDate : item.updatedAt,
                      ),
                      featured: i == 0,
                      onTap: () => _openDetail(context, item),
                    );
                  },
                  childCount: items.length,
                ),
              ),
            ),
          if (state.isLoadingMore)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(t.spaceLg),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2, color: t.terracotta),
                  ),
                ),
              ),
            )
          else if (!state.hasMore && items.isNotEmpty && !isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: t.spaceXl, top: t.spaceSm),
                child: Center(
                  child: Text(
                    'Semua artikel telah dimuat',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmpty() => HudhudStateView(
        icon: LucideIcons.newspaper,
        title: 'Belum ada artikel',
        message: 'Artikel dan informasi akan tampil di sini.',
      );

  Widget _buildError() => HudhudStateView(
        icon: LucideIcons.wifiOff,
        title: 'Gagal memuat artikel',
        message: 'Periksa koneksi lalu coba kembali.',
        actionLabel: 'Coba lagi',
        onAction: () => ref.read(artikelInfiniteProvider.notifier).loadFirstPage(),
      );
}
