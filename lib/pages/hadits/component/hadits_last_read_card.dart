import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';

class HaditsLastReadCard extends ConsumerWidget {
  final VoidCallback? onRefresh;
  const HaditsLastReadCard({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmark = ref.watch(haditsBookmarkProvider);
    final hasBookmark = bookmark != null && bookmark.isValid;

    final title = hasBookmark ? bookmark.longNama : "Hadits Arba'in An-Nawawiyah";
    final detail = hasBookmark
        ? 'Hadits No. ${bookmark.noHdt}${bookmark.kitabIndonesia.isNotEmpty ? ' • ${bookmark.kitabIndonesia}' : ''}'
        : 'Mulai pelajari 42 hadits pokok Rasulullah SAW';

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D6357), Color(0xFF1E8D7F)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.25),
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
                          color: Color(0xFFF9D576),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          hasBookmark ? "Terakhir Dibaca" : "Rekomendasi Baca",
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFF9D576),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    if (hasBookmark)
                      InkWell(
                        onTap: () {
                          ref.read(haditsBookmarkProvider.notifier).clearBookmark();
                          Fluttertoast.showToast(
                            msg: 'Tanda Terakhir Dibaca dihapus',
                            backgroundColor: const Color(0xFF4A5568),
                            textColor: Colors.white,
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.close_rounded, size: 12, color: Colors.white),
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
                  onTap: () async {
                    if (hasBookmark) {
                      final bm = bookmark;
                      await context.push(
                        '${AppRoutes.hadits}/${bm.idKitab}/${bm.idBab ?? bm.idKitab}',
                        extra: {
                          'detail': {
                            'namaTabel': bm.namaTabel,
                            'longNama': bm.longNama,
                            'hadits': bm.totalHadits,
                          },
                          'content': ListKitabData(
                            idKitab: bm.idKitab,
                            kitabIndonesia: bm.kitabIndonesia,
                          ),
                          'bab': bm.idBab != null
                              ? ListBabData(
                                  idBab: bm.idBab!,
                                  idKitab: bm.idKitab,
                                  babIndonesia: bm.babIndonesia ?? '',
                                  babArab: '',
                                )
                              : null,
                          'babIndonesia': bm.babIndonesia ?? '',
                          'initialNoHdt': bm.noHdt,
                        },
                      );
                    } else {
                      // Buka Arbain default
                      await context.push(
                        '${AppRoutes.hadits}/1/1',
                        extra: {
                          'detail': {
                            'namaTabel': 'arbain',
                            'longNama': "Hadits Arba'in An-Nawawiyah",
                            'hadits': 42,
                          },
                          'content': ListKitabData(
                            idKitab: 1,
                            kitabIndonesia: "Arba'in An-Nawawiyah",
                          ),
                          'babIndonesia': "Arba'in An-Nawawiyah",
                          'initialNoHdt': 1,
                        },
                      );
                    }
                    onRefresh?.call();
                  },
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
                            color: const Color(0xFF0D6357),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Color(0xFF0D6357),
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
