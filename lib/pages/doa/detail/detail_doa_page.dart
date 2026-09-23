import 'package:animate_do/animate_do.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/input/input_text.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_card_ui.dart';
// import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/doa_models.dart';
import 'package:masjid_app/providers/doa_providers.dart';

class DetailDoaPage extends ConsumerStatefulWidget {
  const DetailDoaPage({super.key});

  @override
  ConsumerState<DetailDoaPage> createState() => _DetailDoaPageState();
}

class _DetailDoaPageState extends ConsumerState<DetailDoaPage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  SafeArea layout(BuildContext context, String categoryId,
      AsyncValue<List<DoaItemModel>> listAsync) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, top: 21),
                          child: Column(children: [
                            const SizedBox(height: 20),
                            InputText(
                              suffixIcon: const Icon(Icons.search),
                              labelPosition: 'none',
                              placeholder: 'Cari',
                              radius: 5,
                              isFill: true,
                              fillColor: Colors.white,
                              placeholderStyle:
                                  Theme.of(context).textTheme.bodyMedium,
                              inputPadding: const EdgeInsets.all(15),
                              controller: _searchController,
                              onSubmit: (newValue) {},
                              onEditingComplete: () {},
                              onChanged: (newValue) {
                                setState(() {
                                  _query = newValue;
                                });
                              },
                              validator: (newValue) {
                                if (newValue!.isEmpty) {
                                  return "Mohon untuk diisi.";
                                }
                                return null;
                              },
                            )
                          ])),
                      listAsync.when(
                          data: (list) => Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 21, right: 21, top: 21),
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        itemCount: list.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          // Datum model = filteredEvents[index];
                                          return FadeInUp(
                                            child: ListCardUiWidget(
                                              type: 'wp',
                                              id: list[index].id,
                                              title: list[index].judul,
                                              titleStyle: Theme.of(context)
                                                  .textTheme.titleSmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                              subtitle: list[index].arti,
                                              subtitleStyle: Theme.of(context)
                                                  .textTheme.labelMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black45),
                                              onTap: () {
                                                context.push(AppRoutes
                                                    .doaContent
                                                    .replaceFirst(
                                                        ':id', categoryId)
                                                    .replaceFirst(
                                                        ':content',
                                                        list[index]
                                                            .id
                                                            .toString()));
                                              },
                                              hasFooter: true,
                                              footerContent: [
                                                // Text(DateFormat('dd MMMM yyyy').format( DateTime.parse(list[index]['date'])),
                                                // style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w300),
                                                // ),

                                                // AutoSizeText(
                                                //   list[index]['isi'],
                                                //   textAlign: TextAlign.end,
                                                //   style: Theme.of(context).textTheme.labelSmall
                                                //       ?.copyWith(
                                                //           fontWeight: FontWeight.bold,
                                                //           letterSpacing: 0,
                                                //           color: Colors.black54),
                                                //   maxLines: 2,
                                                // ),
                                                // Text(list[index]['isi'],
                                                //     textAlign: TextAlign.start,
                                                //     style: context
                                                //         .textTheme.labelSmall
                                                //         ?.copyWith(
                                                //             fontWeight:
                                                //                 FontWeight.bold,
                                                //             letterSpacing: 0,
                                                //             color: Colors.black54)),
                                                const Row(
                                                  children: [
                                                    // Icon(
                                                    //   Icons.remove_red_eye_rounded,
                                                    //   color: Colors.black54,
                                                    //   size: Theme.of(context).textTheme
                                                    //       .labelLarge?.fontSize,
                                                    // ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    // Text(
                                                    //     ctrl.listDoa[index]['viewer'],
                                                    //     textAlign: TextAlign.end,
                                                    //     style: context
                                                    //         .textTheme.labelMedium
                                                    //         ?.copyWith(
                                                    //             fontWeight:
                                                    //                 FontWeight.w300,
                                                    //             color:
                                                    //                 Colors.black54)),
                                                  ],
                                                )
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  )),
                              ),
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, __) => const SizedBox.shrink())
                    ]))));
  }

  @override
  Widget build(BuildContext context) {
    final categoryId = GoRouterState.of(context).pathParameters['id'] ?? '';
    final listAsync = ref.watch(doaListProvider(
        DoaListParams(categoryId: categoryId, query: _query)));

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Do'a > Do'a Harian", context: context, elevation: 0),
        body: layout(context, categoryId, listAsync));
  }
}
