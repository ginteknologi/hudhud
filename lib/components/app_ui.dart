import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masjid_app/components/button/buttonvariant.dart';
import 'package:masjid_app/theme.dart';
import 'package:masjid_app/fonts.dart';

class AppUi {
  static SizedBox loading({
    String title = 'Mohon tunggu',
    required RxBool noConnection,
    required void Function() onReload,
  }) {
    return SizedBox(
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: AppVariables.appPadding),
        child: Obx(() => Column(
              children: [
                if (noConnection.isFalse)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CircularProgressIndicator(),
                  ),
                if (title.isNotEmpty)
                  Text(
                    noConnection.isTrue ? 'Tidak ada koneksi' : title,
                    textAlign: TextAlign.center,
                    style: FontListV2.subtitle(context: Get.context!),
                  ),
                if (noConnection.isTrue)
                  ButtonVariant(
                    onPressed: () => onReload(),
                    shadow: false,
                    isInverted: true,
                    border: 0,
                    height: 40,
                    radius: 10,
                    label: 'Muat Ulang',
                    textStyle: FontListV2.subtitle(context: Get.context!),
                  ),
              ],
            )),
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
