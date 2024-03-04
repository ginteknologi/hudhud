import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:masjid_app/controllers/kajian_controller.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:url_launcher/url_launcher.dart';

class KajianPage extends StatelessWidget {
  KajianPage({super.key});
  final KajianController ctrl = Get.put(KajianController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: false,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(Get.arguments['judul']),
        ),
        body: PagedListView<int, KajianData>.separated(
          pagingController: ctrl.pagingController,
          builderDelegate: PagedChildBuilderDelegate<KajianData>(
            itemBuilder: (context, item, index) {
              return ListTile(
                onTap: () async {
                  final Uri url = Uri.parse(item.link);
                  if (!await launchUrl(url)) {
                    print('Tidak dapat membuka link YouTube.');
                  }
                },
                dense: true,
                title: AutoSizeText(
                  item.judul!,
                  maxLines: 1,
                  presetFontSizes: [Get.width / 30],
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: AutoSizeText("${item.subjudul!}"),
                trailing: Icon(Icons.chevron_right_rounded),
                leading: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(item.image),
                      )),
                ),
              );
            },
          ),
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
              child: Divider(
                color: Colors.black12,
              ),
            );
          },
        )
        // body: Obx(() => ctrl.isLoading.value
        //     ? const Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : layout(context)),
        );
  }
}
