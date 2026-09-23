import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/ruangan_provider.dart';
// import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class JadwalRuanganPage extends ConsumerWidget {
  const JadwalRuanganPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tanggalParam =
        GoRouterState.of(context).uri.queryParameters['tanggal'];
    final tanggal =
        (tanggalParam != null ? DateTime.tryParse(tanggalParam) : null) ??
            DateTime.now();
    final listAsync = ref.watch(jadwalRuanganProvider(tanggal));

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Ruangan > List Jadwal", context: context, elevation: 0),
        body: listAsync.when(
          data: (list) => layout(list, context),
          loading: () => const CircularProgressIndicator(),
          error: (err, _) =>
              Center(child: Text('Gagal memuat jadwal: $err')),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: SizedBox(
              width: screenWidth,
              child: ButtonElevated(
                title: 'Booking Ruangan',
                width: screenWidth,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  context.push(AppRoutes.ruanganBooking);
                },
              ),
            ),
          )
        ]);
  }

  SafeArea layout(List<dynamic> list, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 21),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                children: [
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   decoration: BoxDecoration(
                  //       color: Theme.of(context).primaryColor,
                  //       borderRadius: const BorderRadius.all(Radius.circular(7))),
                  //   constraints: BoxConstraints.loose(Size.infinite),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       SizedBox(
                  //         width: 160,
                  //         // decoration: BoxDecoration(color: Colors.white),
                  //         child: Obx(() => InputDropdown(
                  //             placeholder: "Bulan..",
                  //             input: ctrl.inputBulan.value,
                  //             label: '',
                  //             dropdownColor: Colors.white,
                  //             filled: true,
                  //             fillColor: Colors.white,
                  //             data: ctrl.months.map((month) {
                  //               return {"id": month['id'].toString(), "label": month['label'].toString()};
                  //             }).toList(),
                  //             onChanged: (newValue) {
                  //               ctrl.inputBulan.value = newValue.toString();
                  //               ctrl.getData();
                  //             },
                  //           )
                  //         ),
                  //       ),
                  //       SizedBox(
                  //         width: 120,
                  //         // decoration: BoxDecoration(color: Colors.white),
                  //         child: Obx(() => InputDropdown(
                  //             placeholder: "Tahun..",
                  //             input: ctrl.inputTahun.value,
                  //             label: '',
                  //             dropdownColor: Colors.white,
                  //             filled: true,
                  //             fillColor: Colors.white,
                  //             data: ctrl.years.map((year) {
                  //               return {"id": year, "label": year.toString()};
                  //             }).toList(),
                  //             onChanged: (newValue) {
                  //               ctrl.inputTahun.value = newValue;
                  //             },
                  //           )
                  //           ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // const Divider(
                  //   color: Colors.black26,
                  // ),

                  const Row(
                    children: [
                      Expanded(flex: 1, child: Text("Tanggal")),
                      Expanded(flex: 2, child: Text("Kegiatan"))
                    ],
                  ),
                  const Divider(
                    color: Colors.black26,
                  ),
                  list.isNotEmpty ? ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: list.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                        return FadeInUp(
                          child: ListItemUiWidget(
                            id: 1,
                            widthContent: screenWidth * 0.55,
                            title: list[index]['nama_kegiatan'],
                            titleStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold, color: Colors.black),
                            subTitle: list[index]['nama_pemesan'],
                            subtitleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.normal,
                                color: Colors.black54),
                            showIcon: IconPosition.leftFlex,
                            start: true,
                            iconLeft: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(DateTime.parse(list[index]['tanggal']).day.toString(),
                                          style: Theme.of(context).textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0,
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                    ),
                                    Text(DateFormat('MMMM', 'id').format(DateTime.parse(list[index]['tanggal'])),
                                      style: Theme.of(context).textTheme.labelSmall
                                          ?.copyWith(
                                              fontWeight: FontWeight.normal,
                                              letterSpacing: 0,
                                              color:
                                                  Theme.of(context).primaryColor),
                                    ),
                                    Text('${int.parse(list[index]['jam_mulai'].split(':')[0])}:${int.parse(list[index]['jam_mulai'].split(':')[1])} - ' '${int.parse(list[index]['jam_selesai'].split(':')[0])}:${int.parse(list[index]['jam_selesai'].split(':')[1])}',
                                        style: Theme.of(context).textTheme.labelSmall
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0,
                                                color: Theme.of(context)
                                                    .primaryColor)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 70,
                                  child: VerticalDivider(
                                    thickness: 1,
                                    width: 20,
                                    color: Colors.black26,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                    },
                  ) : Text('Tidak ada data booking'),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      color: const Color(0xFFDADADA),
                      child: ExpansionTile(
                        title: Text("Cara Booking Ruangan",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                                color: Colors.black)),
                        children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            child: AutoSizeText(
                                "Lorem ipsum dolor sit amet consectetur. Imperdiet porttitor cras viverra odio massa. Aliquam interdum et etiam elementum viverra ullamcorper a aliquam. Morbi odio orci sed ut massa in at. Vel egestas quam pellentesque eget magnis posuere. Donec netus fringilla sem hendrerit turpis amet ac. Sit sed maecenas est sit nec donec risus. Rhoncus leo tellus libero at cras mattis habitasse lacus. Lacus sem tempus cursus eget habitant at ultrices arcu duis. Morbi morbi egestas risus pellentesque velit. Non sed eu mauris orci nunc id lorem nibh ultrices. Habitant in hendrerit arcu enim diam dignissim enim ultricies. Sit adipiscing etiam. Rhoncus leo tellus libero at cras mattis habitasse lacus. Lacus sem tempus cursus eget habitant at ultrices arcu duis. Morbi morbi egestas risus pellentesque ",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0,
                                    height: 1.1,
                                    color: Colors.black)),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      color: const Color(0xFFDADADA),
                      child: ExpansionTile(
                        title: Text("Syarat & Ketentuan",
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0,
                                color: Colors.black)),
                        children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(20),
                            width: double.infinity,
                            child: AutoSizeText(
                                "Lorem ipsum dolor sit amet consectetur. Imperdiet porttitor cras viverra odio massa. Aliquam interdum et etiam elementum viverra ullamcorper a aliquam. Morbi odio orci sed ut massa in at. Vel egestas quam pellentesque eget magnis posuere. Donec netus fringilla sem hendrerit turpis amet ac. Sit sed maecenas est sit nec donec risus. Rhoncus leo tellus libero at cras mattis habitasse lacus. Lacus sem tempus cursus eget habitant at ultrices arcu duis. Morbi morbi egestas risus pellentesque velit. Non sed eu mauris orci nunc id lorem nibh ultrices. Habitant in hendrerit arcu enim diam dignissim enim ultricies. Sit adipiscing etiam. Rhoncus leo tellus libero at cras mattis habitasse lacus. Lacus sem tempus cursus eget habitant at ultrices arcu duis. Morbi morbi egestas risus pellentesque ",
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0,
                                    height: 1.1,
                                    color: Colors.black)),
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  AutoSizeText(
                      "Catatan! \nMohon dibaca Syarat & Ketentuan sebelum Anda Booking Ruangan",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.normal,
                          letterSpacing: 0,
                          height: 1,
                          color: Colors.black)),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            )));
  }
}
