import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/sedekah/detail/detailsedekah_controller.dart';
import 'package:mesjid_app/theme.dart';

class LaporanTab extends StatelessWidget {
  const LaporanTab({super.key});

  layout(DetailSedekahController ctrl, BuildContext context) {
    return SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Card(
                elevation: 1,
                color: Theme.of(context).primaryColor,
                margin: const EdgeInsets.only(top: 20),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  //set border radius more than 50% of height and width to make circle
                ),
                child: SizedBox(
                  height: 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Align(
                          child: Text('Laporan Sedekah',
                            style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            width: Get.width,
                            constraints: BoxConstraints.loose(Size.infinite),
                            decoration: const BoxDecoration(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Sedekah Online',
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black45),
                                      maxLines: 1,
                                    ),
                                    AutoSizeText(
                                      priceFormat.format(ctrl.detail['total_online']),
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Sedekah Offline',
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black45),
                                      maxLines: 1,
                                    ),
                                    AutoSizeText(
                                      priceFormat.format(ctrl.detail['total_offline']),
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total',
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black45),
                                      maxLines: 1,
                                    ),
                                    AutoSizeText(
                                      priceFormat
                                          .format(ctrl.detail['total']),
                                      style: context.textTheme.titleMedium
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black),
                                      maxLines: 1,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              getList(ctrl, context),
              const SizedBox(
                height: 20,
              ),
            ]));
  }

  getList(DetailSedekahController ctrl, BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: ctrl.listPenyaluran.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        // Datum model = filteredEvents[index];
        return FadeInUp(
          child: Card(
            borderOnForeground: false,
            elevation: 0,
            color: Colors.white,
            margin: const EdgeInsets.only(top: 20),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
              //set border radius more than 50% of height and width to make circle
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              constraints: BoxConstraints.loose(Size.infinite),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black38)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('•   ${DateFormat('dd MMMM yyyy').format(DateTime.parse(ctrl.listPenyaluran[index]['tanggal']))}',
                      style: context.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                  const Divider(
                    color: Colors.black45,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: AutoSizeText(ctrl.listPenyaluran[index]['judul'],
                            style: context.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                height: 0),
                            maxLines: 4,
                          ),
                        ),
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
                              constraints: BoxConstraints.loose(Size.infinite),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xFF22CDBB),
                                      Color(0xFF048C7C)
                                    ]),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dana Tersalurkan',
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.white),
                                      maxLines: 1,
                                    ),
                                    AutoSizeText(
                                      priceFormat.format(ctrl.listPenyaluran[index]['dana_tersalurkan']),
                                      style: context.textTheme.titleLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              )), //SizedBox
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(ctrl.listPenyaluran[index]['isi'],
                          style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w300, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Image.network(ctrl.listPenyaluran[index]['image'],
                          width: Get.width,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DetailSedekahController());
    return layout(ctrl, context);
  }
}
