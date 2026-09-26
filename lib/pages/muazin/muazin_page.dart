import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/kajian_model.dart';
import 'package:masjid_app/pages/kajian/component/kajian_card.dart';
import 'package:masjid_app/pages/muazin/component/muazin_card.dart';
import 'package:masjid_app/pages/muazin/component/muazin_doa_modal.dart';
import 'package:masjid_app/pages/muazin/component/muazin_hero_card.dart';
import 'package:masjid_app/providers/kajian_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class MuazinPage extends ConsumerStatefulWidget {
  const MuazinPage({super.key});

  @override
  ConsumerState<MuazinPage> createState() => _MuazinPageState();
}

class _MuazinPageState extends ConsumerState<MuazinPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static final List<KajianModel> _dummyItems = List.generate(
    4,
    (i) => KajianModel(
      id: i + 1,
      judul: 'Panduan dan Keutamaan Mengumandangkan Adzan',
      subjudul: 'Inspirasi dan tuntunan adzan sesuai sunnah',
      ustadz: 'Masjid An-Ni’mah',
      image: '',
      link: 'https://youtube.com',
    ),
  );

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleItemTap(KajianModel item) async {
    final link = item.link.trim();
    if (link.isNotEmpty) {
      final uri = Uri.tryParse(link);
      if (uri != null) {
        try {
          final ok = await launchUrl(
            uri,
            mode: LaunchMode.externalApplication,
          );
          if (ok) return;
        } catch (_) {}
      }
    }

    // Jika tidak bisa dibuka lewat browser atau link kosong, buka halaman detail
    if (mounted) {
      if (item.id > 0) {
        context.push(
          AppRoutes.kajianDetail.replaceFirst(':id', '${item.id}'),
          extra: item,
        );
      } else {
        Fluttertoast.showToast(msg: 'Tautan konten belum tersedia');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final muadzinAsync = ref.watch(muadzinListProvider);
    final canPop = Navigator.of(context).canPop();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAF9),
        body: SafeArea(
          child: RefreshIndicator(
            color: const Color(0xFF048C7C),
            backgroundColor: Colors.white,
            onRefresh: () => ref.refresh(muadzinListProvider.future),
            child: muadzinAsync.when(
              data: (items) => _buildContent(
                context,
                items,
                isLoading: false,
                canPop: canPop,
              ),
              loading: () => _buildContent(
                context,
                _dummyItems,
                isLoading: true,
                canPop: canPop,
              ),
              error: (err, stack) => _buildError(context, canPop),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<KajianModel> items, {
    required bool isLoading,
    required bool canPop,
  }) {
    final filtered = items.where((item) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final title = cleanKajianText(item.judul).toLowerCase();
      final sub = cleanKajianText(item.subjudul).toLowerCase();
      final ustadz = cleanKajianText(item.ustadz).toLowerCase();
      return title.contains(q) || sub.contains(q) || ustadz.contains(q);
    }).toList();

    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // Header, Hero Card & Search Bar
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris Atas: Back button (opsional), Title & Action Icon
                  Row(
                    children: [
                      if (canPop) ...[
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFE2EBE8),
                              ),
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
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sahabat Muadzin',
                              style: GoogleFonts.poppins(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF137065),
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Inspirasi, doa & panduan seputar muadzin',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => MuazinDoaModal.show(context),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5F3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFBCE3DC),
                            ),
                          ),
                          child: const Icon(
                            Icons.menu_book_outlined,
                            size: 20,
                            color: Color(0xFF048C7C),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Hero Banner Card: Keutamaan Muadzin
                  const MuazinHeroCard(),

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
                        hintText: 'Cari konten muadzin...',
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
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  size: 18,
                                ),
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

                  const SizedBox(height: 18),

                  // Section Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Daftar Konten',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF137065),
                        ),
                      ),
                      Text(
                        isLoading
                            ? 'Memuat...'
                            : '${filtered.length} Konten',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF048C7C),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Content List / Empty State
          if (!isLoading && filtered.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _buildEmptyState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = filtered[index];
                    return MuazinCard(
                      item: item,
                      onTap: isLoading ? null : () => _handleItemTap(item),
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

  Widget _buildEmptyState() {
    final isSearching = _searchQuery.isNotEmpty;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5F3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.campaign_outlined,
                size: 36,
                color: Color(0xFF048C7C),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              isSearching
                  ? 'Konten tidak ditemukan'
                  : 'Belum ada konten sahabat muadzin',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              isSearching
                  ? 'Coba cari dengan kata kunci lain'
                  : 'Konten dan inspirasi muadzin akan segera diperbarui.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, bool canPop) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
            child: Row(
              children: [
                if (canPop) ...[
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
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        size: 20,
                        color: Color(0xFF137065),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                ],
                Text(
                  'Sahabat Muadzin',
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF137065),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDE8E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.cloud_off_rounded,
                      size: 36,
                      color: Color(0xFFE53935),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal Memuat Data',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Terjadi kendala saat mengambil data konten muadzin. Silakan coba kembali.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF048C7C),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => ref.invalidate(muadzinListProvider),
                    icon: const Icon(Icons.refresh_rounded, size: 18),
                    label: Text(
                      'Coba Lagi',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
