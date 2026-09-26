import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// HaditsBabPage — level 2 dari Kitab → Bab → Hadits.
///
/// Kitab yang tidak punya bab tidak pernah sampai ke sini: landing memeriksa
/// `babCount` dan langsung push ke reader.
class HaditsBabPage extends ConsumerWidget {
  const HaditsBabPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namaTabel = GoRouterState.of(context).pathParameters['id'] ?? '';
    final books = ref.watch(haditsBooksProvider).valueOrNull ?? const <ImamData>[];
    final asyncBab = ref.watch(haditsBabProvider(namaTabel));

    ImamData? book;
    for (final b in books) {
      if (b.namaTabel == namaTabel) {
        book = b;
        break;
      }
    }
    final longNama = book?.longNama ?? 'Hadits ${namaTabel.toUpperCase()}';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: asyncBab.when(
            data: (babs) => _buildBody(context, namaTabel, longNama, babs,
                book?.hadits ?? 0, isLoading: false),
            loading: () => _buildBody(
              context,
              namaTabel,
              longNama,
              List.generate(
                6,
                (i) => HaditsBab(
                  id: i,
                  nama: 'Nama bab sedang dimuat',
                  urutan: i,
                  noAwal: 1,
                  noAkhir: 5,
                ),
              ),
              book?.hadits ?? 0,
              isLoading: true,
            ),
            error: (_, __) =>
                _buildBody(context, namaTabel, longNama, const [], 0, isLoading: false),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    String namaTabel,
    String longNama,
    List<HaditsBab> babs,
    int totalHadits, {
    required bool isLoading,
  }) {
    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context, longNama, babs.length)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => i == 0
                    ? _buildAllHaditsTile(context, namaTabel, longNama, totalHadits)
                    : _buildBabTile(context, babs[i - 1], namaTabel, longNama),
                childCount: babs.length + 1,
              ),
            ),
          ),
          if (!isLoading && babs.isEmpty)
            SliverToBoxAdapter(child: _buildEmpty(context, namaTabel)),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String longNama, int jumlahBab) {
    return Padding(
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
              ),
              child: const Icon(Icons.arrow_back_rounded,
                  size: 20, color: Color(0xFF137065)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  longNama,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF137065),
                  ),
                ),
                Text(
                  '$jumlahBab bab',
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllHaditsTile(
    BuildContext context,
    String namaTabel,
    String longNama,
    int totalHadits,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF048C7C),
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: const Icon(Icons.all_inclusive_rounded, color: Colors.white),
        title: Text(
          'Semua Hadits',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          totalHadits > 0 ? '$totalHadits hadits' : 'Seluruh kitab',
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.white70),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white),
        onTap: () => context.push(
          AppRoutes.haditsListRoute.replaceFirst(':id', namaTabel),
        ),
      ),
    );
  }

  Widget _buildBabTile(
    BuildContext context,
    HaditsBab bab,
    String namaTabel,
    String longNama,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2EBE8)),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        leading: Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF5F2),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Text(
            '${bab.urutan}',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF048C7C),
            ),
          ),
        ),
        title: Text(
          bab.nama,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        subtitle: Text(
          bab.noAwal == bab.noAkhir
              ? 'Hadits ${bab.noAwal}'
              : 'Hadits ${bab.noAwal}–${bab.noAkhir}',
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.black45),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black26),
        onTap: () => context.push(
          '${AppRoutes.haditsListRoute.replaceFirst(':id', namaTabel)}?bab=${bab.id}',
        ),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context, String namaTabel) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
      child: Column(
        children: [
          const Icon(Icons.menu_book_outlined, size: 44, color: Colors.black26),
          const SizedBox(height: 12),
          Text(
            'Kitab ini belum punya daftar bab',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.push(
              AppRoutes.haditsListRoute.replaceFirst(':id', namaTabel),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF048C7C),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Buka Semua Hadits',
              style: GoogleFonts.poppins(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
