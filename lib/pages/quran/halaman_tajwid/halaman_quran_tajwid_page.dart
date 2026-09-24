import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/button/iconbutton.dart';
import 'package:masjid_app/components/input/input_text.dart';
import 'package:masjid_app/components/layout/custom_modal_bottom_sheet.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/models/bookmark_data.dart';
import 'package:masjid_app/pages/quran/halaman_tajwid/component/image_viewer_widget.dart';
import 'package:masjid_app/providers/quran_page_providers.dart';
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
  final TextEditingController searchController = TextEditingController();
  final TextEditingController inputFilter = TextEditingController();

  var surahSaatIni = 'Quran Tajwid';
  var halSaatIni = '1';
  var bookmarked = false;
  var selectedJuz = true;
  var isMax = false;
  int toSurat = 0;
  int lastReadHal = 1;
  String _search = '';
  Map<String, dynamic>? _currentPage;

  @override
  void initState() {
    super.initState();
    _restoreLastRead();
  }

  @override
  void dispose() {
    searchController.dispose();
    inputFilter.dispose();
    super.dispose();
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
        surahSaatIni = item['surat'].toString();
        halSaatIni = item['hal'].toString();
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

  /// Pengganti `goToData(item)`: cari surah hasil pencarian di aset halaman.
  void _goToData(dynamic itemData, List<Map<String, dynamic>> listSurah) {
    final matches = listSurah.where((item) =>
        item['surat'].toString().toLowerCase() ==
        itemData['nama'].toString().toLowerCase());
    if (matches.isEmpty) return;
    _setPageFromItem(matches.first);
  }

  /// Pengganti `goToNumber(numbertogo)`: /quran/juz/{id} → `hal` → halaman.
  Future<void> _goToNumber(
      String numbertogo, List<Map<String, dynamic>> listSurah) async {
    final juz = await ref.read(quranJuzPageProvider(numbertogo).future);
    final hal = juz?.hal;
    if (hal == null) return;
    final matches = listSurah.where((item) => item['hal'] == hal);
    if (matches.isEmpty) return;
    _setPageFromItem(matches.first);
  }

  /// Pengganti `goToHal(numbertogo)`: langsung cari nomor halaman di aset.
  void _goToHal(String numbertogo, List<Map<String, dynamic>> listSurah) {
    final matches =
        listSurah.where((item) => item['hal'].toString() == numbertogo);
    if (matches.isEmpty) return;
    _setPageFromItem(matches.first);
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
                    GestureDetector(
                        child: Column(
                      children: [
                        Flexible(
                            child: EasyImageViewPager(
                                onTap: (int index) {
                                  showPopup(listSurah, context);
                                },
                                idxInitial: toSurat > 0 ? toSurat : lastReadHal,
                                lastReadKey: _lastReadKey,
                                onPageChanged: (int index) {
                                  _onPageChanged(index, listSurah);
                                },
                                imageProviders: listSurah)),
                      ],
                    ))
                  ],
                )));
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
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        showDragHandle: false,
        enableDrag: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(0.0),
          ),
        ),
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (BuildContext bc, setModalState) {
            return CustomModalBottomSheet(
              typeSheet: TypeBottomSheet.typeFullscreenSheet,
              content: [
                InputText(
                  suffixIcon: Icon(Icons.search),
                  labelPosition: 'none',
                  placeholder: 'Cari',
                  radius: 5,
                  isFill: true,
                  fillColor: Colors.white,
                  placeholderStyle: Theme.of(context).textTheme.bodyMedium,
                  inputPadding: const EdgeInsets.all(15),
                  controller: searchController,
                  onSubmit: (newValue) {},
                  onEditingComplete: () {},
                  onChanged: (newValue) {
                    setState(() {
                      _search = newValue;
                    });
                    setModalState(() {});
                  },
                  validator: (newValue) {
                    if (newValue!.isEmpty) {
                      return "Mohon untuk diisi.";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                  child: Text(
                    "Surah",
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                SizedBox(
                    height: MediaQuery.of(context).size.height -
                        kBottomNavigationBarHeight -
                        kToolbarHeight -
                        60,
                    child: Consumer(builder: (context, ref, child) {
                      final searchAsync =
                          ref.watch(quranSurahSearchProvider(_search));
                      if (searchAsync.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final results = searchAsync.valueOrNull ?? const [];
                      return ListView.builder(
                        physics: const ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: results.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          var item = results[index];
                          return FadeInUp(
                            child: ListItemUiWidget(
                              showIcon: IconPosition.left,
                              iconLeft: Text(item['id'].toString()),
                              id: item['id'],
                              title: item['nama'],
                              subTitle:
                                  '${item['arti']} - ${item['ayat']} ayat',
                              subtitleStyle: TextStyle(fontSize: 2),
                              onTap: () {
                                _goToData(item, listSurah);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              titleStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            ),
                          );
                        },
                      );
                    }))
              ],
            );
          });
        });
  }

  void showDialogFilter(
      List<Map<String, dynamic>> listSurah, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(builder: (BuildContext bc, setModalState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width - 25,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Color(0xFF189A8C),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7),
                            topRight: Radius.circular(7))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pergi Ke',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                        ),
                        ButtonIcon(
                          onTap: () {
                            Navigator.pop(dialogContext);
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
                  Container(
                      width: MediaQuery.of(context).size.width - 25,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(7),
                              bottomRight: Radius.circular(7))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonElevated(
                                title: 'Juz',
                                width: 120,
                                bgcolor: selectedJuz == true
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).secondaryHeaderColor,
                                height: 30,
                                color: selectedJuz == true
                                    ? Colors.white
                                    : Colors.black,
                                radius: 0,
                                onPressed: () {
                                  setModalState(() {
                                    selectedJuz = !selectedJuz;
                                  });
                                },
                              ),
                              ButtonElevated(
                                title: 'Halaman',
                                width: 120,
                                bgcolor: selectedJuz == false
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).secondaryHeaderColor,
                                height: 30,
                                color: selectedJuz == false
                                    ? Colors.white
                                    : Colors.black,
                                radius: 0,
                                onPressed: () {
                                  setModalState(() {
                                    selectedJuz = !selectedJuz;
                                  });
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: InputText(
                              inputType: TextInputType.number,
                              controller: inputFilter,
                              labelPosition: "none",
                              placeholder:
                                  selectedJuz == true ? "1-30" : "1-604",
                              textAlign: TextAlign.center,
                              isFill: true,
                              placeholderStyle:
                                  Theme.of(context).textTheme.bodyMedium,
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
                          ),
                          isMax != true
                              ? Container()
                              : SizedBox(
                                  width: MediaQuery.of(context).size.width - 25,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      selectedJuz == true
                                          ? Text('Maks Juz 30',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(color: Colors.red))
                                          : Text('Maks Halaman 604',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(color: Colors.red))
                                    ],
                                  ),
                                ),
                          Container(
                            width: MediaQuery.of(context).size.width - 25,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFFDCDCDC),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(7),
                                    bottomRight: Radius.circular(7))),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: selectedJuz
                                    ? [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ButtonElevated(
                                          title: 'Buka Juz',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          size: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.fontSize,
                                          bgcolor: Color(0xFF2128C2),
                                          height: 30,
                                          color: Colors.white,
                                          radius: 5,
                                          onPressed: () {
                                            if (selectedJuz == true) {
                                              final number = int.tryParse(
                                                  inputFilter.text);
                                              if (number == null) return;
                                              if (number > 30) {
                                                setModalState(() {
                                                  isMax = true;
                                                });
                                              } else {
                                                setModalState(() {
                                                  isMax = false;
                                                });
                                                _goToNumber(inputFilter.text,
                                                    listSurah);
                                                Navigator.pop(dialogContext);
                                              }
                                            }
                                          },
                                        ),
                                      ]
                                    : [
                                        SizedBox(
                                          width: 5,
                                        ),
                                        ButtonElevated(
                                          title: 'Buka Halaman',
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.5,
                                          size: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.fontSize,
                                          bgcolor: Color(0xFF2128C2),
                                          height: 30,
                                          color: Colors.white,
                                          radius: 5,
                                          onPressed: () {
                                            if (selectedJuz != true) {
                                              final number = int.tryParse(
                                                  inputFilter.text);
                                              if (number == null) return;
                                              if (number > 604) {
                                                setModalState(() {
                                                  isMax = true;
                                                });
                                              } else {
                                                setModalState(() {
                                                  isMax = false;
                                                });
                                                _goToHal(inputFilter.text,
                                                    listSurah);
                                                Navigator.pop(dialogContext);
                                              }
                                            }
                                          },
                                        ),
                                      ]),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(quranPageListProvider(_asset));
    final listSurah = listAsync.valueOrNull ?? const <Map<String, dynamic>>[];
    final isLoadingList = listAsync.isLoading;

    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, dynamic result) {
          if (didPop) {
            return; // kalau sudah di-pop, tidak perlu lakukan apa-apa lagi
          }
          // Logika yang dijalankan saat tombol kembali ditekan
          context.pop('refresh');
        },
        child: Scaffold(
            backgroundColor: Color(0xFFF5F5F5),
            extendBodyBehindAppBar: false,
            resizeToAvoidBottomInset: false,
            body: layout(listSurah, isLoadingList, context),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              leading: GestureDetector(
                  onTap: () {
                    context.pop('refresh');
                  },
                  child: const Icon(Icons.arrow_back_rounded)),
              backgroundColor: Color(0xFF048C7C),
              elevation: 0,
              title: Align(
                alignment: Alignment.centerLeft,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Colors.white30,
                    onTap: () => {showModal(listSurah, context)},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(surahSaatIni,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.fontSize,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Text("Halaman $halSaatIni",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 0.5,
                                      color: Colors.white)),
                            ]),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.expand_more_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Material(
                    color: Colors.transparent,
                    child: Padding(
                      padding: EdgeInsets.only(right: 21),
                      child: InkWell(
                        onTap: () {
                          showDialogFilter(listSurah, context);
                        },
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.green.withValues(alpha: 0.5),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ))
              ],
            )));
  }
}
