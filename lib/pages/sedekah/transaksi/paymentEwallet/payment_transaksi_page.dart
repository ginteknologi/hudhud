import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/input/input_text.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/sedekah_provider.dart';
import 'package:masjid_app/theme.dart';

class PaymentTransaksiSedekahPage extends ConsumerStatefulWidget {
  const PaymentTransaksiSedekahPage({super.key});

  @override
  ConsumerState<PaymentTransaksiSedekahPage> createState() =>
      _PaymentTransaksiSedekahPageState();
}

class _PaymentTransaksiSedekahPageState
    extends ConsumerState<PaymentTransaksiSedekahPage> {
  bool isLoading = false;
  Map<String, dynamic> dataBillProduct = {};
  TextEditingController nomorInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    dataBillProduct = readInputPembayaran();
    nomorInput.text = dataBillProduct['nomor']?.toString() ?? '';
  }

  @override
  void dispose() {
    nomorInput.dispose();
    super.dispose();
  }

  Future<void> procceedPayment(String id) async {
    setState(() {
      isLoading = true;
    });
    final success =
        await ref.read(sedekahOrderProvider.notifier).createOrderFromStorage();
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    if (success) {
      context.go('${AppRoutes.sedekah}/$id/transaksi/status');
    }
  }

  SafeArea layout(BuildContext context) {
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
                          color: const Color(0xFF0E9889),
                          margin: const EdgeInsets.only(top: 20),
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            //set border radius more than 50% of height and width to make circle
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.all(15),
                            height: 350,
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text("Menggunakan ${dataBillProduct['dataMetodeBayar']['name']}",
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                          color: const Color(0xFFF3F3F4),
                          margin: const EdgeInsets.only(top: 20),
                          clipBehavior: Clip.antiAlias,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            //set border radius more than 50% of height and width to make circle
                          ),
                          child: Container(
                              padding: const EdgeInsets.all(15),
                              width: MediaQuery.of(context).size.width - 42,
                              height: 300,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Text("Donasimu"),
                                      Text(priceFormat.format(dataBillProduct['nominal']) ,
                                          style: Theme.of(context).textTheme.headlineSmall
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
                                      Text("Tuliskan Nomor ${dataBillProduct['dataMetodeBayar']['name']} anda",
                                          style: Theme.of(context).textTheme.titleMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.w900,
                                                  color: Colors.black)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          "Pastikan nomor yang anda masukan sudah terdaftar dan memiliki dana yang aktif. ",
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.bodySmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black)),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InputText(
                                        labelPosition: 'none',
                                        isFill: true,
                                        fillColor: Colors.white,
                                        margin:
                                            const EdgeInsets.symmetric(vertical: 5),
                                        placeholder: '08XXXXX',
                                        placeholderStyle: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        inputPadding: const EdgeInsets.all(10),
                                        controller: nomorInput,
                                        onSubmit: (newValue) {},
                                        onEditingComplete: () {},
                                        onChanged: (newValue) {
                                          dataBillProduct['phoneovo'] = newValue;
                                        },
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
    final id = GoRouterState.of(context).pathParameters['id'] ?? '';

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Metode Pembayaran", context: context, elevation: 0),
        body: isLoading ? CircularProgressIndicator() : layout(context),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ButtonElevated(
                title: 'Lanjutkan',
                width: MediaQuery.of(context).size.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  procceedPayment(id);
                },
              ),
            ),
          )
        ]);
  }
}
