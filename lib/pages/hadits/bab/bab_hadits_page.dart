import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';

class BabHaditsPage extends ConsumerWidget {
  const BabHaditsPage({super.key});

  SafeArea layout(BuildContext context, Map<String, dynamic> detail,
      ListKitabData? content, List<ListBabData> list) {
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
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  content?.kitabIndonesia ?? '',
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
                                  'Bab ${content?.idKitab}',
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
                      final bab = list[index];
                      return FadeInUp(
                        child: ListItemUiWidget(
                          id: bab.idBab,
                          title: bab.babIndonesia,
                          onTap: () {
                            context.push(
                                '${AppRoutes.hadits}/${content?.idKitab}/${bab.idBab}',
                                extra: {
                                  'content': content,
                                  'detail': detail,
                                  'bab': bab,
                                  'babIndonesia': bab.babIndonesia
                                });
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
                                          bab.idBab.toString(),
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
    final args = extra is Map ? Map<String, dynamic>.from(extra) : <String, dynamic>{};
    final detail = args['detail'] is Map
        ? Map<String, dynamic>.from(args['detail'] as Map)
        : <String, dynamic>{};
    final content =
        args['content'] is ListKitabData ? args['content'] as ListKitabData : null;
    final namaTabel =
        (detail['namaTabel'] ?? '').toString();
    final idKitab =
        content?.idKitab ?? int.tryParse(routeState.pathParameters['id'] ?? '') ?? 0;
    final listAsync = ref.watch(
        haditsBabProvider(HaditsBabParams(namaTabel: namaTabel, idKitab: idKitab)));
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: listAsync.when(
        data: (list) => layout(context, detail, content, list),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => layout(context, detail, content, const []),
      ),
    );
  }
}
