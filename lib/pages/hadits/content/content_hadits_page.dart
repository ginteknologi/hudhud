import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/models/hadist_data.dart';
import 'package:masjid_app/providers/hadits_providers.dart';
import 'package:share_plus/share_plus.dart';

class ContentHaditsPage extends ConsumerStatefulWidget {
  const ContentHaditsPage({super.key});

  @override
  ConsumerState<ContentHaditsPage> createState() => _ContentHaditsPageState();
}

class _ContentHaditsPageState extends ConsumerState<ContentHaditsPage> {
  int _currentIndex = 0;

  SafeArea layout(
      BuildContext context,
      Map<String, dynamic> detail,
      ListKitabData? content,
      String babIndonesia,
      List<ListHadistData> list) {
    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Hadits No. ${list.isNotEmpty ? list[_currentIndex].noHdt : "-"}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            softWrap: true,
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset("assets/icons/book_mark.svg",
                                  height: 20, width: 20),
                              SizedBox(width: 10),
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.6, // Batasi lebar maksimal
                                child: Text(
                                  content?.kitabIndonesia ?? '',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: 2, // Agar tetap rapi
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.6, // Batasi lebar maksimal
                                child: Text(
                                  babIndonesia,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w300,
                                    color: Colors.black,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                  maxLines: 2, // Agar tetap rapi
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _currentIndex > 0
                                    ? () => setState(() => _currentIndex--)
                                    : null,
                                child: Text("Previous"),
                              ),
                              ElevatedButton(
                                onPressed: _currentIndex < list.length - 1
                                    ? () => setState(() => _currentIndex++)
                                    : null,
                                child: Text("Next"),
                              ),
                            ],
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          if (list.isEmpty) return;
                          final hadits = list[_currentIndex];
                          SharePlus.instance.share(ShareParams(
                              text:
                                  "${detail['longNama']}\n\n${content?.kitabIndonesia}\n\n${hadits.isiArab}\n\n${hadits.isiIndonesia} \n\n Dibagikan dari aplikasi\n\n Marbot App",
                              subject: detail['longNama']));
                        },
                        child: Icon(
                          Icons.share,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 5,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 300,
                          child: Text(
                            list.isNotEmpty
                                ? list[_currentIndex].isiArab
                                : "Tidak ada data",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        AutoSizeText(
                          list.isNotEmpty
                              ? list[_currentIndex].isiIndonesia
                              : "Tidak ada data",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            color: Colors.black,
                          ),
                          softWrap: true,
                        ),
                      ],
                    )),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeState = GoRouterState.of(context);
    final extra = routeState.extra;
    final args =
        extra is Map ? Map<String, dynamic>.from(extra) : <String, dynamic>{};
    final detail = args['detail'] is Map
        ? Map<String, dynamic>.from(args['detail'] as Map)
        : <String, dynamic>{};
    final content =
        args['content'] is ListKitabData ? args['content'] as ListKitabData : null;
    final bab =
        args['bab'] is ListBabData ? args['bab'] as ListBabData : null;
    final babIndonesia = (args['babIndonesia'] ?? '').toString();
    final namaTabel = (detail['namaTabel'] ?? '').toString();
    final idKitab =
        content?.idKitab ?? int.tryParse(routeState.pathParameters['id'] ?? '') ?? 0;
    final idBab =
        bab?.idBab ?? int.tryParse(routeState.pathParameters['content'] ?? '');

    final contentAsync = ref.watch(haditsContentProvider(HaditsContentParams(
      namaTabel: namaTabel,
      idKitab: idKitab,
      idBab: idBab,
    )));
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: detail['longNama'] ?? '',
          context: context,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          color: Colors.white,
          titleAlign: Alignment.centerLeft,
          backgroundColor: Color(0xFF048C7C)),
      body: contentAsync.when(
        data: (list) => layout(context, detail, content, babIndonesia, list),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            layout(context, detail, content, babIndonesia, const []),
      ),
    );
  }
}
