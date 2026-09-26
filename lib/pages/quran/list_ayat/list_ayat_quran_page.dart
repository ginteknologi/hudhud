import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_controller.dart';
import 'package:masjid_app/providers/quran_ayat_providers.dart';
import 'package:masjid_app/providers/quran_provider.dart';
import 'package:masjid_app/providers/quran_ui_settings_provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:share_plus/share_plus.dart';

class ListAyatQuranPage extends ConsumerStatefulWidget {
  const ListAyatQuranPage({super.key});

  @override
  ConsumerState<ListAyatQuranPage> createState() => _ListAyatQuranPageState();
}

/// Satu tab surah beserta daftar ayat yang sudah dimuat (dulu
/// `contentTab[i] = {'idContent': id, 'list': <ListAyatData>[]}`).
class _SurahContent {
  _SurahContent(this.idContent);

  final int idContent;
  final List<AyatModel> list = [];
}

class _ListAyatQuranPageState extends ConsumerState<ListAyatQuranPage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer player = AudioPlayer();
  List<AudioSource> listAudio = [];
  bool isPlaySound = false;
  bool isLoadingList = true;
  bool isLoadingDetail = false;

  int? _highlightedAyatIndex;
  Timer? _highlightTimer;

  final List<ItemScrollController> itemScrollController = [];
  final List<Tab> myTabs = [];
  final List<_SurahContent> contentTab = [];
  List<Map<String, dynamic>> list = [];
  Map<String, dynamic> detail = {};

  TabController? tabController;
  PageController? pageController;

  StreamSubscription<int?>? _indexSubscription;
  StreamSubscription<PlayerState>? _stateSubscription;
  int? _currentPlayingAyatIndex;

  bool _started = false;
  bool _useBookmark = false;
  int? _targetSurah;
  int? _targetAyat;

  int _getJuzNumber(int surahNumber, [int ayatNumber = 1]) {
    for (int i = kQuranJuzList.length - 1; i >= 0; i--) {
      final j = kQuranJuzList[i];
      if (surahNumber > j.startSurahNumber ||
          (surahNumber == j.startSurahNumber && ayatNumber >= j.startAyat)) {
        return j.juzNumber;
      }
    }
    return 1;
  }

  String _getSurahSubtitle(Map<String, dynamic> surah, {int ayat = 1}) {
    final ayatCount = surah['ayat'] ?? surah['jumlahAyat'] ?? 0;
    final rawType =
        (surah['tipe'] ?? surah['type'] ?? '').toString().toLowerCase();
    final typeName = rawType.contains('mad')
        ? 'Madaniyyah'
        : (rawType.isNotEmpty ? 'Makkiyyah' : '');

    final surahId = (surah['id'] is int)
        ? surah['id'] as int
        : int.tryParse(surah['id']?.toString() ?? '1') ?? 1;

    final juzNum = _getJuzNumber(surahId, ayat);

    final parts = <String>[];
    if (ayatCount > 0) parts.add('$ayatCount Ayat');
    if (typeName.isNotEmpty) parts.add(typeName);
    if (juzNum > 0) parts.add('Juz $juzNum');

    return parts.isEmpty ? 'Al-Qur\'an' : parts.join(' • ');
  }

  String _getSurahArab(Map<String, dynamic> surah) {
    return (surah['arab'] ?? surah['asma'] ?? '').toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final uri = GoRouterState.of(context).uri;
    _useBookmark = uri.queryParameters['bookmarks'] == 'true';
    _targetSurah = int.tryParse(uri.queryParameters['surah'] ?? '');
    _targetAyat = int.tryParse(uri.queryParameters['ayat'] ?? '');
    _init();
  }

  Future<void> _init() async {
    await getData();
    if (!mounted || list.isEmpty || myTabs.isEmpty) return;
    setState(() {
      list = list.reversed.toList();
    });

    // 1. Prioritaskan jika dipanggil dengan parameter spesifik surah & ayat
    if (_targetSurah != null && _targetSurah! > 0) {
      final int getindexbysurah =
          list.indexWhere((element) => element['id'] == _targetSurah);
      if (getindexbysurah != -1) {
        final int newindex = myTabs.length - 1 - getindexbysurah;
        setState(() {
          pageController = PageController(initialPage: newindex);
          detail = Map<String, dynamic>.from(list[getindexbysurah]);
          tabController = TabController(
              vsync: this, length: myTabs.length, initialIndex: getindexbysurah);
        });
        final jump = (_targetAyat != null && _targetAyat! > 0) ? _targetAyat! - 1 : 0;
        await getDetailData(surahId: _targetSurah!, jumpto: jump);
        return;
      }
    }

    // 2. Jika dipanggil dengan mode bookmark
    final BookmarkData book = ref.read(alquranBookmarkProvider('ayat'));
    if (_useBookmark && book.surat != 0) {
      final int getindexbysurah =
          list.indexWhere((element) => element['id'] == book.surat);
      if (getindexbysurah != -1) {
        final int newindex = myTabs.length - 1 - getindexbysurah;
        setState(() {
          pageController = PageController(initialPage: newindex);
          detail = Map<String, dynamic>.from(list[getindexbysurah]);
          tabController = TabController(
              vsync: this, length: myTabs.length, initialIndex: getindexbysurah);
        });
        await getDetailData(surahId: book.surat, jumpto: book.ayat - 1);
        return;
      }
    }
    setState(() {
      detail = Map<String, dynamic>.from(list[myTabs.length - 1]);
      pageController = PageController(initialPage: 0);
      tabController = TabController(
          vsync: this, length: myTabs.length, initialIndex: myTabs.length - 1);
    });
    await getDetailData(surahId: 1);
  }

  Future<void> getData() async {
    try {
      isLoadingList = true;
      final result = await ref.read(surahListRawProvider('').future);
      if (!mounted) return;
      // Daftar kosong = permintaan gagal; versi GetX dulu melempar error dan
      // indikator loading tidak pernah berhenti.
      if (result.isEmpty) return;
      setState(() {
        list = result;
        for (var i = 0; i < result.length; i++) {
          myTabs.add(Tab(
            text: (result[i]['nama'] ?? '').toString(),
          ));
          contentTab.add(_SurahContent(result[i]['id'] as int));
          itemScrollController.add(ItemScrollController());
        }
        isLoadingList = false;
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('<<<<<<< error get data ayat quran >>>>>>>');
        debugPrint(e.toString());
      }
    }
  }

  void _setHighlightAyat(int index) {
    _highlightTimer?.cancel();
    setState(() {
      _highlightedAyatIndex = index;
    });
    _highlightTimer = Timer(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _highlightedAyatIndex = null;
        });
      }
    });
  }

  Future<void> _jumpToSurahAndAyat(int surahId, int ayatNumber) async {
    final ddd = list.indexWhere((element) => element['id'] == surahId);
    if (ddd == -1) return;

    final targetContentIndex =
        contentTab.indexWhere((data) => data.idContent == surahId);

    // Jika surah berbeda dari yang sedang aktif, beralih tab dan page
    if (detail['id'] != surahId) {
      final pageIndex = myTabs.length - ddd - 1;
      if (pageController != null && pageController!.hasClients) {
        pageController!.jumpToPage(pageIndex);
      }
      setState(() {
        detail = Map<String, dynamic>.from(list[ddd]);
      });
      tabController?.animateTo(ddd);
    }

    // Pastikan data ayat surah tersebut sudah termuat
    await getDetailData(surahId: surahId);

    final ayatIndex = ayatNumber - 1;
    if (targetContentIndex != -1 &&
        ayatIndex >= 0 &&
        ayatIndex < contentTab[targetContentIndex].list.length) {
      await Future.delayed(const Duration(milliseconds: 150));
      if (itemScrollController[targetContentIndex].isAttached) {
        try {
          itemScrollController[targetContentIndex].scrollTo(
            index: ayatIndex,
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
          );
        } catch (_) {
          itemScrollController[targetContentIndex].jumpTo(index: ayatIndex);
        }
      }
      _setHighlightAyat(ayatIndex);
    }
  }

  Future<void> getDetailData({
    required int surahId,
    int jumpto = 0,
  }) async {
    try {
      final targetDataIndex =
          contentTab.indexWhere((data) => data.idContent == surahId);
      final cek = contentTab[targetDataIndex].list.length;
      final BookmarkData resultBookmark =
          ref.read(alquranBookmarkProvider('ayat'));
      if (cek == 0) {
        if (kDebugMode) {
          debugPrint('fetch detail');
          debugPrint(cek.toString());
          debugPrint(surahId.toString());
        }
        if (mounted) {
          setState(() {
            isLoadingDetail = true;
          });
        }
        final result = await ref.read(surahDetailProvider(surahId).future);
        if (!mounted) return;
        setState(() {
          for (final ayat in result) {
            contentTab[targetDataIndex].list.add(ayat.copyWith(
                isBookmarked: resultBookmark.surat == surahId &&
                    resultBookmark.ayat == ayat.ayat));
          }
          isLoadingDetail = false;
        });
        if (jumpto > 0) {
          await Future.delayed(const Duration(milliseconds: 100));
          if (itemScrollController[targetDataIndex].isAttached) {
            itemScrollController[targetDataIndex].jumpTo(
              index: jumpto,
            );
          }
        }
      } else {
        setState(() {
          for (var i = 0; i < contentTab[targetDataIndex].list.length; i++) {
            final item = contentTab[targetDataIndex].list[i];
            contentTab[targetDataIndex].list[i] = item.copyWith(
              isBookmarked: resultBookmark.surat == surahId &&
                  resultBookmark.ayat == item.ayat,
            );
          }
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(e.toString());
      }
    }
  }

  Future<void> playMurotal(AyatModel item) async {
    try {
      final targetDataIndex =
          contentTab.indexWhere((data) => data.idContent == item.surat);

      final List<AyatModel> listAyat = contentTab[targetDataIndex].list;
      listAudio = [];
      int defaultInit = 0;
      for (var i = 0; i < listAyat.length; i++) {
        if ((listAyat[i].ayat) == (item.ayat)) {
          defaultInit = i;
        }
        listAudio.add(AudioSource.uri(Uri.parse(listAyat[i].audioUrl)));
      }

      await player.setAudioSources(
        listAudio,
        initialIndex: defaultInit,
        initialPosition: Duration.zero,
      );
      player.play();
      await _indexSubscription?.cancel();
      _indexSubscription = player.currentIndexStream.listen((event) {
        if (event != null) {
          if (mounted) {
            setState(() {
              _currentPlayingAyatIndex = event;
            });
          }
          if (itemScrollController[targetDataIndex].isAttached) {
            itemScrollController[targetDataIndex].jumpTo(
              index: event,
            );
          }
        }
      });

      await _stateSubscription?.cancel();
      _stateSubscription = player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          isPlaySound = false;
          listAudio = [];
          _currentPlayingAyatIndex = null;
          if (mounted) {
            setState(() {});
          }
        }
      });

      if (mounted) {
        setState(() {
          isPlaySound = true;
          _currentPlayingAyatIndex = defaultInit;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('error murotal');
        debugPrint(e.toString());
      }
    }
  }

  void stopMurotal() {
    player.stop();
    setState(() {
      isPlaySound = false;
      listAudio = [];
      _currentPlayingAyatIndex = null;
    });
  }

  void _copyAyat(AyatModel item) {
    final surahNama = detail['nama'] ?? '';
    final arabText = item.madinah.isNotEmpty ? item.madinah : item.arab;
    final textToCopy = '$arabText\n\n${item.arti}\n(QS. $surahNama: ${item.ayat})';
    Clipboard.setData(ClipboardData(text: textToCopy));
    Fluttertoast.showToast(
      msg: 'Ayat ${item.ayat} berhasil disalin',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

  void _showFontSettingsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (bottomSheetContext) {
        return Consumer(
          builder: (context, ref, _) {
            final uiSettings = ref.watch(quranUiSettingsProvider);
            final notifier = ref.read(quranUiSettingsProvider.notifier);

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Tampilan & Ukuran Font",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        onPressed: () => Navigator.of(bottomSheetContext).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Ukuran Font Arab (${uiSettings.arabicFontSize.toInt()} px)",
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  Slider(
                    value: uiSettings.arabicFontSize,
                    min: 18.0,
                    max: 36.0,
                    divisions: 9,
                    activeColor: const Color(0xFF048C7C),
                    onChanged: (val) => notifier.updateArabicFontSize(val),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Ukuran Font Terjemahan (${uiSettings.translationFontSize.toInt()} px)",
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                  Slider(
                    value: uiSettings.translationFontSize,
                    min: 11.0,
                    max: 20.0,
                    divisions: 9,
                    activeColor: const Color(0xFF048C7C),
                    onChanged: (val) => notifier.updateTranslationFontSize(val),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF048C7C),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade300,
                    trackOutlineColor:
                        WidgetStateProperty.all(Colors.transparent),
                    title: const Text("Tampilkan Transliterasi Latin",
                        style: TextStyle(fontSize: 13)),
                    value: uiSettings.showLatin,
                    onChanged: (val) => notifier.toggleLatin(val),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeThumbColor: Colors.white,
                    activeTrackColor: const Color(0xFF048C7C),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: Colors.grey.shade300,
                    trackOutlineColor:
                        WidgetStateProperty.all(Colors.transparent),
                    title: const Text("Tampilkan Terjemahan",
                        style: TextStyle(fontSize: 13)),
                    value: uiSettings.showTranslation,
                    onChanged: (val) => notifier.toggleTranslation(val),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
    );
  }

  void _showSurahPickerDialog({void Function(Map<String, dynamic>)? onSelectSurah}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (bottomSheetContext) {
        String filter = '';
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filtered = list.where((item) {
              if (filter.isEmpty) return true;
              final q = filter.toLowerCase();
              return (item['nama'] ?? '').toString().toLowerCase().contains(q) ||
                  item['id'].toString() == q;
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Pilih Surah",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Cari nama surah atau nomor...",
                      hintStyle: const TextStyle(fontSize: 13),
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    onChanged: (val) {
                      setModalState(() {
                        filter = val.trim();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.separated(
                      itemCount: filtered.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, idx) {
                        final s = filtered[idx];
                        final isCurrent = detail['id'] == s['id'];

                        return ListTile(
                          selected: isCurrent,
                          selectedTileColor: const Color(0xFFE6F4F2),
                          leading: Text(
                            "${s['id']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isCurrent
                                   ? const Color(0xFF048C7C)
                                  : Colors.black54,
                            ),
                          ),
                          title: Text(
                            "${s['nama']}",
                            style: TextStyle(
                              fontWeight: isCurrent
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              color: isCurrent
                                  ? const Color(0xFF048C7C)
                                  : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            _getSurahSubtitle(s),
                            style: const TextStyle(fontSize: 11),
                          ),
                          trailing: Text(
                            _getSurahArab(s),
                            style: TextStyle(
                              fontFamily: GoogleFonts.amiriQuran().fontFamily,
                              fontSize: 17,
                              color: const Color(0xFF048C7C),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(bottomSheetContext).pop();
                            if (onSelectSurah != null) {
                              onSelectSurah(s);
                              return;
                            }
                            final ddd = list
                                .indexWhere((element) => element['id'] == s['id']);
                            if (ddd != -1) {
                              final newindex = myTabs.length - ddd - 1;
                              pageController!.jumpToPage(newindex);
                              changeTabIndex(ddd);
                              tabController!.animateTo(ddd);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> changeTabIndex(int index) async {
    setState(() {
      detail = Map<String, dynamic>.from(list[index]);
    });
    await getDetailData(surahId: detail['id'] as int);
  }

  Future<void> bookmark(AyatModel data) async {
    try {
      setState(() {
        isLoadingDetail = true;
      });
      final targetDataIndex = list.indexWhere((z) => z['id'] == data.surat);
      final targetSuratIndex =
          contentTab.indexWhere((z) => z.idContent == data.surat);

      final detailData = list[targetDataIndex];

      final newBookmark = BookmarkData(
          namaSurat: (detailData['nama'] ?? '').toString(),
          surat: data.surat,
          ayat: data.ayat,
          totalAyat: detailData['ayat'] as int? ?? 0);
      ref.read(alquranBookmarkProvider('ayat').notifier).save(newBookmark);

      if (!mounted) return;
      setState(() {
        for (var i = 0; i < contentTab[targetSuratIndex].list.length; i++) {
          final item = contentTab[targetSuratIndex].list[i];
          contentTab[targetSuratIndex].list[i] =
              item.copyWith(isBookmarked: item.ayat == data.ayat);
        }
        isLoadingDetail = false;
      });

      Fluttertoast.showToast(
          msg: "Ayat Berhasil Ditandai",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: MediaQuery.of(context).size.width / 30);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('error bookmark');
        debugPrint(e.toString());
      }
    }
  }

  void _showBottomSheet(AyatModel item) {
    final data = list.where((p0) => p0['id'] == item.surat).toList()[0];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => Container(
        color: Colors.white,
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "${data['nama']} ${item.ayat}:${data['ayat']}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.play_arrow),
              title: Text('Play Murotal'),
              onTap: () {
                playMurotal(item);
                Navigator.of(sheetContext).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('Bookmark'),
              onTap: () async {
                await bookmark(item);
                if (sheetContext.mounted) {
                  Navigator.of(sheetContext).pop();
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Bagikan Ayat'),
              onTap: () {
                // Lakukan sesuatu saat menu bagikan ayat dipilih
                SharePlus.instance.share(
                  ShareParams(
                    text: '${item.arab}\n\n${item.arti}',
                    subject: "${data['nama']} ${data['ayat']}:${item.ayat}",
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _highlightMatch(
    String text,
    String query,
    TextStyle defaultStyle,
    TextStyle matchStyle,
  ) {
    if (query.isEmpty) {
      return Text(text,
          style: defaultStyle, maxLines: 3, overflow: TextOverflow.ellipsis);
    }
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final spans = <TextSpan>[];
    int start = 0;
    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);
      if (index == -1) {
        if (start < text.length) {
          spans.add(TextSpan(text: text.substring(start), style: defaultStyle));
        }
        break;
      }
      if (index > start) {
        spans.add(TextSpan(
            text: text.substring(start, index), style: defaultStyle));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: matchStyle,
      ));
      start = index + query.length;
    }
    return RichText(
      text: TextSpan(children: spans),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<int> _getQuickJumpVerses(int total) {
    final Set<int> result = {1};
    if (total <= 7) {
      for (int i = 2; i <= total; i++) {
        result.add(i);
      }
      return result.toList();
    }
    if (total >= 10 && total < 30) {
      result.add(5);
      result.add(10);
      result.add(20);
    } else if (total >= 30 && total < 100) {
      result.add(10);
      result.add((total * 0.25).round());
      result.add((total * 0.50).round());
      result.add((total * 0.75).round());
    } else {
      result.add(25);
      result.add(50);
      result.add(100);
      if (total > 150) result.add(150);
      if (total > 200) result.add(200);
      if (total > 250) result.add(250);
    }
    result.add(total);
    final list = result.where((v) => v >= 1 && v <= total).toList();
    list.sort();
    return list;
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (bottomSheetContext) {
        int selectedTabIndex = 0;
        Map<String, dynamic> activeSurah = Map<String, dynamic>.from(
          detail.isNotEmpty
              ? detail
              : (list.isNotEmpty ? list.first : <String, dynamic>{}),
        );
        final ayatInputController = TextEditingController();
        final searchWordController = TextEditingController();
        String searchWord = '';
        String? ayatErrorText;

        return StatefulBuilder(
          builder: (context, setModalState) {
            final totalAyat = (activeSurah['ayat'] as int?) ?? 1;
            final quickVerses = _getQuickJumpVerses(totalAyat);

            // Cari list ayat untuk surah aktif
            final targetSurahIndex = contentTab
                .indexWhere((data) => data.idContent == activeSurah['id']);
            final List<AyatModel> versesList = targetSurahIndex != -1
                ? contentTab[targetSurahIndex].list
                : <AyatModel>[];

            final searchMatches = searchWord.isEmpty
                ? <AyatModel>[]
                : versesList.where((item) {
                    final q = searchWord.toLowerCase();
                    return item.arti.toLowerCase().contains(q) ||
                        item.latin.toLowerCase().contains(q) ||
                        item.arab.contains(searchWord) ||
                        item.madinah.contains(searchWord);
                  }).toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom,
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Header: Judul & tombol close
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Navigasi & Pencarian Ayat",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(Icons.close_rounded,
                              size: 22, color: Colors.black54),
                          onPressed: () =>
                              Navigator.of(bottomSheetContext).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Segmented Button Tab
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setModalState(() {
                                  selectedTabIndex = 0;
                                });
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                decoration: BoxDecoration(
                                  color: selectedTabIndex == 0
                                      ? const Color(0xFF048C7C)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: selectedTabIndex == 0
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF048C7C)
                                                .withValues(alpha: 0.25),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.explore_rounded,
                                      size: 16,
                                      color: selectedTabIndex == 0
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Lompat Ayat",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: selectedTabIndex == 0
                                            ? Colors.white
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                setModalState(() {
                                  selectedTabIndex = 1;
                                });
                                if (versesList.isEmpty) {
                                  getDetailData(
                                    surahId: activeSurah['id'] as int,
                                  ).then((_) {
                                    if (context.mounted) {
                                      setModalState(() {});
                                    }
                                  });
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                decoration: BoxDecoration(
                                  color: selectedTabIndex == 1
                                      ? const Color(0xFF048C7C)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: selectedTabIndex == 1
                                      ? [
                                          BoxShadow(
                                            color: const Color(0xFF048C7C)
                                                .withValues(alpha: 0.25),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          )
                                        ]
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search_rounded,
                                      size: 16,
                                      color: selectedTabIndex == 1
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Cari Kata",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: selectedTabIndex == 1
                                            ? Colors.white
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // TAB 0: Lompat Ayat
                    if (selectedTabIndex == 0) ...[
                      // Card Surah yang dipilih
                      InkWell(
                        onTap: () {
                          _showSurahPickerDialog(
                            onSelectSurah: (picked) {
                              setModalState(() {
                                activeSurah = picked;
                                ayatInputController.clear();
                                ayatErrorText = null;
                              });
                            },
                          );
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 11),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FAFA),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: const Color(0xFF048C7C)
                                  .withValues(alpha: 0.3),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6F4F2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${activeSurah['id'] ?? 1}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: Color(0xFF048C7C),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "${activeSurah['nama'] ?? ''}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        if (_getSurahArab(activeSurah).isNotEmpty) ...[
                                          const SizedBox(width: 6),
                                          Text(
                                            "(${_getSurahArab(activeSurah)})",
                                            style: TextStyle(
                                              fontFamily: GoogleFonts
                                                      .amiriQuran()
                                                  .fontFamily,
                                              fontSize: 14,
                                              color: const Color(0xFF048C7C),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    Text(
                                      _getSurahSubtitle(activeSurah),
                                      style: const TextStyle(
                                        fontSize: 11.5,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.grey.shade300),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "Ganti",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF048C7C),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      size: 16,
                                      color: Color(0xFF048C7C),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Input Nomor Ayat
                      TextField(
                        controller: ayatInputController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          labelText: "Nomor Ayat",
                          labelStyle: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF048C7C),
                            fontWeight: FontWeight.w500,
                          ),
                          hintText: "Masukkan ayat (1 - $totalAyat)...",
                          hintStyle: const TextStyle(fontSize: 13),
                          prefixIcon: const Icon(
                            Icons.format_list_numbered_rounded,
                            size: 20,
                            color: Color(0xFF048C7C),
                          ),
                          suffixIcon: ayatInputController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded,
                                      size: 18),
                                  onPressed: () {
                                    setModalState(() {
                                      ayatInputController.clear();
                                      ayatErrorText = null;
                                    });
                                  },
                                )
                              : null,
                          errorText: ayatErrorText,
                          filled: true,
                          fillColor: const Color(0xFFF9FBFB),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF048C7C),
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          if (ayatErrorText != null) {
                            setModalState(() {
                              ayatErrorText = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 12),

                      // Quick Chips
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Pintasan Ayat:",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: quickVerses.map((verseNum) {
                              final isSelected =
                                  ayatInputController.text == verseNum.toString();
                              return ActionChip(
                                label: Text(
                                  verseNum == totalAyat
                                      ? "Akhir ($verseNum)"
                                      : "Ayat $verseNum",
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF048C7C),
                                  ),
                                ),
                                backgroundColor: isSelected
                                    ? const Color(0xFF048C7C)
                                    : const Color(0xFFE6F4F2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: BorderSide(
                                    color: isSelected
                                        ? const Color(0xFF048C7C)
                                        : const Color(0xFFD4EFEA),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 0),
                                onPressed: () {
                                  setModalState(() {
                                    ayatInputController.text =
                                        verseNum.toString();
                                    ayatErrorText = null;
                                  });
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Tombol Lompat ke Ayat
                      ElevatedButton(
                        onPressed: () {
                          final text = ayatInputController.text.trim();
                          final val = int.tryParse(text);
                          if (val == null || val < 1 || val > totalAyat) {
                            setModalState(() {
                              ayatErrorText =
                                  "Nomor ayat harus antara 1 s/d $totalAyat";
                            });
                            return;
                          }
                          Navigator.of(bottomSheetContext).pop();
                          _jumpToSurahAndAyat(
                              activeSurah['id'] as int, val);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF048C7C),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_forward_rounded, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Buka Ayat",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // TAB 1: Cari Kata
                    if (selectedTabIndex == 1) ...[
                      // Search input
                      TextField(
                        controller: searchWordController,
                        decoration: InputDecoration(
                          hintText:
                              "Cari kata dalam ${activeSurah['nama']}...",
                          hintStyle: const TextStyle(fontSize: 13),
                          prefixIcon: const Icon(Icons.search_rounded,
                              size: 20, color: Color(0xFF048C7C)),
                          suffixIcon: searchWordController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded,
                                      size: 18),
                                  onPressed: () {
                                    setModalState(() {
                                      searchWordController.clear();
                                      searchWord = '';
                                    });
                                  },
                                )
                              : null,
                          filled: true,
                          fillColor: const Color(0xFFF9FBFB),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF048C7C),
                              width: 1.5,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          setModalState(() {
                            searchWord = val.trim();
                          });
                        },
                      ),
                      const SizedBox(height: 10),

                      // Hasil pencarian
                      Expanded(
                        child: searchWord.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.manage_search_rounded,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      "Cari Teks & Terjemahan",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Ketik kata dalam terjemahan Indonesia,\naksara Arab, atau transliterasi Latin.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : searchMatches.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.search_off_rounded,
                                          size: 44,
                                          color: Colors.grey.shade400,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Tidak ditemukan ayat dengan kata \"$searchWord\"",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: searchMatches.length,
                                    separatorBuilder: (_, __) =>
                                        const Divider(height: 1),
                                    itemBuilder: (context, idx) {
                                      final item = searchMatches[idx];
                                      return ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 4, vertical: 4),
                                        leading: Container(
                                          width: 34,
                                          height: 34,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFE6F4F2),
                                            shape: BoxShape.circle,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "${item.ayat}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Color(0xFF048C7C),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          item.madinah.isNotEmpty
                                              ? item.madinah
                                              : item.arab,
                                          textAlign: TextAlign.right,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.amiriQuran()
                                                    .fontFamily,
                                            fontSize: 15,
                                            color: const Color(0xFF048C7C),
                                          ),
                                        ),
                                        subtitle: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: _highlightMatch(
                                            item.arti,
                                            searchWord,
                                            const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                            ),
                                            const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF048C7C),
                                              backgroundColor:
                                                  Color(0xFFE6F4F2),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.of(bottomSheetContext)
                                              .pop();
                                          _jumpToSurahAndAyat(
                                              activeSurah['id'] as int,
                                              item.ayat);
                                        },
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final uiSettings = ref.watch(quranUiSettingsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF048C7C),
        foregroundColor: Colors.white,
        elevation: 0,
        title: InkWell(
          onTap: _showSurahPickerDialog,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            detail.isEmpty ? "Al-Qur'an" : detail['nama'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.keyboard_arrow_down_rounded,
                              color: Colors.white70, size: 20),
                        ],
                      ),
                      Text(
                        detail.isEmpty
                            ? "Pilih Surah"
                            : _getSurahSubtitle(detail,
                                ayat: (_currentPlayingAyatIndex ?? 0) + 1),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.format_size_rounded),
            tooltip: "Ukuran Teks",
            onPressed: _showFontSettingsDialog,
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded),
            tooltip: "Cari & Lompat Ayat",
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      bottomNavigationBar: (isPlaySound || listAudio.isNotEmpty)
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF048C7C),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isPlaySound
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_filled_rounded,
                        color: Colors.white,
                        size: 34,
                      ),
                      onPressed: () {
                        if (isPlaySound) {
                          player.pause();
                          setState(() => isPlaySound = false);
                        } else {
                          player.play();
                          setState(() => isPlaySound = true);
                        }
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail['nama'] ?? 'Murottal',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13),
                          ),
                          Text(
                            _currentPlayingAyatIndex != null
                                ? "Ayat ${_currentPlayingAyatIndex! + 1} dari ${detail['ayat'] ?? ''}"
                                : "Memutar surah...",
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded,
                          color: Colors.white70, size: 22),
                      tooltip: "Hentikan Audio",
                      onPressed: stopMurotal,
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: isLoadingList
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF048C7C),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 2,
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: TabBar(
                    indicator: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.white, width: 3),
                      ),
                    ),
                    labelColor: Colors.white,
                    splashBorderRadius: BorderRadius.circular(20),
                    unselectedLabelColor: const Color(0xFFD0D0D0),
                    isScrollable: true,
                    controller: tabController,
                    tabs: myTabs.reversed.toList(),
                    onTap: (index) {
                      var newindex = myTabs.length - index - 1;
                      pageController!.animateToPage(
                        newindex,
                        duration: const Duration(milliseconds: 10),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (index) {
                      var newindex = myTabs.length - index - 1;
                      changeTabIndex(newindex);
                      tabController!.animateTo(
                        newindex,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.ease,
                      );
                    },
                    reverse: true,
                    itemCount: myTabs.length,
                    itemBuilder: (context, index) {
                      final banyakAyat = contentTab[index].list.length;
                      if (isLoadingDetail) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return listAyat(
                        banyakAyat,
                        index,
                        itemScrollController[index],
                        uiSettings,
                      );
                    },
                    controller: pageController,
                  ),
                ),
              ],
            ),
    );
  }

  Widget listAyat(
    int banyakAyat,
    int indexPage,
    ItemScrollController itemScrollController,
    QuranUiSettings uiSettings,
  ) {
    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      shrinkWrap: true,
      itemCount: banyakAyat,
      itemBuilder: (context, index) {
        final AyatModel item = contentTab[indexPage].list[index];
        final bool isPlayingThis =
            (isPlaySound && _currentPlayingAyatIndex == index);
        final bool isHighlightedThis = (_highlightedAyatIndex == index);

        return InkWell(
          onTap: () => _showBottomSheet(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isPlayingThis
                  ? const Color(0xFFE6F4F2)
                  : (isHighlightedThis
                      ? const Color(0xFFC8ECE8)
                      : Colors.white),
              border: Border(
                bottom: BorderSide(
                  color: (isPlayingThis || isHighlightedThis)
                      ? const Color(0xFF048C7C)
                      : const Color(0xFFEEEEEE),
                  width: (isPlayingThis || isHighlightedThis) ? 2.0 : 1.0,
                ),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header baris ayat: Nomor ayat di kiri, Action icons di kanan
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Nomor Ayat
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isPlayingThis
                            ? const Color(0xFF048C7C)
                            : const Color(0xFFE6F4F2),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${item.ayat}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isPlayingThis
                              ? Colors.white
                              : const Color(0xFF048C7C),
                        ),
                      ),
                    ),

                    // Action Icons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Play Audio
                        IconButton(
                          icon: Icon(
                            isPlayingThis
                                ? Icons.pause_circle_outline_rounded
                                : Icons.play_circle_outline_rounded,
                            color: const Color(0xFF048C7C),
                            size: 22,
                          ),
                          tooltip: isPlayingThis ? 'Jeda Audio' : 'Putar Ayat',
                          onPressed: () {
                            if (isPlayingThis) {
                              player.pause();
                              setState(() => isPlaySound = false);
                            } else {
                              playMurotal(item);
                            }
                          },
                        ),

                        // Bookmark
                        IconButton(
                          icon: Icon(
                            item.isBookmarked
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: item.isBookmarked
                                ? const Color(0xFFD97706)
                                : Colors.black45,
                            size: 22,
                          ),
                          tooltip: item.isBookmarked
                              ? 'Tanda Tersimpan'
                              : 'Tandai Ayat Ini',
                          onPressed: () => bookmark(item),
                        ),

                        // Salin
                        IconButton(
                          icon: const Icon(
                            Icons.copy_rounded,
                            color: Colors.black45,
                            size: 19,
                          ),
                          tooltip: 'Salin Ayat',
                          onPressed: () => _copyAyat(item),
                        ),

                        // Bagikan
                        IconButton(
                          icon: const Icon(
                            Icons.share_outlined,
                            color: Colors.black45,
                            size: 19,
                          ),
                          tooltip: 'Bagikan',
                          onPressed: () {
                            final namaSurah = detail['nama'] ?? '';
                            final arabText = item.madinah.isNotEmpty
                                ? item.madinah
                                : item.arab;
                            SharePlus.instance.share(
                              ShareParams(
                                text:
                                    '$arabText\n\n${item.arti}\n\n(QS. $namaSurah : ${item.ayat})',
                                subject: 'QS. $namaSurah : ${item.ayat}',
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Teks Arab
                Text(
                  item.madinah.isNotEmpty ? item.madinah : item.arab,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: GoogleFonts.amiriQuran().fontFamily,
                    fontSize: uiSettings.arabicFontSize,
                    fontWeight: FontWeight.bold,
                    height: 2.0,
                    color: const Color(0xFF1E293B),
                  ),
                ),

                // Transliterasi Latin
                if (uiSettings.showLatin && item.latin.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Text(
                    item.latin,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: uiSettings.translationFontSize,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF048C7C),
                      height: 1.4,
                    ),
                  ),
                ],

                // Terjemahan Bahasa Indonesia
                if (uiSettings.showTranslation && item.arti.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.arti,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: uiSettings.translationFontSize,
                      color: const Color(0xFF334155),
                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _highlightTimer?.cancel();
    _indexSubscription?.cancel();
    _stateSubscription?.cancel();
    tabController?.dispose();
    pageController?.dispose();
    player.dispose();
    super.dispose();
  }
}
