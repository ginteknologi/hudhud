import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/input/InputText.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/paymentEwallet/payment_transaksi_controller.dart';

class PaymentTransaksiSedekahPage extends StatelessWidget {
  const PaymentTransaksiSedekahPage({super.key});

  layout(PaymentTransaksiController ctrl, BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 21, right: 21),
              child: Column(
                children: [
                  Stack(alignment: Alignment.topCenter, children: [
                    Positioned(
                      child: Card(
                          elevation: 0,
                          color: Color(0xFF0E9889),
                          margin: const EdgeInsets.only(top: 20),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            //set border radius more than 50% of height and width to make circle
                          ),
                          child: Container(
                            width: Get.width,
                            padding: EdgeInsets.all(15),
                            height: 350,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text(
                                "Menggunakan DANA",
                                style: context.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          )),
                    ),
                    Positioned(
                      top: 50,
                      child: Card(
                          elevation: 0,
                          color: Color(0xFFF3F3F4),
                          margin: const EdgeInsets.only(top: 20),
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            //set border radius more than 50% of height and width to make circle
                          ),
                          child: Container(
                              padding: EdgeInsets.all(15),
                              width: Get.width - 42,
                              height: 300,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text("Donasimu"),
                                      Text("Rp. 10.000",
                                          style: context.textTheme.headlineSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.black)),
                                    ],
                                  ),
                                  const Divider(
                                    color: Colors.black45,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Tuliskan Nomor DANA anda",
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.black)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "Pastikan nomor yang anda masukan sudah terdaftar dan memiliki dana yang aktif. ",
                                          textAlign: TextAlign.center,
                                          style: context.textTheme.bodySmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InputText(
                                        labelPosition: 'none',
                                        isFill: true,
                                        fillColor: Colors.white,
                                        margin:
                                            EdgeInsets.symmetric(vertical: 5),
                                        placeholder: '08XXXXX',
                                        placeholderStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        inputPadding: const EdgeInsets.all(10),
                                        controller: ctrl.txtController,
                                        onSubmit: (newValue) {},
                                        onEditingComplete: () {},
                                        onChanged: (newValue) {},
                                        validator: (newValue) {
                                          if (newValue!.isEmpty) {
                                            return "Mohon untuk diisi.";
                                          }
                                          return null;
                                        },
                                      )
                                    ],
                                  ),
                                ],
                              )) //SizedBox
                          ),
                    )
                  ]),
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(PaymentTransaksiController());
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Metode Pembayaran", context: context, elevation: 0),
        body: layout(ctrl, context),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: Container(
              width: Get.width,
              child: ButtonElevated(
                title: 'Lanjutkan',
                width: Get.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  ctrl.procceedPayment('1', ctrl.payments['selectedPayment']);
                },
              ),
            ),
          )
        ]);
  }
}
