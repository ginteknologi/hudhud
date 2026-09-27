import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/hadits_providers.dart';

/// Kartu "Lanjutkan Baca".
///
/// Push ke reader lewat query param — bukan `extra` ke route legacy (dulu
/// mendarat di halaman kosong karena provider-nya `return []`).
class HaditsLastReadCard extends ConsumerWidget {
  const HaditsLastReadCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(haditsBookmarkProvider);
    final bookmark = entries.isEmpty ? null : entries.first;
    final hasBookmark = bookmark != null && bookmark.isValid;

    final title = hasBookmark ? bookmark.longNama : "Hadits Arba'in An-Nawawiyah";
    final detail = hasBookmark
        ? 'Hadits No. ${bookmark.noHdt}'
            '${(bookmark.babIndonesia ?? '').isNotEmpty ? ' • ${bookmark.babIndonesia}' : ''}'
        : 'Mulai pelajari 42 hadits pokok Rasulullah SAW';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8C3B24), Color(0xFFD06A4C)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD06A4C).withValues(alpha: 0.25),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.bookmark_added_rounded,
                          color: Color(0xFFECA843),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          hasBookmark ? 'Terakhir Dibaca' : 'Rekomendasi Baca',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFECA843),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (hasBookmark)
                      InkWell(
                        onTap: () {
                          ref.read(haditsBookmarkProvider.notifier).clearAll();
                          Fluttertoast.showToast(
                            msg: 'Riwayat dibaca dibersihkan',
                            backgroundColor: const Color(0xFF4A5568),
                            textColor: Colors.white,
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.close_rounded,
                                  size: 12, color: Colors.white),
                              const SizedBox(width: 3),
                              Text(
                                'Hapus',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  // Landing ikut rebuild sendiri: markRead di reader mengubah
                  // haditsBookmarkProvider, dan landing meng-watch-nya.
                  onTap: () => context.push(
                    hasBookmark
                        ? '${AppRoutes.haditsListRoute.replaceFirst(':id', bookmark.namaTabel)}?mulai=${bookmark.noHdt}'
                        : AppRoutes.haditsListRoute.replaceFirst(':id', 'arbain'),
                  ),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          hasBookmark ? "Lanjutkan Baca" : "Mulai Baca",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF8C3B24),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Color(0xFF8C3B24),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/hadits.svg',
                width: 36,
                height: 36,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
