import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/controllers/Kalenderdzulhijjah_controller.dart';

class KalenderdzulhijjahPage extends StatelessWidget {
  final KalenderdzulhijjahController ctrl = Get.find();
  KalenderdzulhijjahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kalender dzulhijjah'),
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarColor: Colors.red,
        //   statusBarIconBrightness: Brightness.dark,
        // ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
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
                    style: TextStyle(fontSize: Get.width / 45),
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
          color: Color(0xFFB57841),
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
