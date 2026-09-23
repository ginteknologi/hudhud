import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/components/button/iconbutton.dart';
import 'package:masjid_app/components/input/input_text.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/providers/akun_provider.dart';
import 'package:masjid_app/theme.dart';

class RiwayatPage extends ConsumerStatefulWidget {
  const RiwayatPage({super.key});

  @override
  ConsumerState<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends ConsumerState<RiwayatPage> {
  final inputLink = TextEditingController();

  @override
  void dispose() {
    inputLink.dispose();
    super.dispose();
  }

  SafeArea layout(BuildContext context, RiwayatSedekah data) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 21, right: 21, top: 21),
                          child: Column(children: [
                            Card(
                              elevation: 0,
                              color: const Color(0xFFF5F5F5),
                              margin: const EdgeInsets.only(top: 20),
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                //set border radius more than 50% of height and width to make circle
                              ),
                              child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 135,
                                  constraints:
                                      BoxConstraints.loose(Size.infinite),
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/img/bg_card_riwayat.png"),
                                          fit: BoxFit.fill)),
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Bismillah,",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white),
                                            ),
                                            Text(
                                              "Saya Niatkan untuk Bersedekah",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      color: Colors.white),
                                            )
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: AutoSizeText(
                                                  "Total Sedekah",
                                                  textAlign: TextAlign.start,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.white),
                                                  maxLines: 2,
                                                )),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: AutoSizeText(
                                                priceFormat
                                                    .format(data.totalSedekah),
                                                textAlign: TextAlign.start,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors.white),
                                                maxLines: 2,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )), //SizedBox
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Text("Riwayat",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black))),
                                // ButtonIcon(
                                //   bgcolor: Theme.of(context).primaryColor,
                                //   onTap: () {},
                                //   icon: Icon(
                                //     Icons.filter_alt_rounded,
                                //     color: Colors.white,
                                //   ),
                                // )
                              ],
                            )
                          ])),
                      Container(
                        decoration: BoxDecoration(color: Colors.white),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                left: 21, right: 21, top: 21),
                            child: data.history.isNotEmpty
                                ? Column(
                                    children: [
                                      ListView.builder(
                                        physics:
                                            const ClampingScrollPhysics(),
                                        itemCount: data.history.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return FadeInUp(
                                            child: ListItemUiWidget(
                                              typeDivider: TypeDivider.dashed,
                                              id: data.history[index]['id'],
                                              title:
                                                  '${priceFormat.format(data.history[index]['nominal'])},-',
                                              onTap: () {
                                                _showPopup(context);
                                              },
                                              category:
                                                  data.history[index]['invoice'],
                                              titleStyle: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF189A8C)),
                                              hasRightContent: true,
                                              showIcon: IconPosition.left,
                                              rightContent: [
                                                Text(
                                                    data.history[index]
                                                        ['status'],
                                                    textAlign: TextAlign.end,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: Color(
                                                                0xFF189A8C))),
                                                Text(
                                                    DateFormat(
                                                            'HH:mm, dd MMMM yyyy')
                                                        .format(DateTime.parse(
                                                            data.history[index]
                                                                ['createdAt'])),
                                                    textAlign: TextAlign.end,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ))
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  )
                                : Text(
                                    'Belum ada sedekah',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                    ),
                                  )),
                      )
                    ]))));
  }

  void _showPopup(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => Dialog(
        backgroundColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: Text("")),
                  ButtonIcon(
                    onTap: () {
                      Navigator.of(dialogContext).pop();
                    },
                    bgcolor: Colors.transparent,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                  constraints: BoxConstraints.loose(Size.infinite),
                  // height: 180,
                  width: MediaQuery.of(context).size.width - 42,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Bagikan Sedekah",
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .fontSize),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: InputText(
                                controller: inputLink,
                                labelPosition: "none",
                                placeholder: "https://asdfga.co.id",
                                isFill: true,
                                enabled: false,
                                placeholderStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                inputAction: TextInputAction.next,
                                onSubmit: (newValue) {},
                                onEditingComplete: () {},
                                onChanged: (newValue) {},
                                validator: (newValue) {
                                  if (newValue!.isEmpty) {
                                    return "https://asdfga.co.id";
                                  }
                                  return null;
                                },
                              )),
                          SizedBox(
                            width: 15,
                          ),
                          ButtonIcon(
                            onTap: () {
                              Navigator.of(dialogContext).pop();
                            },
                            bgcolor: Colors.transparent,
                            icon: const Icon(
                              Icons.copy,
                              color: Colors.black38,
                              size: 34,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            child: SvgPicture.asset(
                              'assets/icons/wa.svg',
                              alignment: Alignment.center,
                              width: 30,
                              height: 30,
                            ),
                            onTap: () {},
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            child: SvgPicture.asset(
                              'assets/icons/fb.svg',
                              alignment: Alignment.center,
                              width: 30,
                              height: 30,
                            ),
                            onTap: () {},
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          GestureDetector(
                            child: SvgPicture.asset(
                              'assets/icons/instagram.svg',
                              alignment: Alignment.center,
                              width: 30,
                              height: 30,
                            ),
                            onTap: () {},
                          ),
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final riwayatAsync = ref.watch(riwayatSedekahProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      body: riwayatAsync.when(
        data: (data) => layout(context, data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(
          child: Text('Gagal memuat riwayat.'),
        ),
      ),
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Riwayat Sedekah", context: context, elevation: 0),
    );
  }
}
