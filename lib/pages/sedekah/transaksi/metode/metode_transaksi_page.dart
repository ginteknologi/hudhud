import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/metode/metode_transaksi_controller.dart';

class MetodeTransaksiSedekahPage extends StatefulWidget {
  const MetodeTransaksiSedekahPage({super.key});

  @override
  State<MetodeTransaksiSedekahPage> createState() =>
      _MetodeTransaksiSedekahPageState();
}

class _MetodeTransaksiSedekahPageState
    extends State<MetodeTransaksiSedekahPage> {
  layout(MetodeTransaksiController ctrl, BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pembayaran E-Wallet",
                        textAlign: TextAlign.left,
                        style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: List.generate(ctrl.dataBillProduct['ewallet'].length,(index) {
                        final getInfo = ctrl.dataBillProduct['ewallet'][index];
                        return Column(
                          children: [
                            RadioListTile(
                              dense: true,
                              controlAffinity: ListTileControlAffinity.trailing,
                              tileColor:
                                  Theme.of(context).colorScheme.background,
                              title: Row(
                                children: [
                                  Image.network(
                                    getInfo['data']['img'],
                                    fit: BoxFit.fitHeight,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(getInfo['data']['name'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1,
                                          ))
                                ],
                              ),
                              value: getInfo['_id'].toString(),
                              groupValue: ctrl.inputPembayaran.value,
                              onChanged: (String? value) {
                                setState(() {
                                  ctrl.inputTypeBayar.value = 'ewallet';
                                  ctrl.dataMetodeBayar.value = getInfo['data'];
                                  ctrl.inputPembayaran.value = value.toString();
                                });
                              },
                            ),
                            if (ctrl.dataBillProduct['bank'].length != index + 1)
                              const Divider(),
                          ],
                        );
                      }),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "*minimal pembayaran Rp. 1.000",
                        textAlign: TextAlign.left,
                        style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pembayaran Virtual Account",
                        textAlign: TextAlign.left,
                        style: context.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: List.generate(
                          ctrl.dataBillProduct['bank'].length, (index) {
                        final getInfo = ctrl.dataBillProduct['bank'][index];
                        return Column(
                          children: [
                            RadioListTile(
                              dense: true,
                              controlAffinity: ListTileControlAffinity.trailing,
                              tileColor:
                                  Theme.of(context).colorScheme.background,
                              title: Row(
                                children: [
                                  Image.network(
                                    getInfo['data']['img'],
                                    fit: BoxFit.fitHeight,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(getInfo['data']['name'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 1,
                                          ))
                                ],
                              ),
                              value: getInfo['_id'].toString(),
                              groupValue: ctrl.inputPembayaran.value,
                              onChanged: (String? value) {
                                setState(() {
                                  ctrl.inputTypeBayar.value = 'va';
                                  ctrl.dataMetodeBayar.value = getInfo['data'];
                                  ctrl.inputPembayaran.value = value.toString();
                                });
                              },
                            ),
                            if (ctrl.dataBillProduct['bank'].length != index + 1)
                              const Divider(),
                          ],
                        );
                      }),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "*minimal pembayaran Rp. 25.000",
                        textAlign: TextAlign.left,
                        style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )
              )
            )
          );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(MetodeTransaksiController());
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Metode Pembayaran", context: context, elevation: 0),
        body: Obx(() => ctrl.isLoading.value ? const Text("Loading") : layout(ctrl, context)),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: SizedBox(
              width: Get.width,
              child: ButtonElevated(
                title: 'Bayar Sekarang',
                width: Get.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  ctrl.goToNextPage(ctrl.inputPembayaran.value);
                },
              ),
            ),
          )
        ]);
  }
}
