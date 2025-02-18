import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_card_ui.dart';
import 'package:masjid_app/configs/fileSetup.dart';
import 'package:masjid_app/pages/artikel/detail/detail_artikel_controller.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share_plus/share_plus.dart';
import 'package:masjid_app/routes/artikel/index.dart';

class DetailArtikelPage extends StatelessWidget {
  final DetailArtikelController ctrl = Get.put(DetailArtikelController());

  layout(DetailArtikelController ctrl, BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width / 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                          elevation: 0,
                          color: const Color(0xFFF5F5F5),
                          margin: const EdgeInsets.only(top: 20),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            //set border radius more than 50% of height and width to make circle
                          ),
                          child: Container(
                            width: Get.width,
                            height: 170,
                            constraints: BoxConstraints.loose(Size.infinite),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        NetworkImage(ctrl.detail.value.image),
                                    fit: BoxFit.cover)),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5),
                        child: Text(
                          ctrl.detail.value.category_artikel?['name'] ?? '',
                          style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 12),
                        ),
                      ),
                      AutoSizeText(
                        ctrl.detail.value.judul,
                        style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        maxLines: 4,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          DateFormat('HH:mm | dd MMMM yyyy').format(
                              DateTime.parse(ctrl.detail.value.updatedAt)
                                  .add(Duration(hours: 7))),
                          // '17:40' +
                          //     "  |  " +
                          //     '17 Agustus 2023',
                          style: context.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0,
                              color: Colors.black)),
                      const SizedBox(
                        height: 20,
                      ),
                      Html(
                        data: (ctrl.detail.value.isi ?? '')
                            .replaceAllMapped(
                                RegExp(r'\n{2,}'), (match) => '\n')
                            .replaceAll('<br><br>', '<br>')
                            .replaceAll('<p></p>', '')
                            .trim(),
                        style: {
                          'body': Style(
                              margin: Margins.zero, padding: HtmlPaddings.zero),
                          'h2': Style(
                              fontSize: FontSize(18.0),
                              fontWeight: FontWeight.bold,
                              margin: Margins.zero),
                          'h3': Style(
                              fontSize: FontSize(18.0),
                              fontWeight: FontWeight.bold,
                              margin: Margins.zero),
                          'p': Style(
                              fontSize: FontSize.medium,
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                              lineHeight: LineHeight(1.2),
                              textAlign: TextAlign.justify),
                          'br': Style(margin: Margins.only(bottom: 1)),
                          'b': Style(
                            fontWeight: FontWeight.bold,
                          ),
                          'i': Style(
                            fontStyle: FontStyle.italic,
                          ),
                          'a': Style(
                            color: Colors.blue,
                          ),
                        },
                      ),
                      // Text(
                      //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer fringilla libero a turpis viverra vehicula. Sed ac pellentesque ligula, ac pharetra justo. Donec ut erat vitae tortor accumsan convallis. Aenean ornare commodo purus sed semper. Sed fermentum et mi ac condimentum. Etiam sed sagittis ex, in imperdiet urna. Cras iaculis ante et purus molestie lacinia. Mauris id dolor et velit tempus imperdiet sit amet vel arcu. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Vivamus interdum venenatis quam. Fusce ullamcorper at arcu ut placerat. Nulla",
                      //     style: context.textTheme.bodySmall?.copyWith(
                      //         fontWeight: FontWeight.normal,
                      //         letterSpacing: 0,
                      //         color: Colors.black)),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        color: Colors.black38,
                      ),
                      Container(
                        // height: 53,
                        width: Get.width,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.only(right: 13.0),
                                child: AutoSizeText("Yuk ingetin yang lain!",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .labelLarge
                                            ?.fontSize,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                            Flexible(
                              child: SizedBox(
                                width: double.infinity,
                                child: ButtonElevated(
                                  title: 'Bagikan',
                                  width: Get.width,
                                  bgcolor: const Color(0xFF92E3A9),
                                  height: 35,
                                  color: Colors.black,
                                  radius: 5,
                                  size: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.fontSize,
                                  showIcon: "right",
                                  iconRight: Icon(
                                    Icons.share,
                                    size: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.fontSize,
                                  ),
                                  onPressed: () async {
                                    final result = await downloadAndSaveFile(
                                      url: ctrl.detail.value.image,
                                      pathsave: '/artikel',
                                    );
                                    final resultshare = await Share.shareXFiles(
                                        [XFile(result)],
                                        text: ctrl.share.value,
                                        subject: ctrl.detail.value.judul);

                                    if (resultshare.status ==
                                        ShareResultStatus.success) {
                                      Fluttertoast.showToast(
                                          msg: "Berhasil dishare");
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.black38,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Artikel Lainnya",
                        style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      getListArtikel(ctrl, context),
                      SizedBox(
                        height: 20,
                      )
                    ]))));
  }

  getListArtikel(DetailArtikelController ctrl, BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: ctrl.listArtikels.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Datum model = filteredEvents[index];
        return FadeInUp(
          child: ListCardUiWidget(
            id: ctrl.listArtikels[index].id,
            title: ctrl.listArtikels[index].judul,
            position: MainAxisAlignment.end,
            usingDivider: false,
            height: 170,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(ctrl.listArtikels[index].image),
                    fit: BoxFit.cover)),
            titleStyle: context.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            marginSeparator: 0,
            subtitleStyle: context.textTheme.labelMedium
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black45),
            onTap: () {
              Get.delete<DetailArtikelController>();
              Get.toNamed(
                  '${RoutesArtikel.root}/${ctrl.listArtikels[index].id}');
              // Get.offAllNamed(
              //     '${RoutesArtikel.root}/${ctrl.listArtikels[index].id}');
            },
            hasFooter: true,
            footerContent: [
              Text(
                  DateFormat('HH:mm | dd MMMM yyyy').format(
                      DateTime.parse(ctrl.listArtikels[index].updatedAt)),
                  textAlign: TextAlign.start,
                  style: context.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w300,
                      letterSpacing: 0,
                      color: Colors.white)),
              Row(
                children: [
                  // Icon(
                  //   Icons.remove_red_eye_rounded,
                  //   color: Colors.white,
                  //   size: context.textTheme.labelLarge?.fontSize,
                  // ),
                  const SizedBox(
                    width: 5,
                  ),
                  // Text(ctrl.listArtikels[index]['viewer'],
                  //     textAlign: TextAlign.end,
                  //     style: context.textTheme.labelMedium?.copyWith(
                  //         fontWeight: FontWeight.w300, color: Colors.white)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Artikel Detail", context: context, elevation: 0),
      body: Obx(() => ctrl.isLoadingList.value
          ? Center(child: CircularProgressIndicator())
          : layout(ctrl, context)),
    );
  }
}
