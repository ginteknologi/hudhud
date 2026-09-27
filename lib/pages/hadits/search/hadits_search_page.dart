import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// HaditsSearchPage — pencarian teks hadits (server-side).
///
/// Query < 3 karakter tidak dikirim ke server: `LIKE '%a%'` men-scan seluruh
/// tabel dan hasilnya tidak berguna.
class HaditsSearchPage extends ConsumerStatefulWidget {
  const HaditsSearchPage({super.key});

  @override
  ConsumerState<HaditsSearchPage> createState() => _HaditsSearchPageState();
}

class _HaditsSearchPageState extends ConsumerState<HaditsSearchPage> {
  static const int _minQueryLength = 3;

  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  /// Query yang sudah lewat debounce; ini yang dikirim ke server.
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
    final books = ref.watch(haditsBooksProvider).valueOrNull ?? const <ImamData>[];
    final hasQuery = _submitted.length >= _minQueryLength;

    final asyncResult = hasQuery
        ? ref.watch(haditsSearchProvider(HaditsSearchParams(
            q: _submitted,
            limit: 20,
            namaTabel: _namaTabel,
          )))
        : null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              if (books.isNotEmpty) _buildKitabFilter(books),
              Expanded(child: _buildResults(asyncResult, books)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
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
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  size: 20, color: Color(0xFFD06A4C)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              onSubmitted: (v) {
                _debounce?.cancel();
                setState(() => _submitted = v.trim());
              },
              decoration: InputDecoration(
                hintText: 'Cari teks hadits…',
                hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.black38),
                prefixIcon: const Icon(Icons.search_rounded,
                    size: 20, color: Color(0xFFD06A4C)),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: () {
                          _debounce?.cancel();
                          _controller.clear();
                          setState(() => _submitted = '');
                        },
                      ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2EBE8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE2EBE8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFD06A4C)),
                ),
              ),
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKitabFilter(List<ImamData> books) {
    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _filterChip('Semua', _namaTabel == null, () {
            setState(() => _namaTabel = null);
          }),
          for (final b in books)
            _filterChip(b.longNama, _namaTabel == b.namaTabel, () {
              setState(() => _namaTabel = b.namaTabel);
            }),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool active, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFD06A4C) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: active ? const Color(0xFFD06A4C) : const Color(0xFFE2EBE8),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              color: active ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResults(AsyncValue<HaditsPageResult>? asyncResult, List<ImamData> books) {
    if (asyncResult == null) {
      return _buildHint(
        'Ketik minimal $_minQueryLength huruf untuk mencari',
        detail: 'Contoh: "niat", "sabar", "shalat"',
      );
    }

    return asyncResult.when(
      data: (result) {
        if (result.items.isEmpty) {
          return _buildHint('Tidak ada hadits cocok untuk "$_submitted"',
              detail: 'Coba kata lain atau lepas filter kitab');
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Row(
                children: [
                  Text(
                    '${result.pagination.total} hadits ditemukan',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                itemCount: result.items.length,
                itemBuilder: (_, i) => _buildResultCard(result.items[i], books),
              ),
            ),
          ],
        );
      },
      loading: () => ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        itemCount: 4,
        itemBuilder: (_, __) => Skeletonizer(
          enabled: true,
          child: _buildResultCard(
            const HaditsData(
              namaTabel: 'bukhari',
              noHdt: 1,
              isiArab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
              isiIndonesia: 'Hasil pencarian sedang dimuat di sini.',
            ),
            books,
          ),
        ),
      ),
      error: (_, __) => _buildHint('Gagal mencari', detail: 'Coba lagi sebentar'),
    );
  }

  Widget _buildResultCard(HaditsData hadits, List<ImamData> books) {
    String label = hadits.namaTabel.toUpperCase();
    for (final b in books) {
      if (b.namaTabel == hadits.namaTabel) {
        label = b.longNama;
        break;
      }
    }

    return GestureDetector(
      onTap: () => context.push(
        '${AppRoutes.haditsListRoute.replaceFirst(':id', hadits.namaTabel)}?mulai=${hadits.noHdt}',
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2EBE8)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF5F2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFD06A4C),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'No. ${hadits.noHdt}',
                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.black45),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              hadits.isiArab,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(fontSize: 18, height: 1.9),
            ),
            const SizedBox(height: 8),
            Text(
              hadits.isiIndonesia,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 12,
                height: 1.6,
                color: const Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHint(String message, {required String detail}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.search_rounded, size: 48, color: Colors.black26),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 11, color: Colors.black38),
            ),
          ],
        ),
      ),
    );
  }
}
