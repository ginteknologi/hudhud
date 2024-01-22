import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/pages/hadits/hadits_controller.dart';

class ContentHaditsPage extends StatelessWidget {
  ContentHaditsPage({super.key});

  layout(HaditsController ctrl, BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Hadits Arbain No.1',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            softWrap: true,
                            maxLines: 1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset("assets/icons/book_mark.svg",
                                  height: 20, width: 20),
                              SizedBox(
                                width: 10,
                              ),
                              AutoSizeText(
                                "Amalan bergantung pada niat",
                                style: context.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                      Icon(
                        Icons.share,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                const Divider(
                  color: Colors.black12,
                  thickness: 5,
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 21),
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          child: Text(
                            "Disini Hadits",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        AutoSizeText(
                          'Lorem ipsum dolor sit amet consectetur. Massa placerat eu habitasse amet pharetra viverra nascetur mattis. Nulla ut sagittis at et. Eget nulla ultricies ipsum tellus eget amet aenean. Odio eget quis interdum nunc mattis rhoncus risus ultrices. Placerat eget nisl interdum iaculis purus sed sed turpis. Ultrices pharetra volutpat imperdiet arcu feugiat est augue fermentum sed. Mattis ultricies ipsum purus enim eget aliquam amet. Augue mattis a ipsum cursus donec interdum. Molestie at vehicula imperdiet duis urna enim orci luctus.',
                          style: context.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                          softWrap: true,
                        ),
                      ],
                    )),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HaditsController());
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      extendBodyBehindAppBar: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Hadits Arbain No. 1",
          context: context,
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
          color: Colors.white,
          titleAlign: Alignment.centerLeft,
          backgroundColor: Color(0xFF048C7C)),
      body: Obx(() => ctrl.isLoadingList.value
          ? const Center(child: CircularProgressIndicator())
          : layout(ctrl, context)),
    );
  }
}

enum TypeViewQuran { perayat, perhalaman }
