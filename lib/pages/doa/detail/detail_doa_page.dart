import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/doa_models.dart';
import 'package:masjid_app/models/pagination_state.dart';
import 'package:masjid_app/providers/doa_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DetailDoaPage extends ConsumerStatefulWidget {
  const DetailDoaPage({super.key});

  @override
  ConsumerState<DetailDoaPage> createState() => _DetailDoaPageState();
}

class _DetailDoaPageState extends ConsumerState<DetailDoaPage> {
  final TextEditingController _searchController = TextEditingController();
  late final ScrollController _scrollController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= maxScroll - 200) {
        final categoryId = GoRouterState.of(context).pathParameters['id'] ?? '';
        final params = DoaListParams(categoryId: categoryId, query: _query);
        ref.read(doaInfiniteProvider(params).notifier).loadNextPage();
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  static final List<DoaItemModel> _dummyDoaList = List.generate(
    6,
    (i) => DoaItemModel(
      id: i + 1,
      judul: 'Contoh Judul Doa Lengkap',
      arab: 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ',
      arti: 'Ya Allah, sesungguhnya aku memohon ampunan dan keselamatan kepada-Mu di dunia dan akhirat.',
    ),
  );

  @override
  Widget build(BuildContext context) {
    final routeState = GoRouterState.of(context);
    final categoryId = routeState.pathParameters['id'] ?? '';
    final extra = routeState.extra;
    final categoryName = extra is Map && extra.containsKey('categoryName')
        ? extra['categoryName'].toString()
        : "Kumpulan Do'a";

    final params = DoaListParams(categoryId: categoryId, query: _query);
    final state = ref.watch(doaInfiniteProvider(params));

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
                categoryName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF137065),
                ),
              ),
              Text(
                "Daftar do'a & lafadz bacaan",
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
        body: RefreshIndicator(
          color: const Color(0xFF048C7C),
          backgroundColor: Colors.white,
          onRefresh: () => ref.read(doaInfiniteProvider(params).notifier).refresh(),
          child: _buildContent(context, categoryId, categoryName, params, state),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    String categoryId,
    String categoryName,
    DoaListParams params,
    PaginationState<DoaItemModel> state,
  ) {
    if (state.isLoading && state.items.isEmpty) {
      return _buildScrollView(
        context,
        categoryId,
        categoryName,
        _dummyDoaList,
        isLoading: true,
        state: state,
      );
    }

    if (state.errorMessage != null && state.items.isEmpty) {
      return _buildError(context, params);
    }

    return _buildScrollView(
      context,
      categoryId,
      categoryName,
      state.items,
      isLoading: false,
      state: state,
    );
  }

  Widget _buildScrollView(
    BuildContext context,
    String categoryId,
    String categoryName,
    List<DoaItemModel> list, {
    required bool isLoading,
    required PaginationState<DoaItemModel> state,
  }) {
    return Skeletonizer(
      enabled: isLoading,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          // Search & Summary Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      onChanged: (val) => setState(() => _query = val),
                      style: GoogleFonts.poppins(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: "Cari judul doa atau arti...",
                        hintStyle: GoogleFonts.poppins(
                          color: Colors.black38,
                          fontSize: 13,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: Color(0xFF048C7C),
                          size: 22,
                        ),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _query = '');
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

                  // Section Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilihan Doa',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF137065),
                        ),
                      ),
                      Text(
                        isLoading ? 'Memuat...' : '${list.length} Doa Dimuat',
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

          // List Items
          if (!isLoading && list.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/doa.svg',
                        width: 48,
                        height: 48,
                        colorFilter: const ColorFilter.mode(
                          Colors.black26,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Doa tidak ditemukan',
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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = list[index];
                    return FadeInUp(
                      duration: Duration(milliseconds: 180 + (index * 35).clamp(0, 400)),
                      child: _buildDoaCard(context, item, index, categoryId, categoryName),
                    );
                  },
                  childCount: list.length,
                ),
              ),
            ),

          // Bottom Loading Indicator (Infinite Scroll feedback)
          if (state.isLoadingMore)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Color(0xFF048C7C),
                    ),
                  ),
                ),
              ),
            )
          else if (!state.hasMore && list.isNotEmpty && !isLoading)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 28, top: 8),
                child: Center(
                  child: Text(
                    'Semua doa telah dimuat',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDoaCard(
    BuildContext context,
    DoaItemModel item,
    int index,
    String categoryId,
    String categoryName,
  ) {
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
          onTap: () {
            context.push(
              AppRoutes.doaContent
                  .replaceFirst(':id', categoryId)
                  .replaceFirst(':content', item.id.toString()),
              extra: {
                'categoryName': categoryName,
                'doaItem': item,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Badge Number, Title, Chevron
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5F1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF048C7C),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.judul,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF137065),
                              height: 1.3,
                            ),
                          ),
                          if (item.riwayat.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              item.riwayat,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.black45,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAF9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF048C7C),
                        size: 18,
                      ),
                    ),
                  ],
                ),

                // Arabic Snippet (if available)
                if (item.arab.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBFDFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFEDF5F2)),
                    ),
                    child: Text(
                      item.arab,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.amiri(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                        height: 1.8,
                      ),
                    ),
                  ),
                ],

                // Translation preview
                if (item.arti.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    item.arti,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, DoaListParams params) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: Colors.black38,
            ),
            const SizedBox(height: 12),
            Text(
              'Gagal memuat daftar doa',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF048C7C),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => ref.read(doaInfiniteProvider(params).notifier).loadFirstPage(),
              child: Text(
                'Coba Lagi',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
