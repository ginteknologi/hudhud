import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/button/outlinebutton.dart';
import 'package:mesjid_app/components/input/InputText.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/status/status_sedekah_controller.dart';
import 'package:mesjid_app/routes/home/index.dart';
import 'package:mesjid_app/routes/onboard/index.dart';
import 'package:mesjid_app/theme.dart';

class StatusTransaksiSedekahPage extends StatelessWidget {
  const StatusTransaksiSedekahPage({super.key});

  layout(StatusSedekahController ctrl, BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: getCurrentLayout(
                    ctrl, context, ctrl.payments['selectedPayment']['type']))));
  }

  Widget getCurrentLayout(
      StatusSedekahController ctrl, BuildContext context, type) {
    if (type == 2) {
      return layoutEwallet(ctrl, context);
    } else {
      return layoutVa(ctrl, context);
    }
  }

  layoutVa(StatusSedekahController ctrl, BuildContext context) {
    return Column(
      children: [
        Card(
            elevation: 0,
            color: const Color(0xFF92E3A9),
            margin: const EdgeInsets.only(top: 20),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              //set border radius more than 50% of height and width to make circle
            ),
            child: SizedBox(
                width: Get.width,
                height: 90,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Batas Waktu Pembayaran",
                          style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          "Senin, 13 September 2023, 10 : 10",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.fontSize,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                        // Flexible(
                        //     flex: 1,
                        //     child: Container(
                        //       constraints:
                        //           BoxConstraints.loose(Size.infinite),
                        //     )),
                      ],
                    ))) //SizedBox
            ),
        const SizedBox(
          height: 20,
        ),
        ListItemUiWidget(
          id: 1,
          title: ctrl.payments['selectedPayment']['label'],
          titleStyle: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          category: "Metode Pembayaran",
          hasRightContent: true,
          showIcon: IconPosition.right,
          iconRight: Image.asset(
            ctrl.payments['selectedPayment']['image'],
            fit: BoxFit.fitHeight,
            width: MediaQuery.of(context).size.width * 0.2,
          ),
        ),
        ListItemUiWidget(
          id: 2,
          title: "131003140303101020",
          titleStyle: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          category: "Nomor Virtual Account",
          hasRightContent: true,
          showIcon: IconPosition.right,
          iconRight: const Icon(Icons.copy),
        ),
        ListItemUiWidget(
          id: 3,
          title: priceFormat.format(50000),
          titleStyle: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          category: "Donasimu",
          hasRightContent: true,
          showIcon: IconPosition.right,
          iconRight: const Icon(Icons.copy),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: ButtonOutline(
              justify: true,
              onPressed: () {},
              radius: 5,
              showIcon: "right",
              iconRight: const Icon(Icons.chevron_right_rounded),
              title: "Intruksi Pembayaran",
              width: Get.width,
              height: 60,
              shadow: false,
            ))
      ],
    );
  }

  layoutEwallet(StatusSedekahController ctrl, BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Positioned(
        child: Card(
            elevation: 0,
            color: const Color(0xFF0E9889),
            margin: const EdgeInsets.only(top: 20),
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              //set border radius more than 50% of height and width to make circle
            ),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(15),
              height: 220,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Batas Waktu Pembayaran",
                          style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        Text(
                          "Senin, 13 September 2023, 10 : 10",
                          style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ])),
            )),
      ),
      Positioned(
        top: 80,
        child: Card(
            elevation: 0,
            color: Colors.white,
            margin:
                const EdgeInsets.only(top: 19, right: 1, bottom: 1, left: 1),
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              //set border radius more than 50% of height and width to make circle
            ),
            child: Container(
                padding: const EdgeInsets.all(15),
                width: Get.width - 45,
                height: 140,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(right: 13.0),
                            child: const Text(
                              'Menggunakan DANA',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Color(0xFF212121),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Image.asset(
                          ctrl.payments['selectedPayment']['image'],
                          fit: BoxFit.fitHeight,
                          width: MediaQuery.of(context).size.width * 0.2,
                        )
                      ],
                    ),
                    const Divider(
                      color: Colors.black45,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Donasimu",
                              textAlign: TextAlign.start,
                              style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                          Text("Rp. 50.000",
                              style: context.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black)),
                        ],
                      ),
                    )
                  ],
                )) //SizedBox
            ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(StatusSedekahController());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Menunggu Pembayaran", context: context, elevation: 0),
      body: layout(ctrl, context),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 21, right: 21),
          child: Container(
            width: Get.width,
            child: ButtonElevated(
              title: 'Kembali Ke Beranda',
              width: Get.width,
              bgcolor: Theme.of(context).primaryColor,
              height: 45,
              color: Colors.white,
              radius: 5,
              onPressed: () {
                Get.offAllNamed(RoutesHome.root);
              },
            ),
          ),
        )
      ],
    );
  }
}
