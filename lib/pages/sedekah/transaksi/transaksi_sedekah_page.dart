import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/input/InputText.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/pages/sedekah/transaksi/transaksi_sedekah_controller.dart';

class TransaksiSedekahPage extends StatelessWidget {
  const TransaksiSedekahPage({super.key});

  layout(TransactionSedekahController ctrl, BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: ctrl.inputKey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 21, right: 21),
                  child: Column(
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
                          child: Obx(() {
                            return SizedBox(
                                width: Get.width,
                                // height: Get.height / 7,
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AutoSizeText(
                                          ctrl.list['judul'].toString(),
                                          maxLines: 1,
                                          style: context.textTheme.titleMedium
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        AutoSizeText(
                                          ctrl.list['subjudul'].toString(),
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
                                    )));
                          }) //SizedBox
                          ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pilih Nominal Sedekah",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      getListDenom(ctrl, context),
                      // Wrap(
                      //   spacing: 10,
                      //   children: ctrl.denom
                      //       .asMap()
                      //       .keys
                      //       .toList()
                      //       .map((e) => Obx(() => ChoiceChip(
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.circular(10),
                      //                 side: BorderSide(
                      //                     width: 1, color: Colors.black12)),
                      //             selected: ctrl.denomSelected[e].value,
                      //             label: Text(
                      //               ctrl.denom[e]['label'],
                      //               style: TextStyle(
                      //                   color: ctrl.denomSelected[e].value
                      //                       ? Colors.white
                      //                       : Colors.black),
                      //             ),
                      //             labelPadding:
                      //                 EdgeInsets.symmetric(horizontal: 10),
                      //             labelStyle: TextStyle(
                      //                 color: Colors.grey[300],
                      //                 fontWeight: FontWeight.w500),
                      //             backgroundColor: Colors.transparent,
                      //             pressElevation: 1,
                      //             selectedColor: Theme.of(context).primaryColor,
                      //             padding: EdgeInsets.all(8),
                      //             onSelected: (selected) {
                      //               var idxBefore = ctrl.denomSelected
                      //                   .indexWhere((e) => e.value == true);
                      //               if (e == idxBefore) {
                      //                 ctrl.denomSelected[e].value =
                      //                     !ctrl.denomSelected[e].value;
                      //                 return;
                      //               } else {
                      //                 for (RxBool b in ctrl.denomSelected) {
                      //                   if (b.isTrue) b.value = false;
                      //                 }
                      //               }

                      //               ctrl.denomSelected[e].value =
                      //                   !ctrl.denomSelected[e].value;
                      //             },
                      //           )))
                      //       .toList(),
                      // ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Atau Masukkan Nominal",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                            ),
                          ),
                          InputText(
                            controller: ctrl.inputNominal,
                            labelPosition: "none",
                            placeholder: "Rp. ",
                            isFill: true,
                            inputAction: TextInputAction.next,
                            inputType: TextInputType.number,
                            inputStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                            placeholderStyle: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                            onSubmit: (newValue) {
                              FocusScope.of(context).nextFocus();
                            },
                            onEditingComplete: () {},
                            onChanged: (newValue) {},
                            validator: (newValue) {
                              if (newValue!.isEmpty) {
                                return "Mohon untuk diisi.";
                              } else if (ctrl.inputNominal.numberValue < 1000) {
                                return "Nominal kurang dari Rp. 1.000,-";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Lengkapi Data",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                            ),
                          ),
                          InputText(
                            enabled: !ctrl.isLogin.value,
                            controller: ctrl.inputEmail,
                            labelPosition: "none",
                            placeholder: "Email",
                            isFill: true,
                            placeholderStyle:
                                Theme.of(context).textTheme.bodyMedium,
                            inputAction: TextInputAction.next,
                            onSubmit: (newValue) {
                              FocusScope.of(context).nextFocus();
                            },
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
                            enabled: !ctrl.isLogin.value,
                            controller: ctrl.inputNama,
                            labelPosition: "none",
                            placeholder: "Nama Lengkap",
                            isFill: true,
                            placeholderStyle:
                                Theme.of(context).textTheme.bodyMedium,
                            inputAction: TextInputAction.next,
                            onSubmit: (newValue) {
                              FocusScope.of(context).nextFocus();
                            },
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
                            controller: ctrl.inputNomor,
                            labelPosition: "none",
                            placeholder: "Nomor Handphone Aktif",
                            isFill: true,
                            inputType: TextInputType.number,
                            placeholderStyle:
                                Theme.of(context).textTheme.bodyMedium,
                            inputAction: TextInputAction.next,
                            onSubmit: (newValue) {
                              FocusScope.of(context).nextFocus();
                            },
                            onEditingComplete: () {},
                            onChanged: (newValue) {},
                            validator: (newValue) {
                              if (newValue!.isEmpty) {
                                return "Mohon untuk diisi.";
                              } else if (!newValue.isPhoneNumber) {
                                return "Hanya diisi nomor handphone dengan benar.";
                              }
                              return null;
                            },
                          ),
                          InputText(
                            labelPosition: "none",
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            placeholder: "Do'a Anda",
                            placeholderStyle:
                                Theme.of(context).textTheme.bodyMedium,
                            inputPadding: const EdgeInsets.all(15),
                            multiText: true,
                            maxLine: 5,
                            controller: ctrl.inputPesan,
                            onSubmit: (newValue) {
                              FocusScope.of(context).unfocus();
                            },
                            onEditingComplete: () {},
                            onChanged: (newValue) {},
                            validator: (newValue) {
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
                              value: ctrl.inputAnonymous.value,
                              onChanged: (value) {
                                print(value);
                                ctrl.inputAnonymous.value = value;
                              },
                              activeTrackColor: const Color(0xFF92E3A9),
                              activeColor: Theme.of(context).primaryColor,
                              inactiveThumbColor: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text("Sembunyikan Nama Anda")
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
                ))));
  }

  getListDenom(TransactionSedekahController ctrl, BuildContext context) {
    return SizedBox(
        height: 50,
        width: Get.width,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(ctrl.denom.length, (index) {
              return Container(
                // width: 140,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 3),

                child: Obx(() => ChoiceChip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              width: 1, color: Colors.black12)),
                      selected: ctrl.denomSelected[index].value,
                      label: AutoSizeText(
                        ctrl.denom[index]['label'],
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: ctrl.denomSelected[index].value
                                ? Colors.white
                                : Theme.of(context).primaryColor),
                        // TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     letterSpacing: 1,
                        //     color: ctrl.denomSelected[index].value
                        //         ? Colors.white
                        //         : Theme.of(context).primaryColor),
                        maxLines: 1,
                      ),
                      labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                      labelStyle: TextStyle(
                          color: Colors.grey[300], fontWeight: FontWeight.w500),
                      backgroundColor: Colors.transparent,
                      pressElevation: 1,
                      selectedColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.all(8),
                      onSelected: (selected) {
                        ctrl.setSedekah(ctrl.denom[index]['value']);
                        var idxBefore = ctrl.denomSelected
                            .indexWhere((e) => e.value == true);
                        if (index == idxBefore) {
                          ctrl.denomSelected[index].value =
                              !ctrl.denomSelected[index].value;
                          return;
                        } else {
                          for (RxBool b in ctrl.denomSelected) {
                            if (b.isTrue) b.value = false;
                          }
                        }

                        ctrl.denomSelected[index].value =
                            !ctrl.denomSelected[index].value;
                      },
                    )),
              );
            })));
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
            child: SizedBox(
              width: Get.width,
              child: ButtonElevated(
                title: 'Lanjut Pembayaran',
                width: Get.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  final result = ctrl.postInput();
                  if (result['code'] == 200) {
                    print('berhasil');
                    ctrl.goToMetode('1');
                  } else {
                    print('gagal');
                  }
                },
              ),
            ),
          )
        ]);
  }
}
