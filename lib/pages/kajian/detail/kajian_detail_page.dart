import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/models/kajian_model.dart';
import 'package:masjid_app/pages/kajian/component/kajian_card.dart';
import 'package:url_launcher/url_launcher.dart';

/// Detail kajian — menerima [KajianModel] via GoRouter `extra`.
class KajianDetailPage extends ConsumerWidget {
  const KajianDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final extra = GoRouterState.of(context).extra;
    final item = extra is KajianModel ? extra : null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: item == null
              ? _buildMissing(context)
              : _buildBody(context, item),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String title) {
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                size: 20,
                color: Color(0xFF137065),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF137065),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, KajianModel item) {
    final isLive = item.type == 'live';
    final tag = isLive ? 'Kajian Live' : 'Tafsir Qur’an';
    final badgeColor =
        isLive ? const Color(0xFFE53935) : const Color(0xFF048C7C);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, isLive ? 'Kajian Live' : 'Kajian Tafsir'),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero thumbnail
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2EBE8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _openVideo(item.link),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (item.image.isNotEmpty)
                              CachedNetworkImage(
                                imageUrl: item.image,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) =>
                                    const KajianFallbackImage(),
                              )
                            else
                              const KajianFallbackImage(),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.25),
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: badgeColor,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.45),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        Colors.white.withValues(alpha: 0.7),
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 36,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Judul
                Text(
                  cleanKajianText(item.judul).isEmpty
                      ? 'Kajian Masjid'
                      : cleanKajianText(item.judul),
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                    color: const Color(0xFF137065),
                  ),
                ),

                const SizedBox(height: 10),

                // Ustadz
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.person_rounded,
                            size: 13,
                            color: Color(0xFF048C7C),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.ustadz.isEmpty
                                ? 'Masjid An-Ni’mah'
                                : cleanKajianText(item.ustadz),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF048C7C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                if (item.subjudul.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2EBE8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      cleanKajianText(item.subjudul),
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        height: 1.65,
                        color: const Color(0xFF333333),
                      ),
                    ),
                  ),
                ],

                if (item.link.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openVideo(item.link),
                      icon: const Icon(
                        Icons.play_circle_fill_rounded,
                        size: 20,
                      ),
                      label: const Text('Tonton di YouTube'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF048C7C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        textStyle: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissing(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context, 'Kajian'),
        const Expanded(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'Data kajian tidak ditemukan',
                style: TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openVideo(String link) async {
    if (link.isEmpty) return;
    final uri = Uri.tryParse(link);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
