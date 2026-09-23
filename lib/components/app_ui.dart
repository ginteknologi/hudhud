import 'package:flutter/material.dart';
import 'package:masjid_app/components/button/buttonvariant.dart';
import 'package:masjid_app/theme.dart';
import 'package:masjid_app/fonts.dart';

class AppUi {
  static SizedBox loading({
    required BuildContext context,
    String title = 'Mohon tunggu',
    bool noConnection = false,
    required void Function() onReload,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: AppVariables.appPadding),
        child: Column(
          children: [
            if (!noConnection)
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: CircularProgressIndicator(),
              ),
            if (title.isNotEmpty)
              Text(
                noConnection ? 'Tidak ada koneksi' : title,
                textAlign: TextAlign.center,
                style: FontListV2.subtitle(context: context),
              ),
            if (noConnection)
              ButtonVariant(
                onPressed: onReload,
                shadow: false,
                isInverted: true,
                border: 0,
                height: 40,
                radius: 10,
                label: 'Muat Ulang',
                textStyle: FontListV2.subtitle(context: context),
              ),
          ],
        ),
      ),
    );
  }

  static Stack gradientBackground({
    required Widget child,
    required List<Color> colors,
    Alignment begin = Alignment.topCenter,
    Alignment end = Alignment.bottomCenter,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: begin,
                end: end,
                colors: colors,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
