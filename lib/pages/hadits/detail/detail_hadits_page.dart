import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';

class DetailHaditsPage extends ConsumerWidget {
  const DetailHaditsPage({super.key});

  SafeArea layout(
      BuildContext context, Map<String, dynamic> detail, List<ListKitabData> list) {
    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 260,
                  constraints: BoxConstraints.loose(Size.infinite),
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15)),
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xFF137065),
                            Color(0xFF4CB4A7),
                          ])),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, bottom: 30, top: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pop(); // Navigate back to the previous page
                                },
                                child: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: Colors.white,
                                )),
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              detail['longNama'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  height: 1,
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.fontSize,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              maxLines: 1,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "assets/icons/thumb_quran2x.png",
                              width: 103,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  detail['longNama'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      height: 1,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.fontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${detail['hadits']} Hadits',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      height: 1,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.fontSize,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      // Datum model = filteredEvents[index];
                      final kitab = list[index];
                      return FadeInUp(
                        child: ListItemUiWidget(
                          id: kitab.idKitab,
                          title: kitab.kitabIndonesia,
                          onTap: () {
                            if (detail['namaTabel'] == 'arbain') {
                              context.push(
                                  '${AppRoutes.hadits}/${kitab.idKitab}/${kitab.idBab ?? kitab.idKitab}',
                                  extra: {
                                    'content': kitab,
                                    'detail': detail,
                                    'bab': kitab
                                  });
                            } else {
                              context.push('${AppRoutes.hadits}/bab/${kitab.idKitab}',
                                  extra: {'content': kitab, 'detail': detail});
                            }
                          },
                          titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          subTitle: null,
                          showIcon: IconPosition.left,
                          iconLeft: SizedBox(
                            height: 42,
                            width: 42,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  width: 42.0,
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(103, 19, 112, 101),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          kitab.idKitab.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.fontSize,
                                              color: Color(0xFF137065)),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          widthContent: MediaQuery.of(context).size.width * 0.7,
                          // iconLeft: SvgPicture.asset(
                          //     ctrl.listTypesDoa[index]['icon'],
                          //     height: 35,
                          //     width: 35),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeState = GoRouterState.of(context);
    final extra = routeState.extra;
    final detail =
        extra is Map ? Map<String, dynamic>.from(extra) : <String, dynamic>{};
    final namaTabel =
        (detail['namaTabel'] ?? routeState.pathParameters['id'] ?? '').toString();
    final listAsync = ref.watch(haditsDetailProvider(namaTabel));
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: listAsync.when(
        data: (list) => layout(context, detail, list),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => layout(context, detail, const []),
      ),
    );
  }
}
