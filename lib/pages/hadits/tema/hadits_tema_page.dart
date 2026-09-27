import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// HaditsTemaPage — dua mode dalam satu file:
///   `/hadits/tema`       → daftar kategori tema
///   `/hadits/tema/:id`   → isi satu tema
///
/// Daftar dan isi berbagi header, kartu, dan state; memisahkannya jadi dua
/// file hanya menyalin ~80 baris yang sama.
///
/// Catatan: teks tema berasal dari Lidwa (api.myquran.com), berbeda gaya
/// dengan 9 kitab + Arbain. Ditampilkan apa adanya.
class HaditsTemaPage extends ConsumerWidget {
  const HaditsTemaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idParam = GoRouterState.of(context).pathParameters['id'];
    final temaId = int.tryParse(idParam ?? '');
    return temaId == null ? _buildDaftar(context, ref) : _buildIsi(context, ref, temaId);
  }

  // ─── Mode daftar ───────────────────────────────────────────

  Widget _buildDaftar(BuildContext context, WidgetRef ref) {
    final asyncTema = ref.watch(haditsTemaProvider);

    return _shell(
      context,
      title: 'Tema Pilihan',
      subtitle: null,
      child: asyncTema.when(
        data: (temas) {
          if (temas.isEmpty) return _empty('Belum ada tema tersedia');
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            itemCount: temas.length,
            itemBuilder: (_, i) => _temaTile(context, temas[i]),
          );
        },
        loading: () => Skeletonizer(
          enabled: true,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            itemCount: 6,
            itemBuilder: (_, i) => _temaTile(
              context,
              const HaditsTema(id: 0, nama: 'Nama tema sedang dimuat', jumlah: 0),
            ),
          ),
        ),
        error: (_, __) => _empty('Gagal memuat tema'),
      ),
    );
  }

  Widget _temaTile(BuildContext context, HaditsTema tema) {
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
          child: const Icon(Icons.category_rounded,
              size: 17, color: Color(0xFFD06A4C)),
        ),
        title: Text(
          tema.nama,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        subtitle: Text(
          '${tema.jumlah} hadits',
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.black45),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black26),
        onTap: () => context.push('/hadits/tema/${tema.id}'),
      ),
    );
  }

  // ─── Mode isi ──────────────────────────────────────────────

  Widget _buildIsi(BuildContext context, WidgetRef ref, int temaId) {
    final temas = ref.watch(haditsTemaProvider).valueOrNull ?? const <HaditsTema>[];
    final asyncIsi = ref.watch(haditsTemaDetailProvider(temaId));

    var nama = 'Tema';
    for (final t in temas) {
      if (t.id == temaId) {
        nama = t.nama;
        break;
      }
    }

    return _shell(
      context,
      title: nama,
      subtitle: asyncIsi.valueOrNull == null
          ? null
          : '${asyncIsi.valueOrNull!.length} hadits',
      child: asyncIsi.when(
        data: (items) {
          if (items.isEmpty) return _empty('Tema ini tidak punya hadits');
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            itemCount: items.length,
            itemBuilder: (_, i) => _koleksiCard(items[i]),
          );
        },
        loading: () => Skeletonizer(
          enabled: true,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            itemCount: 4,
            itemBuilder: (_, i) => _koleksiCard(
              const HaditsKoleksi(
                id: 0,
                judul: 'Judul hadits sedang dimuat',
                arab: 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ',
                indo: 'Terjemahan hadits sedang dimuat di sini.',
              ),
            ),
          ),
        ),
        error: (_, __) => _empty('Gagal memuat isi tema'),
      ),
    );
  }

  Widget _koleksiCard(HaditsKoleksi item) {
    return Container(
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
          if (item.judul.isNotEmpty)
            Text(
              item.judul,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFD06A4C),
              ),
            ),
          const SizedBox(height: 10),
          Text(
            item.arab,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: GoogleFonts.amiri(fontSize: 20, height: 2.0),
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFEEEEEE), height: 1),
          const SizedBox(height: 10),
          Text(
            item.indo,
            style: GoogleFonts.poppins(
              fontSize: 12.5,
              height: 1.65,
              color: const Color(0xFF333333),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Kerangka bersama ──────────────────────────────────────

  Widget _shell(
    BuildContext context, {
    required String title,
    required String? subtitle,
    required Widget child,
  }) {
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
              Padding(
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
                            size: 20, color: Color(0xFFD06A4C)),
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
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFD06A4C),
                            ),
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle,
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
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }

  Widget _empty(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.category_outlined, size: 44, color: Colors.black26),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
