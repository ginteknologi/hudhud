import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/button/outlinebutton.dart';
import 'package:mesjid_app/components/input/InputText.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/pages/sedekah/transaksi/transaksi_sedekah_controller.dart';

class TransaksiSedekahPage extends StatelessWidget {
  const TransaksiSedekahPage({super.key});

  layout(TransactionSedekahController ctrl, BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(left: 21, right: 21),
              child: Column(
                children: [
                  Card(
                      elevation: 0,
                      color: Color(0xFF92E3A9),
                      margin: const EdgeInsets.only(top: 20),
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: SizedBox(
                          width: Get.width,
                          height: 120,
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Sedekah Masjid",
                                    style:
                                        context.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AutoSizeText(
                                    "Disalurkan untuk pembiayaan operasional dan pemeliharaan Mesjid An-Ni’mah",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.fontSize,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.normal),
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
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Pilih Nominal Sedekah"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    spacing: 10,
                    children: ctrl.denom
                        .asMap()
                        .keys
                        .toList()
                        .map((e) => Obx(() => ChoiceChip(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      width: 1, color: Colors.black12)),
                              selected: ctrl.denomSelected[e].value,
                              label: Text(
                                ctrl.denom[e]['label'],
                                style: TextStyle(
                                    color: ctrl.denomSelected[e].value
                                        ? Colors.white
                                        : Colors.black),
                              ),
                              labelPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              labelStyle: TextStyle(
                                  color: Colors.grey[300],
                                  fontWeight: FontWeight.w500),
                              backgroundColor: Colors.transparent,
                              pressElevation: 1,
                              selectedColor: Theme.of(context).primaryColor,
                              padding: EdgeInsets.all(8),
                              onSelected: (selected) {
                                var idxBefore = ctrl.denomSelected
                                    .indexWhere((e) => e.value == true);
                                if (e == idxBefore) {
                                  ctrl.denomSelected[e].value =
                                      !ctrl.denomSelected[e].value;
                                  return;
                                } else {
                                  for (RxBool b in ctrl.denomSelected) {
                                    if (b.isTrue) b.value = false;
                                  }
                                }

                                ctrl.denomSelected[e].value =
                                    !ctrl.denomSelected[e].value;
                              },
                            )))
                        .toList(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Atau Masukkan Nominal"),
                      ),
                      InputText(
                        labelPosition: 'none',
                        placeholder: 'Rp. 0',
                        placeholderStyle:
                            Theme.of(context).textTheme.bodyMedium,
                        inputPadding: const EdgeInsets.all(15),
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
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Lengkapi Data"),
                      ),
                      InputText(
                        labelPosition: 'none',
                        margin: EdgeInsets.symmetric(vertical: 5),
                        placeholder: 'Nama Donatur',
                        placeholderStyle:
                            Theme.of(context).textTheme.bodyMedium,
                        inputPadding: const EdgeInsets.all(15),
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
                      ),
                      InputText(
                        labelPosition: 'none',
                        margin: EdgeInsets.symmetric(vertical: 5),
                        placeholder: 'Nomor Handphone',
                        placeholderStyle:
                            Theme.of(context).textTheme.bodyMedium,
                        inputPadding: const EdgeInsets.all(15),
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
                      ),
                      InputText(
                        labelPosition: 'none',
                        margin: EdgeInsets.symmetric(vertical: 5),
                        placeholder: "Do'a Anda",
                        placeholderStyle:
                            Theme.of(context).textTheme.bodyMedium,
                        inputPadding: const EdgeInsets.all(15),
                        multiText: true,
                        maxLine: 5,
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
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Obx(
                        () => Switch(
                          value: ctrl.isHide.value,
                          onChanged: (value) {
                            print(value);
                            ctrl.isHide.value = value;
                          },
                          activeTrackColor: Color(0xFF92E3A9),
                          activeColor: Theme.of(context).primaryColor,
                          inactiveThumbColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Sembunyikan Nama Anda")
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Container(
                  //   width: Get.width,
                  //   child: ButtonElevated(
                  //     title: 'Lanjut Pembayaran',
                  //     width: Get.width,
                  //     bgcolor: Theme.of(context).primaryColor,
                  //     height: 45,
                  //     color: Colors.white,
                  //     radius: 5,
                  //     onPressed: () {
                  //       ctrl.goToMetode('1');
                  //     },
                  //   ),
                  // )
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(TransactionSedekahController());
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Transaksi", context: context, elevation: 0),
        body: layout(ctrl, context),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: Container(
              width: Get.width,
              child: ButtonElevated(
                title: 'Lanjut Pembayaran',
                width: Get.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  ctrl.goToMetode('1');
                },
              ),
            ),
          )
        ]);
  }
}
