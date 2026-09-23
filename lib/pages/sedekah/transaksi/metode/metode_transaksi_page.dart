import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/sedekah_provider.dart';

class MetodeTransaksiSedekahPage extends ConsumerStatefulWidget {
  const MetodeTransaksiSedekahPage({super.key});

  @override
  ConsumerState<MetodeTransaksiSedekahPage> createState() =>
      _MetodeTransaksiSedekahPageState();
}

class _MetodeTransaksiSedekahPageState
    extends ConsumerState<MetodeTransaksiSedekahPage> {
  bool isLoading = false;
  String inputPembayaran = "";
  String inputTypeBayar = "";
  Map<String, dynamic> dataMetodeBayar = {};

  Future<void> goToNextPage(String id, String paymentId) async {
    final dataBayar = readInputPembayaran();
    dataBayar['idPayment'] = paymentId;
    dataBayar['dataMetodeBayar'] = dataMetodeBayar;
    dataBayar['metode'] = inputTypeBayar;
    await writeInputPembayaran(dataBayar);

    if (inputTypeBayar == 'va') {
      await procceedPayment(id);
    } else {
      if (!mounted) return;
      context.push('${AppRoutes.sedekah}/$id/transaksi/payment');
    }
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

  SafeArea layout(Map<String, dynamic> dataBillProduct, String id,
      BuildContext context) {
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
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: List.generate(
                          dataBillProduct['ewallet'].length, (index) {
                        final getInfo = dataBillProduct['ewallet'][index];
                        return Column(
                          children: [
                            RadioListTile(
                              dense: true,
                              controlAffinity: ListTileControlAffinity.trailing,
                              tileColor:
                                  Theme.of(context).colorScheme.surface,
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
                              groupValue: inputPembayaran,
                              onChanged: (String? value) {
                                setState(() {
                                  inputTypeBayar = 'ewallet';
                                  dataMetodeBayar = getInfo['data'];
                                  inputPembayaran = value.toString();
                                });
                              },
                            ),
                            if (dataBillProduct['bank'].length != index + 1)
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Column(
                      children: List.generate(
                          dataBillProduct['bank'].length, (index) {
                        final getInfo = dataBillProduct['bank'][index];
                        return Column(
                          children: [
                            RadioListTile(
                              dense: true,
                              controlAffinity: ListTileControlAffinity.trailing,
                              tileColor:
                                  Theme.of(context).colorScheme.surface,
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
                              groupValue: inputPembayaran,
                              onChanged: (String? value) {
                                setState(() {
                                  inputTypeBayar = 'va';
                                  dataMetodeBayar = getInfo['data'];
                                  inputPembayaran = value.toString();
                                });
                              },
                            ),
                            if (dataBillProduct['bank'].length != index + 1)
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
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black45),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ))));
  }

  @override
  Widget build(BuildContext context) {
    final id = GoRouterState.of(context).pathParameters['id'] ?? '';
    final dataAsync = ref.watch(paymentChannelProvider);

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Metode Pembayaran", context: context, elevation: 0),
        // body: Obx(() => ctrl.isLoading.value ? CircularProgressIndicator()) : layout(ctrl, context)),
        body: dataAsync.when(
          data: (dataBillProduct) => layout(dataBillProduct, id, context),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) =>
              layout(<String, dynamic>{}, id, context),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ButtonElevated(
                disabled: isLoading,
                title: 'Bayar Sekarang',
                width: MediaQuery.of(context).size.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  goToNextPage(id, inputPembayaran);
                },
              ),
            ),
          )
        ]);
  }
}
