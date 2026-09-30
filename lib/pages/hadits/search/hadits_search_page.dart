import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:masjid_app/components/worship/worship_reader_scaffold.dart';
import 'package:masjid_app/components/worship/worship_state_views.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/core/theme/hudhud_theme.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HaditsSearchPage extends ConsumerStatefulWidget {
  const HaditsSearchPage({super.key});

  @override
  ConsumerState<HaditsSearchPage> createState() => _HaditsSearchPageState();
}

class _HaditsSearchPageState extends ConsumerState<HaditsSearchPage> {
  static const int _minQueryLength = 3;

  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  String _submitted = '';
  String? _namaTabel;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      final next = value.trim();
      if (next == _submitted) return;
      setState(() => _submitted = next);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.hudhud;
    final books = ref.watch(haditsBooksProvider).valueOrNull ?? const <ImamData>[];
    final hasQuery = _submitted.length >= _minQueryLength;

    final asyncResult = hasQuery
        ? ref.watch(haditsSearchProvider(HaditsSearchParams(
            q: _submitted,
            limit: 20,
            namaTabel: _namaTabel,
          )))
        : null;

    return WorshipReaderScaffold(
      title: 'Cari Hadits',
      subtitle: 'Pencarian sabda dan sunnah',
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(t.spaceLg, t.spaceSm, t.spaceLg, t.spaceMd),
            child: _buildSearchBar(t),
          ),
          if (books.isNotEmpty) ...[
            _buildKitabFilter(t, books),
            const SizedBox(height: 12),
          ],
          Expanded(child: _buildResults(asyncResult, books)),
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
        controller: _controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        onChanged: _onChanged,
        onSubmitted: (v) {
          _debounce?.cancel();
          setState(() => _submitted = v.trim());
        },
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          color: t.charcoal,
        ),
        decoration: InputDecoration(
          hintText: 'Cari kata kunci hadits (min. 3 huruf)...',
          hintStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 13,
            color: t.muted,
          ),
          prefixIcon: Icon(LucideIcons.search, size: 18, color: t.muted),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                  icon: Icon(LucideIcons.x, size: 16, color: t.muted),
                  onPressed: () {
                    _debounce?.cancel();
                    _controller.clear();
                    setState(() => _submitted = '');
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildKitabFilter(HudhudTheme t, List<ImamData> books) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: t.spaceLg),
        children: [
          _filterChip(t, 'Semua Kitab', _namaTabel == null, () {
            setState(() => _namaTabel = null);
          }),
          for (final b in books)
            _filterChip(t, b.longNama, _namaTabel == b.namaTabel, () {
              setState(() => _namaTabel = b.namaTabel);
            }),
        ],
      ),
    );
  }

  Widget _filterChip(HudhudTheme t, String label, bool active, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: active,
        label: Text(label),
        labelStyle: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 12,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          color: active ? Colors.white : t.charcoal,
        ),
        backgroundColor: t.surface,
        selectedColor: t.terracotta,
        checkmarkColor: Colors.white,
        showCheckmark: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(t.radiusMd),
          side: BorderSide(color: active ? t.terracotta : t.outline),
        ),
        onSelected: (_) => onTap(),
      ),
    );
  }

  Widget _buildResults(AsyncValue<HaditsPageResult>? asyncResult, List<ImamData> books) {
    final t = context.hudhud;

    if (asyncResult == null) {
      return const WorshipEmptyView(
        title: 'Mulai Pencarian Hadits',
        message: 'Ketik minimal 3 huruf untuk mencari hadits (contoh: "niat", "sabar", "ilmu").',
        icon: LucideIcons.search,
      );
    }

    return asyncResult.when(
      data: (result) {
        if (result.items.isEmpty) {
          return WorshipEmptyView(
            title: 'Hadits Tidak Ditemukan',
            message: 'Tidak ada hadits yang cocok dengan "$_submitted". Coba kata kunci lain atau pilih Semua Kitab.',
            icon: LucideIcons.searchX,
          );
        }
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(t.spaceLg, 0, t.spaceLg, t.spaceSm),
              child: Row(
                children: [
                  Text(
                    'Ditemukan ${result.pagination.total} hadits',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: t.muted,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(t.spaceLg, 0, t.spaceLg, t.spaceXl),
                itemCount: result.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) => _buildResultCard(result.items[i], books),
              ),
            ),
          ],
        );
      },
      loading: () => Skeletonizer(
        enabled: true,
        child: ListView.separated(
          padding: EdgeInsets.fromLTRB(t.spaceLg, 0, t.spaceLg, t.spaceXl),
          itemCount: 4,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, __) => _buildResultCard(
            const HaditsData(
              namaTabel: 'bukhari',
              noHdt: 1,
              isiArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
              isiIndonesia: 'Hasil pencarian hadits sedang dimuat di sini.',
            ),
            books,
          ),
        ),
      ),
      error: (_, __) => WorshipErrorView(
        title: 'Gagal Mencari Hadits',
        message: 'Silakan periksa koneksi dan coba beberapa saat lagi.',
        onRetry: () => ref.invalidate(haditsSearchProvider),
      ),
    );
  }

  Widget _buildResultCard(HaditsData hadits, List<ImamData> books) {
    final t = context.hudhud;
    String label = hadits.namaTabel.toUpperCase();
    for (final b in books) {
      if (b.namaTabel == hadits.namaTabel) {
        label = b.longNama;
        break;
      }
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(t.radiusMd),
        onTap: () => context.push(
          '${AppRoutes.haditsListRoute.replaceFirst(':id', hadits.namaTabel)}?mulai=${hadits.noHdt}',
        ),
        child: Container(
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
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: t.sand,
                      borderRadius: BorderRadius.circular(t.radiusSm),
                      border: Border.all(color: t.outline),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: t.terracotta,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'No. ${hadits.noHdt}',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: t.muted,
                    ),
                  ),
                  const Spacer(),
                  Icon(LucideIcons.chevronRight, size: 18, color: t.muted),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  hadits.isiArab,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.amiri(fontSize: 18, height: 1.8, color: t.charcoal),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hadits.isiIndonesia,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  height: 1.5,
                  color: t.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
