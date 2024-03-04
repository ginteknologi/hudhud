import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/controllers/main_controller.dart';
import 'package:masjid_app/controllers/Kalenderdzulhijjah_controller.dart';

class KalenderdzulhijjahPage extends StatelessWidget {
  final KalenderdzulhijjahController ctrl = Get.find();
  final MainController gctrl = Get.find<MainController>();
  KalenderdzulhijjahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF27B8A8),
        foregroundColor: Colors.white,
        title: Text('Jadwal Imsakiyah'),
        centerTitle: true,
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarColor: Colors.red,
        //   statusBarIconBrightness: Brightness.dark,
        // ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return Container(
                  height: Get.height / 7,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          "https://nos.wjv-1.neo.id/marbot/assets/kalender-1.png"), // Ganti dengan URL gambar Anda
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          gctrl.mylokasi.value.keteranganLokasi,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Get.width / 28,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${ctrl.tahunBulan.value}",
                          style: TextStyle(
                              color: Colors.white, fontSize: Get.width / 28),
                        ),
                      ],
                    ),
                  ));
            }),
            Container(
              color: Color(0xFFF9E9D8),
              child: Obx(() {
                if (ctrl.isLoading.isTrue) {
                  return Center(child: CircularProgressIndicator());
                }
                return Table(
                  children: [
                    _buildTableHR(
                        ['No', 'Tanggal', 'Hari', 'Imsak', 'Berbuka']),
                    for (var data in ctrl.listData) ...[
                      _buildTableRow(
                          [data[0], data[1], data[2], data[3], data[4]]),
                    ]
                    // _buildTableRow(
                    //     ['1', '24 Feb 2024', 'Senin', '04:45', '18:30']),
                    // _buildTableRow(
                    //     ['1', '24 Feb 2024', 'Senin', '04:45', '18:30']),
                    // _buildTableRow(
                    //     ['1', '24 Feb 2024', 'Senin', '04:45', '18:30']),
                    // _buildTableRow(
                    //     ['1', '24 Feb 2024', 'Senin', '04:45', '18:30']),
                    // _buildTableRow(
                    //     ['1', '24 Feb 2024', 'Senin', '04:45', '18:30']),
                    // Tambahkan baris lain sesuai kebutuhan
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> values) {
    return TableRow(
      decoration: BoxDecoration(
        color: Color(0xFFF9E9D8),
      ),
      children: values
          .map(
            (value) => Container(
              child: TableCell(
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1),
                  )),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: Get.width / 38),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  _buildTableHR(List<String> values) {
    return TableRow(
      decoration: BoxDecoration(
          color: Color(0xFF814D03),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(Get.width / 40),
            bottomRight: Radius.circular(Get.width / 40),
          )),
      children: values
          .map(
            (value) => TableCell(
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: Get.width / 37),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
