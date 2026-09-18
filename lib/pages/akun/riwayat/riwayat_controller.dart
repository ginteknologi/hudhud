import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:masjid_app/components/button/iconbutton.dart';
import 'package:masjid_app/components/input/input_text.dart';
import 'package:masjid_app/pages/akun/riwayat/riwayat_service.dart';
class RiwayatController extends GetxController {
  var dataUser = {};
  var isLoadingList = true.obs;
  var list = {}.obs;
  var listRiwayat = [].obs;
  var totalSedekah = 0;
  TextEditingController inputLink = TextEditingController();
  var txtController = TextEditingController();

  void goToDetail(param) {
    _showPopup();
  }

  Future<void> getRiwayats() async {
    final result = await RiwayatService().getList();
    listRiwayat.value = result['data']['history'];
    totalSedekah = result['data']['total_sedekah'];
    isLoadingList.value = false;    
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
