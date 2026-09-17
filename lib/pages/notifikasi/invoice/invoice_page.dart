import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/pages/notifikasi/invoice/invoice_controller.dart';
import 'package:masjid_app/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class InvoiceNotifikasiPage extends StatelessWidget {
  const InvoiceNotifikasiPage({super.key});

  SafeArea layout(BuildContext context, InvoiceController ctrl) {
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
                              width: Get.width,
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
                                              style: context
                                                  .textTheme.titleMedium
                                                  ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(ctrl.status_invoice,
                                              style: context
                                                  .textTheme.titleMedium
                                                  ?.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            AutoSizeText(
                                              "Tanggal: ${DateFormat('dd MMMM yyyy, HH:mm').format(DateTime.parse(ctrl.list['updatedAt']))}",
                                              style: context
                                                  .textTheme.labelSmall
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
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(ctrl.list['data_sedekah']['name'],
                                              style: context.textTheme.bodySmall
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
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(ctrl.list['paymentSelect']['name'],
                                              style: context.textTheme.bodySmall
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
                                              style: context.textTheme.bodySmall
                                                  ?.copyWith(
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              priceFormat.format(ctrl.list['nominal']),
                                              style: context.textTheme.bodySmall
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
                                      style: context.textTheme.labelSmall
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
  Widget build(BuildContext context) {
    final ctrl = Get.put(InvoiceController());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "", context: context, elevation: 0),
      body: Obx(() => ctrl.isLoadingList.value ? Center(child: CircularProgressIndicator()) : layout(context, ctrl)),
    );
  }
}
