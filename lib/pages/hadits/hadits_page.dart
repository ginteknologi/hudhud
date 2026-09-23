import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/hadits_providers.dart';

class HaditsPage extends ConsumerWidget {
  const HaditsPage({super.key});

  SafeArea layout(BuildContext context, List<Map<String, dynamic>> books) {
    return SafeArea(
      top: false,
      child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              // Container(
              //   width: Get.width,
              //   height: 260,
              //   constraints: BoxConstraints.loose(Size.infinite),
              //   clipBehavior: Clip.antiAlias,
              //   decoration: const BoxDecoration(
              //       borderRadius: BorderRadius.only(
              //           bottomLeft: Radius.circular(15),
              //           bottomRight: Radius.circular(15)),
              //       gradient: LinearGradient(
              //           begin: Alignment.bottomLeft,
              //           end: Alignment.topRight,
              //           colors: [
              //             Color(0xFF137065),
              //             Color(0xFF4CB4A7),
              //           ])),
              //   child: Padding(
              //     padding:
              //         EdgeInsets.only(left: 25, right: 25, bottom: 10, top: 40),
              //     child: Column(
              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         Row(
              //           children: [
              //             GestureDetector(
              //                 onTap: () {
              //                   Navigator.of(context)
              //                       .pop(); // Navigate back to the previous page
              //                 },
              //                 child: const Icon(
              //                   Icons.arrow_back_rounded,
              //                   color: Colors.white,
              //                 ))
              //           ],
              //         ),
              //         Row(
              //           children: [
              //             Image.asset(
              //               "assets/img/quran_banner.png",
              //               // height: 85,
              //               width: 160,
              //             ),
              //             Expanded(
              //               child: Column(
              //                 children: [
              //                   Align(
              //                     alignment: Alignment.centerLeft,
              //                     child: AutoSizeText(
              //                       'Kumpulan \nKitab-kitab Hadits',
              //                       style:
              //                           context.textTheme.titleMedium?.copyWith(
              //                         fontWeight: FontWeight.bold,
              //                         color: Colors.white,
              //                       ),
              //                       softWrap: true,
              //                       maxLines: 2,
              //                     ),
              //                   ),
              //                   SizedBox(
              //                     height: 10,
              //                   ),
              //                   AutoSizeText(
              //                     'Bacalah kalian Al-Quran. Karen ia akan datang pada hari kiamat kelak sebagai pemberi syafa’at bagi orang-orang yang rajin membacanya.',
              //                     style: context.textTheme.labelMedium
              //                         ?.copyWith(
              //                             fontWeight: FontWeight.normal,
              //                             color: Colors.white),
              //                     softWrap: true,
              //                     maxLines: 8,
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21),
                  child: Column(
                    children: [
                      dataGrid(context, books),
                    ],
                  )),
              SizedBox(height: 29),
            ],
          )),
    );
  }

  GridView dataGrid(BuildContext context, List<Map<String, dynamic>> books) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: (48 / 90),
        crossAxisCount: 3,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(8), // Sesuaikan dengan kebutuhan Anda
          child: InkWell(
            onTap: () {
              context.push('${AppRoutes.hadits}/${books[index]['namaTabel']}',
                  extra: books[index]);
            },
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.green.withValues(alpha: 0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "assets/icons/${books[index]['longNama']}.png",
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: screenWidth / 80,
                ),
                AutoSizeText(
                  books[index]['longNama'],
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  presetFontSizes: [screenWidth / 35],
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                AutoSizeText(
                  '${books[index]['hadits'].toString()} Hadits',
                  maxLines: 1,
                  presetFontSizes: [screenWidth / 38],
                  style: TextStyle(fontSize: 10),
                ),
                // AutoSizeText(
                //   ctrl.list[index]['longNama'] + 'Hadits',
                //   textAlign: TextAlign.start,
                //   style: TextStyle(
                //     height: 0.5,
                //     fontSize: 10,
                //     color: Colors.black87,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
                // AutoSizeText(
                //   ctrl.list[index]['hadits'].toString(),
                //   textAlign: TextAlign.left,
                //   style: TextStyle(
                //     height: 0.5,
                //     fontSize: 6,
                //     color: Colors.black87,
                //     fontWeight: FontWeight.w300,
                //   ),
                //   maxLines: 1,
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = ref.watch(haditsBooksProvider);
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kitab-kitab Hadits",
        ),
        // backgroundColor: Color(0xFF048C7C),
      ),
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: booksAsync.when(
        data: (books) => layout(context, books),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => layout(context, const []),
      ),
    );
  }
}
