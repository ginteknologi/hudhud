import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/worship/worship_reader_scaffold.dart';
import 'package:masjid_app/components/worship/worship_state_views.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/doa_models.dart';
import 'package:masjid_app/providers/doa_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailDoaPage extends ConsumerStatefulWidget {
  const DetailDoaPage({super.key});

  @override
  ConsumerState<DetailDoaPage> createState() => _DetailDoaPageState();
}

class _DetailDoaPageState extends ConsumerState<DetailDoaPage> {
  final TextEditingController _searchController = TextEditingController();
  late final ScrollController _scrollController;
  String _query = '';

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
      if (currentScroll >= maxScroll - 200) {
        final categoryId = GoRouterState.of(context).pathParameters['id'] ?? '';
        final params = DoaListParams(categoryId: categoryId, query: _query);
        ref.read(doaInfiniteProvider(params).notifier).loadNextPage();
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  static final List<DoaItemModel> _dummyDoaList = List.generate(
    6,
    (i) => DoaItemModel(
      id: i + 1,
      judul: 'Contoh Judul Doa Lengkap',
      arab: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ',
      arti: 'Ya Allah, sesungguhnya aku memohon ampunan dan keselamatan.',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final routeState = GoRouterState.of(context);
    final categoryId = routeState.pathParameters['id'] ?? '';
    final extra = routeState.extra;
    final categoryName = extra is Map && extra.containsKey('categoryName')
        ? extra['categoryName'].toString()
        : "Kumpulan Do'a";

    final params = DoaListParams(categoryId: categoryId, query: _query);
    final state = ref.watch(doaInfiniteProvider(params));

    return WorshipReaderScaffold(
      title: categoryName,
      subtitle: 'Daftar doa pilihan',
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceMd),
            child: _buildSearchBar(t),
          ),
          Expanded(
            child: Builder(
              builder: (ctx) {
                if (state.isLoading && state.items.isEmpty) {
                  return _buildList(
                    context,
                    categoryId,
                    categoryName,
                    _dummyDoaList,
                    isLoading: true,
                    hasMore: false,
                    isLoadingMore: false,
                    params: params,
                  );
                }

                if (state.errorMessage != null && state.items.isEmpty) {
                  return WorshipErrorView(
                    title: "Gagal Memuat Daftar Do'a",
                    message: state.errorMessage!,
                    onRetry: () => ref
                        .read(doaInfiniteProvider(params).notifier)
                        .loadFirstPage(),
                  );
                }

                if (state.items.isEmpty) {
                  return WorshipEmptyView(
                    title: "Do'a Tidak Ditemukan",
                    message: _query.isNotEmpty
                        ? 'Tidak ada doa yang cocok dengan "$_query".'
                        : 'Belum ada doa pada kategori ini.',
                    icon: LucideIcons.fileQuestion,
                    actionLabel: _query.isNotEmpty ? 'Hapus Pencarian' : null,
                    onAction: _query.isNotEmpty
                        ? () {
                            _searchController.clear();
                            setState(() => _query = '');
                          }
                        : null,
                  );
                }

                return _buildList(
                  context,
                  categoryId,
                  categoryName,
                  state.items,
                  isLoading: false,
                  hasMore: state.hasMore,
                  isLoadingMore: state.isLoadingMore,
                  params: params,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(HudhudTheme t) {
    return Container(
      height: t.controlHeight,
      decoration: BoxDecoration(
        color: t.surface,
        borderRadius: BorderRadius.circular(t.radiusMd),
        border: Border.all(color: t.outline),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          color: t.charcoal,
        ),
        decoration: InputDecoration(
          hintText: 'Cari judul doa...',
          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 13,
            color: t.muted,
          ),
          prefixIcon: Icon(LucideIcons.search, size: 18, color: t.muted),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(LucideIcons.x, size: 16, color: t.muted),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _query = '');
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
        onSubmitted: (val) => setState(() => _query = val.trim()),
        textInputAction: TextInputAction.search,
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    String categoryId,
    String categoryName,
    List<DoaItemModel> items, {
    required bool isLoading,
    required bool hasMore,
    required bool isLoadingMore,
    required DoaListParams params,
  }) {
    final t = context.hudhud;

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(t.spaceLg, 0, t.spaceLg, t.spaceXl),
        itemCount: items.length + (hasMore || isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, index) {
          if (index == items.length) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(t.terracotta),
                  ),
                ),
              ),
            );
          }

          final item = items[index];
          return _buildItemTile(context, categoryId, categoryName, item, index + 1);
        },
      ),
    );
  }

  Widget _buildItemTile(
    BuildContext context,
    String categoryId,
    String categoryName,
    DoaItemModel item,
    int index,
  ) {
    final t = context.hudhud;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusMd),
        onTap: () {
          context.push(
            AppRoutes.doaContent
                .replaceFirst(':id', categoryId)
                .replaceFirst(':content', item.id.toString()),
            extra: {
              'categoryName': categoryName,
              'doaItem': item,
            },
          );
        },
        child: Container(
          constraints: BoxConstraints(minHeight: t.controlHeight),
          padding: EdgeInsets.all(t.spaceMd),
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.circular(t.radiusMd),
            border: Border.all(color: t.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: t.sand,
                      borderRadius: BorderRadius.circular(t.radiusSm),
                    ),
                    child: Center(
                      child: Text(
                        '$index',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: t.terracotta,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.judul,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: t.charcoal,
                        height: 1.3,
                      ),
                    ),
                  ),
                  Icon(LucideIcons.chevronRight, size: 18, color: t.muted),
                ],
              ),
              if (item.arti.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  item.arti,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: t.muted,
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
