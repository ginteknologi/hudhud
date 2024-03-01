import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/controllers/kajian_controller.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:url_launcher/url_launcher.dart';

class KajianPage extends StatelessWidget {
  KajianPage({super.key});
  final KajianController ctrl = Get.put(KajianController());
  layout(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Obx(() {
              if (ctrl.isLoading.isTrue) {
                return Center(child: CircularProgressIndicator());
              }
              return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21),
                  child: ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: ctrl.listKajian.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListItemUiWidget(
                        onTap: () async {
                          final Uri url =
                              Uri.parse(ctrl.listKajian[index].link);
                          if (!await launchUrl(url)) {
                            print('Tidak dapat membuka link YouTube.');
                          }
                        },
                        minHeight: 70,
                        vjustify: false,
                        widthContent: MediaQuery.of(context).size.width - 130,
                        id: 1,
                        title: ctrl.listKajian[index].judul,
                        showIcon: IconPosition.left,
                        iconLeft: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(7),
                              child: Image.network(
                                ctrl.listKajian[index].image,
                                width: 65,
                                height: 65,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        titleStyle: context.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        subTitle: '',
                        subtitleStyle: context.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w100, color: Colors.black),
                        footerText: ctrl.listKajian[index].subjudul,
                        footerTextStyle: context.textTheme.labelSmall?.copyWith(
                            letterSpacing: 0,
                            fontWeight: FontWeight.w100,
                            color: Colors.black),
                      );
                    },
                  ));
            }),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(Get.arguments['judul']),
        // title: Text('kajian'),
      ),
      body: Obx(() => ctrl.isLoading.value ? const Center(child: CircularProgressIndicator(),) : layout(context)),
    );
  }
}
