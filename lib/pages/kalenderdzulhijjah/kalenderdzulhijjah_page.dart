import 'package:flutter/material.dart';
import 'package:masjid_app/pages/jadwal_imsakiah/jadwal_imsakiah_page.dart';

/// Wrapper backward-compatibility untuk KalenderdzulhijjahPage.
class KalenderdzulhijjahPage extends StatelessWidget {
  const KalenderdzulhijjahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const JadwalImsakiahPage();
  }
}
