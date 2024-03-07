import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:masjid_app/controllers/dkm_controller.dart';
import 'package:masjid_app/controllers/quote_controller.dart';
import 'package:masjid_app/models/kajianData.dart';
import 'package:url_launcher/url_launcher.dart';

class QuotePage extends StatelessWidget {
  QuotePage({super.key});
  final QuoteController ctrl = Get.put(QuoteController());
  final DkmController dctrl = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("Quote / Kutipan"),
        ),
        body: PagedListView<int, KajianData>.separated(
          shrinkWrap: false,
          physics: const BouncingScrollPhysics(),
          pagingController: ctrl.pagingController,
          builderDelegate: PagedChildBuilderDelegate<KajianData>(
            itemBuilder: (context, item, index) {
              return GestureDetector(
                onTap: () {
                  dctrl.share(item);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: Get.width / 30,
                    vertical: Get.width / 50,
                  ),
                  width: Get.width,
                  height: Get.width / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      image: DecorationImage(
                        alignment: Alignment.topCenter,
                        fit: BoxFit.fitWidth,
                        image: CachedNetworkImageProvider(item.image),
                      )),
                ),
              );
            },
          ),
          separatorBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width / 20),
              child: Divider(
                color: Colors.black12,
              ),
            );
          },
        ));
  }
}
