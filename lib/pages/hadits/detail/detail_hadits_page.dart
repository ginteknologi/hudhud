import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailHaditsPage extends ConsumerStatefulWidget {
  const DetailHaditsPage({super.key});

  @override
  ConsumerState<DetailHaditsPage> createState() => _DetailHaditsPageState();
}

class _DetailHaditsPageState extends ConsumerState<DetailHaditsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routeState = GoRouterState.of(context);
    final extra = routeState.extra;
    final detail =
        extra is Map ? Map<String, dynamic>.from(extra) : <String, dynamic>{};
    final namaTabel =
        (detail['namaTabel'] ?? routeState.pathParameters['id'] ?? '').toString();
    final longNama = (detail['longNama'] ?? 'Kitab Hadits').toString();
    final totalHadits = detail['hadits'] ?? 0;

    final listAsync = ref.watch(haditsDetailProvider(namaTabel));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF137065),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            longNama,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF137065),
            ),
          ),
          centerTitle: false,
        ),
        body: listAsync.when(
          data: (list) => _buildContent(
            context,
            detail,
            longNama,
            totalHadits,
            list,
            isLoading: false,
          ),
          loading: () => _buildContent(
            context,
            detail,
            longNama,
            totalHadits,
            _dummyList,
            isLoading: true,
          ),
          error: (err, stack) => _buildError(context, namaTabel),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Map<String, dynamic> detail,
    String longNama,
    dynamic totalHadits,
    List<ListKitabData> list, {
    required bool isLoading,
  }) {
    final isArbain = (detail['namaTabel'] ?? '') == 'arbain';
    final filtered = list.where((item) {
      final name = item.kitabIndonesia.toLowerCase();
      final arab = (item.kitabArab ?? '').toLowerCase();
      final q = _searchQuery.toLowerCase();
      return name.contains(q) || arab.contains(q);
    }).toList();

    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Card
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Book Info Banner
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0D6357), Color(0xFF1E8D7F)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF048C7C).withValues(alpha: 0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/icons/$longNama.png',
                            width: 65,
                            height: 85,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Container(
                              width: 65,
                              height: 85,
                              color: Colors.white12,
                              child: const Icon(
                                Icons.menu_book_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                longNama,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$totalHadits Hadits Terhimpun',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFF9D576),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                isArbain
                                    ? 'Daftar hadits pilihan Imam An-Nawawi'
                                    : 'Pilih bab pembahasan untuk membaca hadits',
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Search Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2EBE8)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: GoogleFonts.poppins(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: isArbain ? 'Cari hadits...' : 'Cari kitab / bab...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.black38,
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF048C7C),
                          size: 20,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    isArbain ? 'Daftar Hadits' : 'Daftar Kitab Pembahasan',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF137065),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List Items
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.search_off_rounded,
                        size: 44,
                        color: Colors.black26,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tidak ada hasil ditemukan',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final kitab = filtered[index];
                    final itemNumber = isArbain
                        ? (kitab.noHdt ?? (index + 1))
                        : (kitab.idKitab > 0 ? kitab.idKitab : index + 1);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2EBE8)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            if (isArbain) {
                              context.push(
                                '${AppRoutes.hadits}/${kitab.idKitab}/${kitab.idBab ?? kitab.idKitab}',
                                extra: {
                                  'content': kitab,
                                  'detail': detail,
                                  'bab': kitab,
                                  'babIndonesia': kitab.kitabIndonesia,
                                  'initialNoHdt': kitab.noHdt ?? (index + 1),
                                },
                              );
                            } else {
                              context.push(
                                '${AppRoutes.hadits}/bab/${kitab.idKitab}',
                                extra: {
                                  'content': kitab,
                                  'detail': detail,
                                },
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                // Number Badge
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF5F2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$itemNumber',
                                      style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF048C7C),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Title & Subtitle
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        kitab.kitabIndonesia,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      if (kitab.kitabArab != null &&
                                          kitab.kitabArab!.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          kitab.kitabArab!,
                                          textDirection: TextDirection.rtl,
                                          style: GoogleFonts.amiri(
                                            fontSize: 14,
                                            color: const Color(0xFF137065),
                                          ),
                                        ),
                                      ],
                                      if (kitab.noHdt != null && !isArbain) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          '${kitab.noHdt} Hadits',
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.black45,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),

                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 14,
                                  color: Color(0xFF048C7C),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String namaTabel) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 44,
            ),
            const SizedBox(height: 12),
            Text(
              'Gagal memuat daftar kitab hadits',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(haditsDetailProvider(namaTabel)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF048C7C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  static final List<ListKitabData> _dummyList = List.generate(
    8,
    (index) => ListKitabData(
      idKitab: index + 1,
      kitabIndonesia: 'Kitab Pembahasan Hadits',
      kitabArab: 'كتاب الإيمان',
      noHdt: 50,
    ),
  );
}
