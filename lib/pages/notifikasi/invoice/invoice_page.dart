import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/providers/notifikasi_provider.dart';
import 'package:masjid_app/theme.dart';

class InvoiceNotifikasiPage extends ConsumerWidget {
  const InvoiceNotifikasiPage({super.key});

  SafeArea layout(BuildContext context, Map<String, dynamic> list) {
    final screenWidth = MediaQuery.of(context).size.width;
    final status = list['status'];
    final statusInvoice = status == 'paid'
        ? 'Lunas'
        : status == 'unpaid'
            ? 'Menunggu Pembayaran'
            : 'Dibatalkan';

    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                    padding: const EdgeInsets.only(left: 21, right: 21),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 0,
                          color: Colors.white,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            //set border radius more than 50% of height and width to make circle
                          ),
                          child: Container(
                              width: screenWidth,
                              constraints: BoxConstraints.loose(Size.infinite),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black38),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset(
                                          "assets/icons/app_icon.png",
                                          fit: BoxFit.fitHeight,
                                          width: 60,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "INVOICE",
                                              style: Theme.of(context).textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              statusInvoice,
                                              style: Theme.of(context).textTheme.titleMedium
                                                  ?.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Tanggal: ${DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.parse(list['updatedAt']))}",
                                              style: Theme.of(context).textTheme.labelSmall
                                                  ?.copyWith(
                                                letterSpacing: 0,
                                                color: Colors.black45,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.black38,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Nama  :",
                                              style: Theme.of(context).textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              list['data_sedekah']['name'],
                                              style: Theme.of(context).textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Metode  :",
                                              style: Theme.of(context).textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              list['paymentSelect']
                                                  ['name'],
                                              style: Theme.of(context).textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Jumlah  :",
                                              style: Theme.of(context).textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              priceFormat
                                                  .format(list['nominal']),
                                              style: Theme.of(context).textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Colors.black38,
                                    ),
                                    AutoSizeText(
                                      "CitraGran Cibubur, RT005/011, Jatikarya, Jatisampurna, Bekasi, West Java 17435",
                                      style: Theme.of(context).textTheme.labelSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.w300,
                                              letterSpacing: 0),
                                      maxLines: 2,
                                    )
                                  ],
                                ),
                              )), //SizedBox
                        ),
                      ],
                    )))));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoice = GoRouterState.of(context).pathParameters['invoice'] ?? '';
    final invoiceAsync = ref.watch(invoiceDetailProvider(invoice));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "", context: context, elevation: 0),
      body: invoiceAsync.when(
        data: (list) => layout(context, list),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat invoice: $err')),
      ),
    );
  }
}
