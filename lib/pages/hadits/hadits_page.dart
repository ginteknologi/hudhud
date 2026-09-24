import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/pages/hadits/component/hadits_last_read_card.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HaditsPage extends ConsumerStatefulWidget {
  const HaditsPage({super.key});

  @override
  ConsumerState<HaditsPage> createState() => _HaditsPageState();
}

class _HaditsPageState extends ConsumerState<HaditsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(haditsBooksProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: booksAsync.when(
            data: (books) => _buildBody(context, books, isLoading: false),
            loading: () => _buildBody(
              context,
              _dummyBooks,
              isLoading: true,
            ),
            error: (err, stack) => _buildError(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    List<Map<String, dynamic>> books, {
    required bool isLoading,
  }) {
    final filtered = books.where((b) {
      final name = (b['longNama'] ?? '').toString().toLowerCase();
      final table = (b['namaTabel'] ?? '').toString().toLowerCase();
      final q = _searchQuery.toLowerCase();
      return name.contains(q) || table.contains(q);
    }).toList();

    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header & Search
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris Atas: Back button & Title
                  Row(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ensiklopedia Hadits',
                              style: GoogleFonts.poppins(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF137065),
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Kumpulan sabda & sunnah Rasulullah SAW',
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

                  const SizedBox(height: 16),

                  // Hero Card: Terakhir Dibaca
                  HaditsLastReadCard(
                    onRefresh: () => setState(() {}),
                  ),

                  const SizedBox(height: 16),

                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2EBE8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: GoogleFonts.poppins(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Cari kitab hadits (Bukhari, Muslim...)...',
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.black38,
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF048C7C),
                          size: 22,
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
                          vertical: 14,
                          horizontal: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Section Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Kutubut Tis\'ah & Arba\'in',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF137065),
                        ),
                      ),
                      Text(
                        '${filtered.length} Kitab',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF048C7C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Grid / Empty List
          if (filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/hadits.svg',
                        width: 50,
                        height: 50,
                        colorFilter: const ColorFilter.mode(
                          Colors.black26,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Kitab tidak ditemukan',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Coba cari dengan kata kunci lain',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.black38,
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
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.76,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final book = filtered[index];
                    return _buildBookCard(context, book);
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, Map<String, dynamic> book) {
    final longNama = (book['longNama'] ?? '').toString();
    final namaTabel = (book['namaTabel'] ?? '').toString();
    final totalHadits = book['hadits'] ?? 0;
    final assetPath = 'assets/icons/$longNama.png';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2EBE8)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF048C7C).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () async {
            await context.push(
              '${AppRoutes.hadits}/$namaTabel',
              extra: book,
            );
            if (mounted) setState(() {});
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover Image
                Expanded(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          assetPath,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              width: double.infinity,
                              color: const Color(0xFFEAF5F2),
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/icons/hadits.svg',
                                  width: 44,
                                  height: 44,
                                  colorFilter: const ColorFilter.mode(
                                    Color(0xFF048C7C),
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Judul Kitab
                Text(
                  longNama,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 6),

                // Chip Total Hadits
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF5F2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.menu_book_rounded,
                        size: 11,
                        color: Color(0xFF048C7C),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$totalHadits Hadits',
                        style: GoogleFonts.poppins(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF048C7C),
                        ),
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

  Widget _buildError(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.redAccent,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              'Gagal memuat daftar kitab hadits',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Periksa koneksi internet Anda dan coba lagi',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => ref.invalidate(haditsBooksProvider),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF048C7C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final List<Map<String, dynamic>> _dummyBooks = List.generate(
    6,
    (index) => {
      'longNama': 'Kitab Hadits Shahih Bukhari',
      'hadits': 7008,
      'namaTabel': 'bukhari',
    },
  );
}
