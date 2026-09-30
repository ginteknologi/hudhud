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

class DoaPage extends ConsumerStatefulWidget {
  const DoaPage({super.key});

  @override
  ConsumerState<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends ConsumerState<DoaPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static final List<DoaCategoryModel> _dummyCategories = List.generate(
    8,
    (i) => DoaCategoryModel(
      id: i + 1,
      nama: 'Kategori Doa Pilihan',
      icon: '',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final doaAsync = ref.watch(doaCategoriesProvider);

    return WorshipReaderScaffold(
      title: "Kumpulan Do'a",
      subtitle: 'Doa harian, ibadah, & kemaslahatan',
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceMd),
            child: _buildSearchBar(t),
          ),
          Expanded(
            child: doaAsync.when(
              data: (categories) => _buildCategoryList(context, categories, isLoading: false),
              loading: () => _buildCategoryList(context, _dummyCategories, isLoading: true),
              error: (err, stack) => WorshipErrorView(
                title: "Gagal Memuat Kategori Do'a",
                message: 'Silakan periksa koneksi dan coba lagi.',
                onRetry: () => ref.invalidate(doaCategoriesProvider),
              ),
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
          hintText: 'Cari kategori doa...',
          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 13,
            color: t.muted,
          ),
          prefixIcon: Icon(LucideIcons.search, size: 18, color: t.muted),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(LucideIcons.x, size: 16, color: t.muted),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
        onChanged: (val) => setState(() => _searchQuery = val.trim()),
      ),
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    List<DoaCategoryModel> categories, {
    required bool isLoading,
  }) {
    final t = context.hudhud;
    final filtered = categories.where((cat) {
      if (_searchQuery.isEmpty) return true;
      return cat.nama.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    if (!isLoading && filtered.isEmpty) {
      return WorshipEmptyView(
        title: "Kategori Do'a Tidak Ditemukan",
        message: 'Tidak ada kategori yang cocok dengan "$_searchQuery".',
        icon: LucideIcons.searchX,
        actionLabel: 'Hapus Pencarian',
        onAction: () {
          _searchController.clear();
          setState(() => _searchQuery = '');
        },
      );
    }

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        padding: EdgeInsets.fromLTRB(t.spaceLg, 0, t.spaceLg, t.spaceXl),
        itemCount: filtered.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (ctx, index) {
          final cat = filtered[index];
          return _buildCategoryTile(context, cat, index + 1);
        },
      ),
    );
  }

  Widget _buildCategoryTile(BuildContext context, DoaCategoryModel cat, int index) {
    final t = context.hudhud;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusMd),
        onTap: () {
          context.push(
            AppRoutes.doaDetail.replaceFirst(':id', cat.id.toString()),
            extra: {'categoryName': cat.nama},
          );
        },
        child: Container(
          constraints: BoxConstraints(minHeight: t.controlHeight),
          padding: EdgeInsets.symmetric(horizontal: t.spaceMd, vertical: t.spaceMd),
          decoration: BoxDecoration(
            color: t.surface,
            borderRadius: BorderRadius.circular(t.radiusMd),
            border: Border.all(color: t.outline),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
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
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  cat.nama,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: t.charcoal,
                  ),
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 18, color: t.muted),
            ],
          ),
        ),
      ),
    );
  }
}
