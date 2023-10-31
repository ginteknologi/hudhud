import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/buttonvariant.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/layout/custom_bottom_bar.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/akun/akun_controller.dart';
import 'package:mesjid_app/pages/home/home_controller.dart';
import 'package:mesjid_app/routes/akun/index.dart';
import 'package:mesjid_app/routes/auth/index.dart';
import 'package:mesjid_app/routes/home/index.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  layout(BuildContext context, HomeController hctrl) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(90),
                                    child: Image.network(
                                      "https://picsum.photos/1000",
                                      height: 110,
                                      width: 110,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Muhammad Fahmi Zulmeinidar",
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "insanjati@gmail.com",
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                ButtonElevated(
                                  title: 'Edit Profile',
                                  width: 162,
                                  bgcolor: Theme.of(context).primaryColor,
                                  height: 45,
                                  color: Colors.white,
                                  radius: 20,
                                  onPressed: () {
                                    Get.toNamed(RoutesAkun.edit);
                                  },
                                )
                              ],
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        ListItemUiWidget(
                          id: 1,
                          title: "Riwayat Sedekah",
                          titleStyle: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          showIcon: IconPosition.left,
                          iconLeft: Icon(
                            Icons.history_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          onTap: () {
                            Get.toNamed(RoutesAkun.riwayat);
                          },
                        ),
                        ListItemUiWidget(
                          id: 1,
                          title: "Tentang Kami",
                          titleStyle: context.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          showIcon: IconPosition.left,
                          iconLeft: Icon(
                            Icons.info_rounded,
                            color: Theme.of(context).primaryColor,
                            size: 30,
                          ),
                          onTap: () {
                            hctrl.type.value = BottomBarEnum.dkm;
                            hctrl.selectedIdx.value = 3;
                            Get.toNamed(RoutesHome.root);
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 6,
                        ),
                        ButtonElevated(
                          title: 'Keluar',
                          iconLeft: Icon(Icons.logout_rounded),
                          showIcon: "left",
                          nearLeft: true,
                          width: Get.width,
                          bgcolor: Theme.of(context).primaryColor,
                          height: 45,
                          color: Colors.white,
                          radius: 7,
                          onPressed: () {
                            Get.offAllNamed(RoutesAuth.logout);
                          },
                        )
                      ],
                    )))));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(AkunController());
    final hctrl = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Profile", context: context, elevation: 0),
      body: layout(context, hctrl),
    );
  }
}
