import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/button/iconbutton.dart';
import 'package:mesjid_app/components/input/InputText.dart';
import 'package:mesjid_app/pages/quran/quran_service.dart';
import 'package:mesjid_app/routes/quran/index.dart';

class RiwayatController extends GetxController {
  var isLoadingList = true.obs;
  var list = {}.obs;
  List listRiwayat = [].obs;

  TextEditingController inputLink = TextEditingController();
  var txtController = TextEditingController();

  getData() async {
    final result = await QuranService().getList('all');
    list.value = result['data'];
    isLoadingList.value = false;
  }

  goToDetail(param) {
    _showPopup();
    // print(RoutesSedekah.detail, id: id);
    // Get.toNamed('${RoutesQuran.root}/detail/${param['id']}',
    //     arguments: {"selectedSurah": param});
  }

  getRiwayats() async {
    return listRiwayat = [
      {
        "id": 2,
        "title": 100000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 3,
        "title": 100000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Makiah",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 4,
        "title": 120000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 5,
        "title": 1000000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 6,
        "title": 1200000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 7,
        "title": 3000000,
        "subTitle":
            "Pembukaan terus menerus yaaa Pembukaan terus menerus yaaa ",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 8,
        "title": 3000000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 9,
        "title": 3000000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
      {
        "id": 10,
        "title": 3000000,
        "subTitle": "Pembukaan",
        "category": "INV-00123812",
        "type": "Berhasil",
        "tanggal": "10/10/2020",
        "jam": "10.10"
      },
    ];
  }

  void _showPopup() {
    Get.defaultDialog(
      backgroundColor: Colors.transparent,
      barrierDismissible: true,
      contentPadding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 20),
      title: '',
      titleStyle: TextStyle(height: 0),
      titlePadding: EdgeInsets.all(0),
      content: Column(
        children: [
          Row(
            children: [
              Expanded(child: Text("")),
              ButtonIcon(
                onTap: () {
                  Get.back();
                },
                bgcolor: Colors.transparent,
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
              constraints: BoxConstraints.loose(Size.infinite),
              // height: 180,
              width: Get.width - 42,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Bagikan Sedekah",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: Get.theme.textTheme.bodyLarge!.fontSize),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: InputText(
                            controller: inputLink,
                            labelPosition: "none",
                            placeholder: "https://asdfga.co.id",
                            isFill: true,
                            enabled: false,
                            placeholderStyle: Get.theme.textTheme.bodyMedium,
                            inputAction: TextInputAction.next,
                            onSubmit: (newValue) {},
                            onEditingComplete: () {},
                            onChanged: (newValue) {},
                            validator: (newValue) {
                              if (newValue!.isEmpty) {
                                return "https://asdfga.co.id";
                              }
                              return null;
                            },
                          )),
                      SizedBox(
                        width: 15,
                      ),
                      ButtonIcon(
                        onTap: () {
                          Get.back();
                        },
                        bgcolor: Colors.transparent,
                        icon: const Icon(
                          Icons.copy,
                          color: Colors.black38,
                          size: 34,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        child: SvgPicture.asset(
                          'assets/icons/wa.svg',
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                        ),
                        onTap: () {},
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        child: SvgPicture.asset(
                          'assets/icons/fb.svg',
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                        ),
                        onTap: () {},
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      GestureDetector(
                        child: SvgPicture.asset(
                          'assets/icons/instagram.svg',
                          alignment: Alignment.center,
                          width: 30,
                          height: 30,
                        ),
                        onTap: () {},
                      ),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }

  @override
  void onInit() {
    getRiwayats();
    super.onInit();
  }
}
