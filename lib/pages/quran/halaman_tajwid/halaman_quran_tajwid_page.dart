import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/pages/quran/component/mushaf_filter_bottom_sheet.dart';
import 'package:masjid_app/pages/quran/halaman_tajwid/component/image_viewer_widget.dart';
import 'package:masjid_app/pages/quran/halaman_tajwid/model/tajwid_ayah_data.dart';
import 'package:masjid_app/providers/quran_page_providers.dart';
import 'package:masjid_app/providers/quran_provider.dart';
import 'package:masjid_app/storage/bookmarkStorage.dart';

class HalamanQuranTajwidPage extends ConsumerStatefulWidget {
  const HalamanQuranTajwidPage({super.key});

  @override
  ConsumerState<HalamanQuranTajwidPage> createState() =>
      _HalamanQuranTajwidPageState();
}

class _HalamanQuranTajwidPageState
    extends ConsumerState<HalamanQuranTajwidPage> {
  static const String _asset = 'assets/img/quran/quran-page-tajwid.json';
  static const String _lastReadKey = 'tajwidLastRead';

  final BookmarkStorage _bookmarkStorage = BookmarkStorage("tajwid");

  var surahSaatIni = 'Quran Tajwid';
  var halSaatIni = '1';
  var bookmarked = false;
  int toSurat = 0;
  int lastReadHal = 1;
  Map<String, dynamic>? _currentPage;
  AyahCoordinate? _selectedAyah;
  bool _isNavbarVisible = true;
  DateTime? _lastOrientationToggleTime;

  @override
  void initState() {
    super.initState();
    _restoreLastRead();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final queryPage = int.tryParse(GoRouterState.of(context).uri.queryParameters['page'] ?? '');
    if (queryPage != null && queryPage > 0) {
      lastReadHal = queryPage;
      halSaatIni = queryPage.toString();
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  void _toggleNavbar() {
    setState(() {
      _isNavbarVisible = !_isNavbarVisible;
    });
    if (_isNavbarVisible) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  /// Pengganti `HalamanQuranController.onInit()`: baca posisi terakhir baca.
  /// Nilai map dibaca lewat jsonDecode (JSON-encode sejak versi lama).
  /// Route legacy bisa datang dengan `?bookmarks=true`; artinya sama —
  /// selalu buka posisi terakhir baca.
  void _restoreLastRead() {
    final raw = PreferencesService.getString(_lastReadKey);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return;
      if (decoded['surat'] != null) {
        surahSaatIni = decoded['surat'].toString();
      }
      if (decoded['hal'] != null) {
        halSaatIni = decoded['hal'].toString();
        lastReadHal = int.tryParse(decoded['hal'].toString()) ?? 1;
      }
    } catch (_) {
      // data rusak — biarkan default ('Quran Tajwid' / halaman 1)
    }
  }

  /// Pengganti lookup controller langsung dari viewer.
  void _onPageChanged(int index, List<Map<String, dynamic>> listSurah) {
    if (index < 0 || index >= listSurah.length) return;
    final item = listSurah[index];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _currentPage = item;
        _selectedAyah = null;
        surahSaatIni = item['surat'].toString();
        halSaatIni = item['hal'].toString();
        toSurat = index + 1;
      });
      _saveBookmark(item);
    });
  }

  /// Simpan posisi tilawah supaya grid Al-Qur'an ("Tilawah Tajwid")
  /// menampilkan posisi terakhir. Dulu `HalamanQuranController.bookmark()`
  /// masih no-op, jadi posisi tidak pernah tersimpan.
  void _saveBookmark(Map<String, dynamic> item) {
    _bookmarkStorage.saveBookmark(BookmarkData(
      namaSurat: (item['surat'] ?? '').toString(),
      // Aset mushaf hanya punya nama surat + nomor halaman, bukan nomor surat.
      surat: 0,
      ayat: 0,
      totalAyat: 0,
      index: int.tryParse('${item['hal']}') ?? 0,
    ));
  }

  void _setPageFromItem(Map<String, dynamic> item) {
    setState(() {
      _currentPage = item;
      surahSaatIni = item['surat'].toString();
      halSaatIni = item['hal'].toString();
      toSurat = int.tryParse('${item['id']}') ?? 0;
    });
  }

  /// Pengganti `goToHal(numbertogo)`: langsung cari nomor halaman di aset.
  void _goToHal(String numbertogo, List<Map<String, dynamic>> listSurah) {
    final matches =
        listSurah.where((item) => item['hal'].toString() == numbertogo);
    if (matches.isEmpty) return;
    _setPageFromItem(matches.first);
  }

  void _toggleOrientation() {
    final now = DateTime.now();
    if (_lastOrientationToggleTime != null &&
        now.difference(_lastOrientationToggleTime!) <
            const Duration(milliseconds: 600)) {
      return;
    }
    _lastOrientationToggleTime = now;

    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
  }

  void _openFilterBottomSheet(
    List<Map<String, dynamic>> listSurah, {
    MushafFilterTab initialTab = MushafFilterTab.halaman,
  }) {
    final curHal = int.tryParse(halSaatIni) ?? lastReadHal;
    showMushafFilterBottomSheet(
      context: context,
      currentHal: curHal,
      currentSurah: surahSaatIni,
      listSurah: listSurah,
      initialTab: initialTab,
      onSelectPage: (targetPage) {
        _goToHal(targetPage.toString(), listSurah);
      },
    );
  }

  SafeArea layout(List<Map<String, dynamic>> listSurah, bool isLoadingList,
      BuildContext context) {
    return SafeArea(
        child: isLoadingList
            ? const Center(child: CircularProgressIndicator())
            : Container(
                constraints: BoxConstraints.loose(Size.infinite),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Flexible(
                            child: EasyImageViewPager(
                                onTap: (int index) {
                                  _toggleNavbar();
                                },
                                onDoubleTap: _toggleOrientation,
                                selectedAyah: _selectedAyah,
                                onAyahSelected: (ayah) {
                                  setState(() {
                                    _selectedAyah = ayah;
                                  });
                                },
                                idxInitial: toSurat > 0 ? toSurat : lastReadHal,
                                lastReadKey: _lastReadKey,
                                onPageChanged: (int index) {
                                  _onPageChanged(index, listSurah);
                                },
                                imageProviders: listSurah)),
                      ],
                    ),
                    if (_selectedAyah != null) _buildSelectedAyahBar(context),
                  ],
                )));
  }

  bool _isAyahAtBottom(AyahCoordinate ayah) {
    if (ayah.boundingBox.isEmpty) return false;
    final ymin = ayah.boundingBox[0];
    final ymax = ayah.boundingBox[2];
    final midY = (ymin + ymax) / 2.0;
    // Skala 0..1000: jika posisi vertikal > 480, ayat berada di paruh bawah layar
    return midY > 480;
  }

  Widget _buildSelectedAyahBar(BuildContext context) {
    final ayah = _selectedAyah!;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final isBottom = _isAyahAtBottom(ayah);

    // Ambil data detail ayat langsung dari endpoint /quran/surah/:id (format list AyatModel)
    final surahAsync = ref.watch(surahDetailProvider(ayah.surahNumber));
    final ayats = surahAsync.valueOrNull;
    AyatModel? targetAyat;
    if (ayats != null) {
      for (final a in ayats) {
        if (a.ayat == ayah.ayahNumber) {
          targetAyat = a;
          break;
        }
      }
    }

    final surahTitle = ayah.surahName;
    final textArab = (targetAyat != null && targetAyat.arab.isNotEmpty)
        ? targetAyat.arab
        : (ayah.arabicText.isNotEmpty ? ayah.arabicText : '');
    final translation = targetAyat?.arti ?? '';
    final isLoadingAyah = surahAsync.isLoading && textArab.isEmpty;

    final card = Material(
      elevation: 10,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(18),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF048C7C).withValues(alpha: 0.2),
            width: 1.2,
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Baris Judul & Badge
              Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF048C7C).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.menu_book_rounded,
                                  size: 14,
                                  color: Color(0xFF048C7C),
                                ),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    'QS. $surahTitle : ${ayah.ayahNumber}',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: Color(0xFF048C7C),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.grey.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Hal. $halSaatIni',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectedAyah = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Teks Arab Ayat & Terjemahan dari Endpoint
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isLoadingAyah
                    ? const SizedBox(
                        height: 48,
                        child: Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF048C7C),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            textArab.isNotEmpty
                                ? textArab
                                : (surahAsync.hasError
                                    ? 'Gagal memuat teks ayat'
                                    : 'Teks ayat tidak tersedia'),
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            maxLines: isLandscape ? 6 : 4,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                              height: 1.8,
                            ),
                          ),
                          if (translation.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              translation,
                              maxLines: isLandscape ? 4 : 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
              const SizedBox(height: 12),
              // Tombol Aksi
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF048C7C),
                        side: BorderSide(
                          color: const Color(0xFF048C7C).withValues(alpha: 0.4),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                      ),
                      onPressed: () {
                        final textToCopy =
                            textArab.isNotEmpty ? textArab : ayah.arabicText;
                        if (textToCopy.isEmpty) return;
                        Clipboard.setData(ClipboardData(text: textToCopy));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Ayat ${ayah.ayahNumber} disalin ke clipboard'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 15),
                      label: const Text(
                        'Salin',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF048C7C),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 9),
                      ),
                      onPressed: () {
                        _bookmarkAyah(ayah, surahTitle: surahTitle);
                      },
                      icon: const Icon(Icons.bookmark_add_rounded, size: 15),
                      label: const Text(
                        'Tandai',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (isLandscape) {
      final cardWidth =
          (MediaQuery.of(context).size.width / 3).clamp(280.0, 440.0);
      return Positioned(
        right: 16,
        top: 16,
        bottom: 16,
        width: cardWidth,
        child: FadeInRight(
          duration: const Duration(milliseconds: 250),
          child: card,
        ),
      );
    }

    return Positioned(
      left: 16,
      right: 16,
      top: isBottom ? 16 : null,
      bottom: isBottom ? null : 16,
      child: isBottom
          ? FadeInDown(duration: const Duration(milliseconds: 250), child: card)
          : FadeInUp(duration: const Duration(milliseconds: 250), child: card),
    );
  }

  void _bookmarkAyah(AyahCoordinate ayah, {String? surahTitle}) {
    final finalSurahName =
        (surahTitle != null && surahTitle.isNotEmpty) ? surahTitle : ayah.surahName;
    _bookmarkStorage.saveBookmark(BookmarkData(
      namaSurat: finalSurahName,
      surat: ayah.surahNumber,
      ayat: ayah.ayahNumber,
      totalAyat: 0,
      index: int.tryParse(halSaatIni) ?? 1,
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Tandai terakhir baca: QS. $finalSurahName ayat ${ayah.ayahNumber}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showPopup(List<Map<String, dynamic>> listSurah, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return Dialog(
            elevation: 0,
            backgroundColor: Color(0xFFDADADA),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.0)),
            child: Container(
                padding: EdgeInsets.all(10),
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonElevated(
                      title: 'Tandai Halaman ini',
                      width: MediaQuery.of(bc).size.width,
                      bgcolor: Theme.of(bc).primaryColor,
                      height: 45,
                      color: Colors.white,
                      radius: 7,
                      shadow: false,
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          bookmarked = !bookmarked;
                        });
                        final page = _currentPage;
                        if (page != null) _saveBookmark(page);
                      },
                    ),
                  ],
                )),
          );
        });
  }

  void showModal(List<Map<String, dynamic>> listSurah, BuildContext context) {
    _openFilterBottomSheet(listSurah, initialTab: MushafFilterTab.surah);
  }

  void showDialogFilter(
      List<Map<String, dynamic>> listSurah, BuildContext context) {
    _openFilterBottomSheet(listSurah, initialTab: MushafFilterTab.halaman);
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(quranPageListProvider(_asset));
    final listSurah = listAsync.valueOrNull ?? const <Map<String, dynamic>>[];
    final isLoadingList = listAsync.isLoading;

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
          ]);
          if (didPop) {
            return;
          }
          context.pop('refresh');
        },
        child: Scaffold(
            backgroundColor: const Color(0xFFF5F5F5),
            extendBodyBehindAppBar: false,
            resizeToAvoidBottomInset: false,
            body: layout(listSurah, isLoadingList, context),
            appBar: _isNavbarVisible
                ? AppBar(
                    iconTheme: const IconThemeData(color: Colors.white),
                    leading: GestureDetector(
                        onTap: () {
                          SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.edgeToEdge);
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.portraitUp,
                          ]);
                          context.pop('refresh');
                        },
                        child: const Icon(Icons.arrow_back_rounded)),
                    backgroundColor: const Color(0xFF048C7C),
                    elevation: 0,
                    titleSpacing: 0,
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white30,
                          onTap: () => {showModal(listSurah, context)},
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      surahSaatIni,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        letterSpacing: 0.5,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Halaman $halSaatIni",
                                      style: const TextStyle(
                                        fontSize: 11,
                                        letterSpacing: 0.5,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.expand_more_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                        icon: Icon(
                          bookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: Colors.white,
                        ),
                        tooltip: 'Tandai Halaman',
                        onPressed: () {
                          setState(() {
                            bookmarked = !bookmarked;
                          });
                          final page = _currentPage;
                          if (page != null) _saveBookmark(page);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(bookmarked
                                  ? 'Halaman $halSaatIni ditandai'
                                  : 'Tanda halaman $halSaatIni dihapus'),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      Material(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: InkWell(
                              onTap: () {
                                showDialogFilter(listSurah, context);
                              },
                              borderRadius: BorderRadius.circular(20),
                              splashColor: Colors.green.withValues(alpha: 0.5),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Icon(
                                  Icons.tune_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ))
                    ],
                  )
                : null,
            bottomNavigationBar: _isNavbarVisible
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF048C7C),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded,
                                color: Colors.white, size: 18),
                            tooltip: "Halaman Sebelumnya",
                            onPressed: () {
                              final current = int.tryParse(halSaatIni) ?? 1;
                              if (current > 1) {
                                _goToHal((current - 1).toString(), listSurah);
                              }
                            },
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: Colors.white,
                                    inactiveTrackColor: Colors.white30,
                                    thumbColor: Colors.white,
                                    overlayColor: Colors.white24,
                                    thumbShape: const RoundSliderThumbShape(
                                        enabledThumbRadius: 6),
                                    trackHeight: 3,
                                  ),
                                  child: Slider(
                                    value: (int.tryParse(halSaatIni) ?? 1)
                                        .toDouble()
                                        .clamp(1.0, 604.0),
                                    min: 1.0,
                                    max: 604.0,
                                    onChanged: (val) {
                                      final target = val.round().toString();
                                      _goToHal(target, listSurah);
                                    },
                                  ),
                                ),
                                Text(
                                  "Halaman $halSaatIni dari 604",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded,
                                color: Colors.white, size: 18),
                            tooltip: "Halaman Berikutnya",
                            onPressed: () {
                              final current = int.tryParse(halSaatIni) ?? 1;
                              if (current < 604) {
                                _goToHal((current + 1).toString(), listSurah);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : null));
  }
}
