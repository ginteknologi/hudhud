import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/input/input_text.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/sedekah_provider.dart';

/// Port of the GetX `String.isPhoneNumber` helper that this form used before.
bool _isPhoneNumber(String s) {
  if (s.length > 16 || s.length < 9) return false;
  return RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$').hasMatch(s);
}

class TransaksiSedekahPage extends ConsumerStatefulWidget {
  const TransaksiSedekahPage({super.key});

  @override
  ConsumerState<TransaksiSedekahPage> createState() =>
      _TransaksiSedekahPageState();
}

class _TransaksiSedekahPageState extends ConsumerState<TransaksiSedekahPage> {
  final inputKey = GlobalKey<FormState>();

  // The old controller never called loadStorage(), so this stays false and the
  // email/name fields stay enabled.
  bool isLogin = false;
  bool inputAnonymous = false;

  List<Map<String, dynamic>> denom = [];
  late List<bool> denomSelected;

  MoneyMaskedTextController inputNominal = MoneyMaskedTextController(
    decimalSeparator: '',
    thousandSeparator: '.',
    leftSymbol: 'Rp. ',
    rightSymbol: '',
    initialValue: 0,
    precision: 0,
  );
  TextEditingController inputNama = TextEditingController();
  TextEditingController inputNomor = TextEditingController();
  TextEditingController inputEmail = TextEditingController();
  TextEditingController inputPesan = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDenom();
  }

  @override
  void dispose() {
    inputNominal.dispose();
    inputNama.dispose();
    inputNomor.dispose();
    inputEmail.dispose();
    inputPesan.dispose();
    super.dispose();
  }

  void setSedekah(dynamic nominal) {
    inputNominal.text = nominal;
  }

  List<Map<String, dynamic>> getDenom() {
    denom = [
      {"id": 1, "label": "Rp. 10.000", "value": "10000"},
      {"id": 2, "label": "Rp. 50.000", "value": "50000"},
      {"id": 3, "label": "Rp. 100.000", "value": "100000"},
    ];
    denomSelected = List.generate(denom.length, (index) => false);
    return denom;
  }

  /// Writes the payment payload under the same storage key the metode/payment
  /// pages read. Returns true when the form validates.
  bool postInput(Map<String, dynamic> detail) {
    if (inputKey.currentState!.validate()) {
      writeInputPembayaran({
        "nominal": inputNominal.numberValue,
        'nama': inputNama.text,
        'email': inputEmail.text, // ganti sama email login
        'nomor': inputNomor.text,
        'anonim': inputAnonymous,
        'pesan': inputPesan.text,
        'id_campaign': detail['id'],
      });
      return true;
    }
    return false;
  }

  SafeArea layout(Map<String, dynamic> detail, String id, BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: inputKey,
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
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              // height: Get.height / 7,
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        detail['judul'].toString(),
                                        maxLines: 1,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      AutoSizeText(
                                        detail['subjudul'].toString(),
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
                                  )))),
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
                      getListDenom(context),
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
                            controller: inputNominal,
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
                              } else if (inputNominal.numberValue < 1000) {
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
                            enabled: !isLogin,
                            controller: inputEmail,
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
                            enabled: !isLogin,
                            controller: inputNama,
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
                            controller: inputNomor,
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
                              } else if (!_isPhoneNumber(newValue)) {
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
                            controller: inputPesan,
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
                          Switch(
                            value: inputAnonymous,
                            onChanged: (value) {
                              setState(() {
                                inputAnonymous = value;
                              });
                            },
                            activeTrackColor: const Color(0xFF92E3A9),
                            activeThumbColor: Theme.of(context).primaryColor,
                            inactiveThumbColor: Colors.white,
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

  SizedBox getListDenom(BuildContext context) {
    return SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(denom.length, (index) {
              return Container(
                // width: 140,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 3),

                child: ChoiceChip(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                              width: 1, color: Colors.black12)),
                      selected: denomSelected[index],
                      label: AutoSizeText(
                        denom[index]['label'],
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            color: denomSelected[index]
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
                        setSedekah(denom[index]['value']);
                        var idxBefore =
                            denomSelected.indexWhere((e) => e == true);
                        if (index == idxBefore) {
                          setState(() {
                            denomSelected[index] = !denomSelected[index];
                          });
                          return;
                        } else {
                          for (var i = 0; i < denomSelected.length; i++) {
                            if (denomSelected[i]) denomSelected[i] = false;
                          }
                        }

                        setState(() {
                          denomSelected[index] = !denomSelected[index];
                        });
                      },
                    ),
              );
            })));
  }

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id'] ?? '';
    final detail = ref.watch(campaignDetailProvider(id)).valueOrNull ??
        <String, dynamic>{};

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Transaksi", context: context, elevation: 0),
        body: layout(detail, id, context),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ButtonElevated(
                title: 'Lanjut Pembayaran',
                width: MediaQuery.of(context).size.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  if (postInput(detail)) {
                    context.push('${AppRoutes.sedekah}/$id/transaksi/metode');
                  }
                },
              ),
            ),
          )
        ]);
  }
}
