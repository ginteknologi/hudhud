import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_card_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/artikel_data.dart';
import 'package:masjid_app/providers/artikel_provider.dart';

class ArtikelPage extends ConsumerWidget {
  const ArtikelPage({super.key});

  SafeArea layout(BuildContext context, List<ArtikelData> listArtikels) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: Column(children: [
                  // getListCategory(ctrl),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  getListArtikel(listArtikels, context),
                  SizedBox(
                    height: 20,
                  )
                ]))));
  }

  ListView getListArtikel(List<ArtikelData> listArtikels, BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: listArtikels.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Datum model = filteredEvents[index];
        final artikel = listArtikels[index];
        return FadeInUp(
          child: ListCardUiWidget(
            id: artikel.id,
            title: artikel.judul,
            position: MainAxisAlignment.end,
            usingDivider: false,
            height: 170,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(artikel.image), fit: BoxFit.cover)),
            titleStyle: Theme.of(context).textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            marginSeparator: 0,
            subtitleStyle: Theme.of(context).textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black45),
            onTap: () {
              context.push('${AppRoutes.artikel}/${artikel.id}');
            },
            hasFooter: true,
            footerContent: [
              Text(
                  DateFormat('dd MMMM yyyy HH:mm').format(
                      DateTime.parse(artikel.publishDate)
                          .add(Duration(hours: 7))),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0,
                      color: Colors.white)),
              Row(
                children: [
                  // Icon(
                  //   Icons.remove_red_eye_rounded,
                  //   color: Colors.white,
                  //   size: Theme.of(context).textTheme.labelLarge?.fontSize,
                  // ),
                  SizedBox(
                    width: 5,
                  ),
                  // Text(ctrl.listArtikels[index]['viewer'],
                  //     textAlign: TextAlign.end,
                  //     style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  //         fontWeight: FontWeight.w300, color: Colors.white)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artikelAsync = ref.watch(artikelListProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Artikel / Informasi", context: context, elevation: 0),
      body: artikelAsync.when(
        data: (listArtikels) => layout(context, listArtikels),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => layout(context, const []),
      ),
    );
  }
}
