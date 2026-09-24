import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/button/iconbutton.dart';
import 'package:masjid_app/components/input/input_text.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:masjid_app/models/quran_models.dart';
import 'package:masjid_app/pages/quran/new_quran/alquran_controller.dart';
import 'package:masjid_app/providers/quran_ayat_providers.dart';
import 'package:masjid_app/providers/quran_provider.dart';
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

  final TextEditingController inputAyat = TextEditingController();
  final TextEditingController inputSurah = TextEditingController();
  final GlobalKey<AutoCompleteTextFieldState<String>> autoCompleteKey =
      GlobalKey();

  final List<ItemScrollController> itemScrollController = [];
  final List<Tab> myTabs = [];
  final List<_SurahContent> contentTab = [];
  List<Map<String, dynamic>> list = [];
  Map<String, dynamic> detail = {};

  TabController? tabController;
  PageController? pageController;

  StreamSubscription<int?>? _indexSubscription;
  StreamSubscription<PlayerState>? _stateSubscription;

  bool _started = false;
  bool _useBookmark = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    // Route: /quran/perayat?bookmarks=true (id surah tidak dipakai — pembaca
    // selalu memuat seluruh daftar surah, sama seperti versi GetX).
    _useBookmark =
        GoRouterState.of(context).uri.queryParameters['bookmarks'] == 'true';
    _init();
  }

  Future<void> _init() async {
    await getData();
    if (!mounted || list.isEmpty || myTabs.isEmpty) return;
    setState(() {
      list = list.reversed.toList();
    });
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

  Future<void> prosesPencarian(BuildContext dialogContext) async {
    final ddd = list.indexWhere((element) => element['nama'] == inputSurah.text);
    final getSurah = list.where((p0) => p0['nama'] == inputSurah.text).first;
    final newindex = myTabs.length - ddd - 1;
    await getDetailData(surahId: getSurah['id'] as int);
    if (!mounted) return;
    pageController!.jumpToPage(newindex);
    await Future.delayed(const Duration(milliseconds: 100));
    itemScrollController[newindex].jumpTo(
      index: int.parse(inputAyat.text) - 1,
    );
    if (dialogContext.mounted) {
      Navigator.of(dialogContext).pop();
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
        if (event != null &&
            itemScrollController[targetDataIndex].isAttached) {
          itemScrollController[targetDataIndex].jumpTo(
            index: event,
          );
        }
      });

      await _stateSubscription?.cancel();
      _stateSubscription = player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          isPlaySound = false;
          listAudio = [];
          if (mounted) {
            setState(() {});
          }
        }
      });

      if (mounted) {
        setState(() {
          isPlaySound = true;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('error murotal');
        debugPrint(e.toString());
      }
    }
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

  void showDialogFilter() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, _) {
            inputSurah.text = "";
            inputAyat.text = "";
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xFF189A8C),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7),
                            topRight: Radius.circular(7))),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Color(0xFF189A8C),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Pergi Ke Ayat',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white),
                          ),
                          ButtonIcon(
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                              inputSurah.text = "";
                              inputAyat.text = "";
                            },
                            bgcolor: Colors.transparent,
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 40),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SimpleAutoCompleteTextField(
                            key: autoCompleteKey,
                            controller: inputSurah,
                            suggestions: list
                                .map((e) => e['nama'].toString())
                                .toList(),
                            textChanged: (text) {
                              // Handle when text is changed
                            },
                            textSubmitted: (text) {
                              // Handle when text is submitted
                            },
                            clearOnSubmit: false,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Color(0xFFDCDCDC), width: 1.0),
                              ),
                              fillColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hintText: 'Cari surah',
                              hintStyle: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .color!
                                          .withValues(alpha: .5)),
                              contentPadding: EdgeInsets.all(13),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          InputText(
                            inputType: TextInputType.number,
                            controller: inputAyat,
                            labelPosition: "none",
                            placeholder: "Nomor ayat",
                            isFill: true,
                            placeholderStyle: Theme.of(context).textTheme.bodySmall,
                            inputAction: TextInputAction.next,
                            onSubmit: (newValue) {},
                            onEditingComplete: () {},
                            onChanged: (newValue) {},
                            validator: (newValue) {
                              if (newValue!.isEmpty) {
                                return "Mohon untuk diisi.";
                              }
                              return null;
                            },
                          ),
                        ],
                      )),
                  Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width / 40),
                      decoration: BoxDecoration(
                        color: Color(0xFFDCDCDC),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(7),
                            bottomRight: Radius.circular(7)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ButtonElevated(
                            title: 'Buka Ayat',
                            width: MediaQuery.of(context).size.width / 2.5,
                            size: Theme.of(context).textTheme.bodySmall?.fontSize,
                            bgcolor: Color(0xFF2128C2),
                            height: 30,
                            color: Colors.white,
                            radius: 5,
                            onPressed: () {
                              prosesPencarian(dialogContext);
                            },
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AutoSizeText(
              detail.isEmpty ? "List Ayat : " : detail['nama'],
              textAlign: TextAlign.left,
            ),
            AutoSizeText(
              detail.isEmpty
                  ? "Total Ayat :"
                  : "Jumlah Ayat : ${detail['ayat']}",
              maxLines: 1,
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.normal,
                    color: const Color.fromARGB(255, 173, 41, 41),
                  ),
            )
          ],
        ),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showDialogFilter();
              })
        ],
        elevation: 0,
      ),
      body: isLoadingList
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  decoration:
                      BoxDecoration(color: Color(0xFF048C7C), boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        spreadRadius: 10,
                        blurRadius: 15)
                  ]),
                  child: TabBar(
                    indicator: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.white, width: 3)),
                    ),
                    labelColor: Colors.white,
                    splashBorderRadius: BorderRadius.circular(20),
                    unselectedLabelColor: Color(0xFFD0D0D0),
                    isScrollable: true,
                    controller: tabController,
                    tabs: myTabs.reversed.toList(),
                    onTap: (index) {
                      var newindex = myTabs.length - index - 1;
                      pageController!.animateToPage(
                        newindex,
                        duration: Duration(milliseconds: 10),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(screenWidth / 40),
                  decoration: BoxDecoration(color: Color(0xFF20B3A3)),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (listAudio.isNotEmpty) {
                            if (isPlaySound) {
                              setState(() {
                                isPlaySound = false;
                              });
                              player.pause();
                            } else {
                              setState(() {
                                isPlaySound = true;
                              });
                              player.play();
                            }
                          } else {
                            final getlist = contentTab
                                .where((element) =>
                                    element.idContent == detail['id'])
                                .toList();
                            playMurotal(getlist[0].list[0]);
                          }
                        },
                        icon: Icon(
                          isPlaySound ? Icons.pause : Icons.play_arrow,
                        ),
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: screenWidth / 20,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${detail['nama']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth / 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text("${detail['ayat']} Ayat - ${detail['tipe']} ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth / 30,
                                )),
                          ],
                        ),
                      ),
                      Text("${detail['arab']}",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (index) {
                      var newindex = myTabs.length - index - 1;
                      changeTabIndex(newindex);
                      tabController!.animateTo(
                        newindex,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.ease,
                      );
                    },
                    reverse: true,
                    itemCount: myTabs.length,
                    itemBuilder: (context, index) {
                      final banyakAyat = contentTab[index].list.length;
                      if (isLoadingDetail) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return listAyat(banyakAyat, index,
                          itemScrollController[index]);
                    },
                    controller: pageController,
                  ),
                )
              ],
            ),
    );
  }

  ScrollablePositionedList listAyat(int banyakAyat, int indexPage,
      ItemScrollController itemScrollController) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return ScrollablePositionedList.builder(
        itemScrollController: itemScrollController,
        shrinkWrap: true,
        itemCount: banyakAyat,
        itemBuilder: (context, index) {
          final AyatModel item = contentTab[indexPage].list[index];
          return InkWell(
            onTap: () {
              _showBottomSheet(item);
            },
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Column(children: [
                  Container(
                      color: Color.fromARGB(255, 233, 233, 233),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(screenWidth / 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Stack(
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      'assets/icons/list_star.svg',
                                      alignment: Alignment.center,
                                      height: 35,
                                      width: 35,
                                    ),
                                    Positioned.fill(
                                      child: Center(
                                        child: AutoSizeText(
                                          item.ayat.toString(),
                                          maxLines: 1,
                                          presetFontSizes: [11, 10, 9],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // Baris kedua
                                SizedBox(
                                  height: 42,
                                  width: 42,
                                  child: Stack(
                                    children: [],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              child: Container(
                            padding: EdgeInsets.all(15),
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenHeight / 50,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: AutoSizeText(
                                        item.madinah,
                                        textAlign: TextAlign.end,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                                fontFamily:
                                                    GoogleFonts.amiriQuran()
                                                        .fontFamily,
                                                fontWeight: FontWeight.bold),
                                        maxLines: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      height: screenHeight / 50,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          item.latin,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                                  fontFamily: 'Roboto',
                                                  fontWeight: FontWeight.w300,
                                                  fontStyle: FontStyle.italic),
                                        )),
                                    SizedBox(
                                      height: screenHeight / 50,
                                    ),
                                    Align(
                                        alignment: Alignment.centerLeft,
                                        child: AutoSizeText(
                                          item.arti,
                                          textAlign: TextAlign.start,
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          ))
                        ],
                      )),
                  Divider(
                    color: Color.fromARGB(255, 226, 226, 226),
                    thickness: 3,
                    height: 1,
                  ),
                ]),
                if (item.isBookmarked) ...[
                  Positioned(
                    top: -4,
                    left: screenWidth * 0.12,
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.red,
                      size: screenWidth * 0.09,
                    ),
                  ),
                ]
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    _indexSubscription?.cancel();
    _stateSubscription?.cancel();
    tabController?.dispose();
    pageController?.dispose();
    player.dispose();
    inputAyat.dispose();
    inputSurah.dispose();
    super.dispose();
  }
}
