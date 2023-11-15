import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/sedekah/detail/detailsedekah_controller.dart';
import 'package:mesjid_app/theme.dart';

class DonaturTab extends StatelessWidget {
  const DonaturTab({super.key});
  

  layout(DetailSedekahController ctrl, BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            "${ctrl.listDonatur.length} Donatur",
            style: context.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          Flexible(
              flex: 1,
              child: ListView.builder(
                physics: const ClampingScrollPhysics(),
                itemCount: ctrl.listDonatur.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // Datum model = filteredEvents[index];
                  return FadeInUp(
                    child: ListItemUiWidget(
                      id: ctrl.listDonatur[index]['id'],
                      title: priceFormat.format(ctrl.listDonatur[index]['nominal']),
                      titleStyle: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold),
                      category: ctrl.listDonatur[index]['nama_donatur'].toString(),
                      subTitle: ctrl.listDonatur[index]['ucapan'].toString(),
                      hasRightContent: true,
                      rightContent: [
                        Text(
                             '${DateFormat('dd/MM/yyyy, HH:mm').format(DateTime.parse(ctrl.listDonatur[index]['tanggal']))}, ',
                            style: context.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.normal,
                            ))
                      ],
                    ),
                  );
                },
              ))
        ]);
  }

  @override
  Widget build(BuildContext context) {
    
    final ctrl = Get.put(DetailSedekahController());
    return layout(ctrl, context);
  }
}
