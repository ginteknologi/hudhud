import 'package:easy_localization/easy_localization.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/button/outlinebutton.dart';
// import 'package:masjid_app/components/input/InputText.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/sedekah_provider.dart';
// import 'package:masjid_app/routes/onboard/index.dart';
import 'package:masjid_app/theme.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StatusTransaksiSedekahPage extends ConsumerWidget {
  const StatusTransaksiSedekahPage({super.key});

  SafeArea layout(Map<String, dynamic> dataInvoice,
      Map<String, dynamic> dataPayment, BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: getCurrentLayout(dataInvoice, dataPayment, context))));
  }

  Widget getCurrentLayout(Map<String, dynamic> dataInvoice,
      Map<String, dynamic> dataPayment, BuildContext context) {
    if (dataPayment['metode'] == 'va') {
      return layoutVa(dataInvoice, context);
    } else {
      return layoutEwallet(dataInvoice, context);
    }
  }

  Column layoutVa(
      Map<String, dynamic> dataInvoice, BuildContext context) {
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
                width: MediaQuery.of(context).size.width,
                child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Batas Waktu Pembayaran",
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          // "Senin, 13 September 2023, 10 : 10",
                          DateFormat('EEEE, dd MMMM yyyy, HH : mm').format(
                              DateTime.parse(dataInvoice['paymentMethod']
                                  ['expiration_date'])),
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
                    )))),
        const SizedBox(
          height: 20,
        ),
        ListItemUiWidget(
          id: 1,
          title: dataInvoice['databank']['name'],
          titleStyle: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          category: "Metode Pembayaran",
          hasRightContent: true,
          showIcon: IconPosition.right,
          iconRight: Image.network(
            dataInvoice['databank']['img'],
            fit: BoxFit.fitHeight,
            width: MediaQuery.of(context).size.width * 0.2,
          ),
        ),
        ListItemUiWidget(
          id: 2,
          title: dataInvoice['paymentMethod']['account_number'],
          titleStyle: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          category: "Nomor Virtual Account",
          hasRightContent: true,
          showIcon: IconPosition.right,
          iconRight: GestureDetector(
            onTap: () {
              final String accountNumber =
                  dataInvoice['paymentMethod']['account_number'];
              Clipboard.setData(ClipboardData(text: accountNumber));
              Fluttertoast.showToast(
                msg: 'Berhasil disalin',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            child: const Icon(Icons.copy),
          ),
        ),
        ListItemUiWidget(
          id: 3,
          title: priceFormat.format(dataInvoice['detail']['nominal']),
          titleStyle: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              color: Colors.black,
              fontWeight: FontWeight.bold),
          category: "Donasimu",
          hasRightContent: true,
          showIcon: IconPosition.right,
          iconRight: GestureDetector(
            onTap: () {
              final String accountNumber =
                  dataInvoice['detail']['nominal'];
              Clipboard.setData(ClipboardData(text: accountNumber));
              Fluttertoast.showToast(
                msg: 'Berhasil disalin',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
            child: const Icon(Icons.copy),
          ),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: ButtonOutline(
              justify: true,
              onPressed: () {
                context.push(AppRoutes.sedekahInstruksi);
              },
              radius: 5,
              showIcon: "right",
              iconRight: const Icon(Icons.chevron_right_rounded),
              title: "Intruksi Pembayaran",
              width: MediaQuery.of(context).size.width,
              height: 60,
              shadow: false,
            ))
      ],
    );
  }

  Stack layoutEwallet(
      Map<String, dynamic> dataInvoice, BuildContext context) {
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
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(15),
              height: 220,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Berikut pembayaran tagihan anda, Lakukan pembayaran segera",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.normal,
                              color: Colors.white),
                        ),
                        // Text(
                        //   DateFormat('EEEE, dd MMMM yyyy, HH : mm').format(DateTime.parse(ctrl.dataInvoice['paymentMethod']['expiration_date'])),
                        //   style: context.textTheme.titleMedium?.copyWith(
                        //       fontWeight: FontWeight.bold, color: Colors.white),
                        // ),
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
                width: MediaQuery.of(context).size.width - 45,
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
                            child: Text(
                              'Menggunakan ${dataInvoice['databank']['name']}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF212121),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        // Image.asset(
                        //   ctrl.payments['selectedPayment']['image'],
                        //   fit: BoxFit.fitHeight,
                        //   width: MediaQuery.of(context).size.width * 0.2,
                        // )
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
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black)),
                          Text(
                              priceFormat.format(
                                  dataInvoice['detail']['nominal']),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceId = readDataInvoice();
    final dataPayment = readInputPembayaran();
    final dataInvoiceAsync = ref.watch(invoiceDetailProvider(invoiceId));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Menunggu Pembayaran", context: context, elevation: 0),
      body: invoiceId.isEmpty
          ? CircularProgressIndicator()
          : dataInvoiceAsync.when(
              data: (dataInvoice) =>
                  layout(dataInvoice, dataPayment, context),
              loading: () => CircularProgressIndicator(),
              error: (error, stack) =>
                  layout(<String, dynamic>{}, dataPayment, context),
            ),
      persistentFooterButtons: [
        Padding(
          padding: const EdgeInsets.only(left: 21, right: 21),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ButtonElevated(
              title: 'Kembali Ke Beranda',
              width: MediaQuery.of(context).size.width,
              bgcolor: Theme.of(context).primaryColor,
              height: 45,
              color: Colors.white,
              radius: 5,
              onPressed: () {
                context.go(AppRoutes.home);
              },
            ),
          ),
        )
      ],
    );
  }
}
