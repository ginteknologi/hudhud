import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/models/kajian_model.dart';
import 'package:masjid_app/pages/kajian/component/kajian_card.dart';

class MuazinCard extends StatelessWidget {
  const MuazinCard({
    super.key,
    required this.item,
    this.onTap,
  });

  final KajianModel? item;
  final VoidCallback? onTap;

  bool _isVideo(String link) {
    final lower = link.toLowerCase();
    return lower.contains('youtube.com') ||
        lower.contains('youtu.be') ||
        lower.endsWith('.mp4') ||
        lower.contains('video');
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = _isVideo(item?.link ?? '');
    final title = cleanKajianText(item?.judul ?? 'Memuat konten muadzin...');
    final subtitle = cleanKajianText(
      item?.subjudul.isNotEmpty == true
          ? item!.subjudul
          : (item?.ustadz.isNotEmpty == true
              ? item!.ustadz
              : 'Inspirasi Sahabat Muadzin'),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EBE8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 86,
                    height: 86,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (item?.image.isNotEmpty == true)
                          CachedNetworkImage(
                            imageUrl: item!.image,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              color: const Color(0xFFE8F0EC),
                              child: const Center(
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFF048C7C),
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (_, __, ___) =>
                                const KajianFallbackImage(),
                          )
                        else
                          const KajianFallbackImage(),

                        // Gradient overlay jika video
                        if (isVideo)
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.45),
                                ],
                              ),
                            ),
                          ),

                        // Play icon overlay jika video
                        if (isVideo)
                          Center(
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  width: 1.2,
                                ),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5F3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isVideo ? 'Video' : 'Sahabat Muadzin',
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF048C7C),
                              ),
                            ),
                          ),
                          if (isVideo) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.play_circle_fill_rounded,
                              size: 13,
                              color: Color(0xFFE53935),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 5),

                      // Judul
                      Text(
                        title.isEmpty ? '-' : title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1F2937),
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 3),

                      // Subjudul / Ustadz
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),

                      const SizedBox(height: 6),

                      // Action link
                      Row(
                        children: [
                          Text(
                            isVideo ? 'Tonton Video' : 'Buka Konten',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF048C7C),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 13,
                            color: Color(0xFF048C7C),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
