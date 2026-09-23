import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/providers/kalender_dzulhijjah_provider.dart';

class KalenderdzulhijjahPage extends ConsumerWidget {
  const KalenderdzulhijjahPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final lokasi = ref.watch(lokasiSayaProvider);
    final kalenderAsync = ref.watch(kalenderDzulhijjahProvider);
    final tahunBulan = DateFormat.yMMMM().format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF27B8A8),
        foregroundColor: Colors.white,
        title: const Text('Jadwal Imsakiyah'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight / 7,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      "https://nos.wjv-1.neo.id/marbot/assets/kalender-1.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      lokasi.keteranganLokasi,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth / 28,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      tahunBulan,
                      style:
                          TextStyle(color: Colors.white, fontSize: screenWidth / 28),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: const Color(0xFFF9E9D8),
              child: kalenderAsync.when(
                data: (rows) => Table(
                  children: [
                    _buildTableHR(
                        screenWidth, const ['No', 'Tanggal', 'Hari', 'Imsak', 'Berbuka']),
                    for (var data in rows) _buildTableRow(screenWidth, data),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                // perilaku lama: selama data belum ada (termasuk gagal muat) tetap spinner
                error: (_, __) => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(double width, List<String> values) {
    return TableRow(
      decoration: const BoxDecoration(
        color: Color(0xFFF9E9D8),
      ),
      children: values
          .map(
            (value) => TableCell(
              child: Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                    border: Border(
                  bottom: BorderSide(color: Colors.black12, width: 1),
                )),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: width / 38),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  TableRow _buildTableHR(double width, List<String> values) {
    return TableRow(
      decoration: BoxDecoration(
          color: const Color(0xFF814D03),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(width / 40),
            bottomRight: Radius.circular(width / 40),
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
                      fontSize: width / 37),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
