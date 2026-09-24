import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_card_ayat.dart';
import 'package:masjid_app/providers/quran_ayat_providers.dart';

class DetailAyatQuranPage extends ConsumerStatefulWidget {
  const DetailAyatQuranPage({super.key});

  @override
  ConsumerState<DetailAyatQuranPage> createState() =>
      _DetailAyatQuranPageState();
}

class _DetailAyatQuranPageState extends ConsumerState<DetailAyatQuranPage> {
  String surahId = '';
  String surahName = '';
  bool _routeParamsLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_routeParamsLoaded) return;
    _routeParamsLoaded = true;
    final routeState = GoRouterState.of(context);
    surahId = routeState.pathParameters['id'] ?? '';
    surahName = routeState.uri.queryParameters['nama_surah'] ?? '';
  }

  /// Tandai/batalkan penanda ayat terakhir dibaca — key `perAyatLastRead` sama
  /// seperti versi GetStorage.
  Future<void> bookmark(Map<String, dynamic> selectedData) async {
    final notifier = ref.read(perAyatLastReadProvider.notifier);
    final lastRead = ref.read(perAyatLastReadProvider);
    final ayatNumber = selectedData['number']['inSurah'];
    final updated = Map<String, dynamic>.from(lastRead);
    if (lastRead['ayatNumber'] == ayatNumber) {
      updated['ayatNumber'] = 0;
      updated['suratName'] = '';
      updated['id'] = 0;
    } else {
      updated['ayatNumber'] = ayatNumber;
      updated['suratName'] = surahName;
      updated['id'] = ayatNumber;
    }
    await notifier.save(updated);
  }

  SafeArea layout(Map<String, dynamic> detail, BuildContext context) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: getList(detail, context)),
            )));
  }

  Widget getList(Map<String, dynamic> detail, BuildContext context) {
    final listAyat = List<Map<String, dynamic>>.from(detail['verses'] as List);
    final lastRead = ref.watch(perAyatLastReadProvider);
    final surahBookmarked =
        lastRead['suratName'] == detail['name']['transliteration']['id'];

    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: detail['numberOfVerses'] as int?,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = listAyat[index];
        final isLastRead =
            surahBookmarked && lastRead['ayatNumber'] == item['number']['inSurah'];
        return FadeInUp(
            child: ListCardAyatWidget(
          id: item['number']['inSurah'] as int,
          ayat: item['text']['arab'] as String?,
          descEN: item['text']['transliteration']['en'] as String?,
          descIDN: item['translation']['id'] as String?,
          nomor: item['number']['inSurah'].toString(),
          bookmarked: isLastRead,
          audioFile: item['audio']['primary'] as String?,
          activeColor: isLastRead ? Colors.green[50] : Colors.white,
          onTap: () {
            bookmark(item);
          },
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = surahId.isEmpty
        ? null
        : ref.watch(surahDetailRawProvider(surahId));

    return Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: surahName, context: context, elevation: 0),
        body: detailAsync == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : detailAsync.when(
                data: (detail) => detail.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : layout(detail, context),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, _) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ));
  }
}
