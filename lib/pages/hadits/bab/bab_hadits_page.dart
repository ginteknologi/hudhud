import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BabHaditsPage extends ConsumerStatefulWidget {
  const BabHaditsPage({super.key});

  @override
  ConsumerState<BabHaditsPage> createState() => _BabHaditsPageState();
}

class _BabHaditsPageState extends ConsumerState<BabHaditsPage> {
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
    final args = extra is Map ? Map<String, dynamic>.from(extra) : <String, dynamic>{};
    final detail = args['detail'] is Map
        ? Map<String, dynamic>.from(args['detail'] as Map)
        : <String, dynamic>{};
    final content =
        args['content'] is ListKitabData ? args['content'] as ListKitabData : null;
    final namaTabel = (detail['namaTabel'] ?? '').toString();
    final idKitab =
        content?.idKitab ?? int.tryParse(routeState.pathParameters['id'] ?? '') ?? 0;
    final bookTitle = (detail['longNama'] ?? 'Kitab Hadits').toString();
    final kitabTitle = content?.kitabIndonesia ?? 'Daftar Bab';

    final listAsync = ref.watch(
      haditsBabProvider(HaditsBabParams(namaTabel: namaTabel, idKitab: idKitab)),
    );

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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                kitabTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF137065),
                ),
              ),
              Text(
                bookTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          centerTitle: false,
        ),
        body: listAsync.when(
          data: (list) => _buildContent(
            context,
            detail,
            content,
            kitabTitle,
            bookTitle,
            list,
            isLoading: false,
          ),
          loading: () => _buildContent(
            context,
            detail,
            content,
            kitabTitle,
            bookTitle,
            _dummyBabList,
            isLoading: true,
          ),
          error: (err, stack) => _buildError(context, namaTabel, idKitab),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Map<String, dynamic> detail,
    ListKitabData? content,
    String kitabTitle,
    String bookTitle,
    List<ListBabData> list, {
    required bool isLoading,
  }) {
    final filtered = list.where((item) {
      final name = item.babIndonesia.toLowerCase();
      final arab = item.babArab.toLowerCase();
      final q = _searchQuery.toLowerCase();
      return name.contains(q) || arab.contains(q);
    }).toList();

    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Header Card & Search
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Summary Banner
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                bookTitle,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFFF9D576),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          kitabTitle,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (content?.kitabArab != null &&
                            content!.kitabArab!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            content.kitabArab!,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.amiri(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          '${list.length} Bab pembahasan tersedia',
                          style: GoogleFonts.poppins(
                            color: Colors.white60,
                            fontSize: 11.5,
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
                        hintText: 'Cari bab pembahasan...',
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
                    'Daftar Bab',
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
                        'Bab tidak ditemukan',
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
                    final bab = filtered[index];
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
                            context.push(
                              '${AppRoutes.hadits}/${content?.idKitab}/${bab.idBab}',
                              extra: {
                                'content': content,
                                'detail': detail,
                                'bab': bab,
                                'babIndonesia': bab.babIndonesia,
                              },
                            );
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
                                      '${bab.idBab}',
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
                                        bab.babIndonesia,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      if (bab.babArab.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          bab.babArab,
                                          textDirection: TextDirection.rtl,
                                          style: GoogleFonts.amiri(
                                            fontSize: 14,
                                            color: const Color(0xFF137065),
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

  Widget _buildError(BuildContext context, String namaTabel, int idKitab) {
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
              'Gagal memuat daftar bab hadits',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.invalidate(
                haditsBabProvider(HaditsBabParams(namaTabel: namaTabel, idKitab: idKitab)),
              ),
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

  static final List<ListBabData> _dummyBabList = List.generate(
    8,
    (index) => ListBabData(
      idBab: index + 1,
      idKitab: 1,
      babIndonesia: 'Bab Pembahasan dan Penjelasan',
      babArab: 'باب البيان والتوضيح',
    ),
  );
}
