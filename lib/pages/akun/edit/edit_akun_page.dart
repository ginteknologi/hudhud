import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/buttonvariant.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/input/InputText.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/akun/akun_controller.dart';
import 'package:mesjid_app/pages/akun/edit/edit_akun_controller.dart';
import 'package:mesjid_app/routes/home/index.dart';

class EditAkunPage extends StatelessWidget {
  const EditAkunPage({super.key});

  layout(BuildContext context, EditAkunController ctrl) {
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
                                Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.white, width: 4),
                                          boxShadow: [
                                            BoxShadow(
                                              offset: Offset(0, 4),
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 3,
                                            ),
                                          ],
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(70))),
                                      child: CircleAvatar(
                                        radius: 70,
                                        backgroundImage: NetworkImage(
                                            "https://picsum.photos/1000"),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 1,
                                      right: 1,
                                      child: Container(
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Icon(
                                              Icons.add_a_photo_outlined,
                                              color: Colors.black),
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            width: 3,
                                            color: Colors.white,
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                              50,
                                            ),
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            )),
                        SizedBox(
                          height: 30,
                        ),
                        InputText(
                          labelPosition: 'outside',
                          label: "Nama",
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          placeholder: "Do'a Anda",
                          placeholderStyle:
                              Theme.of(context).textTheme.bodySmall,
                          inputPadding: const EdgeInsets.all(15),
                          multiText: false,
                          maxLine: 1,
                          controller: ctrl.txtController,
                          onSubmit: (newValue) {},
                          onEditingComplete: () {},
                          onChanged: (newValue) {},
                          validator: (newValue) {
                            if (newValue!.isEmpty) {
                              return "Mohon untuk diisi.";
                            }
                            return null;
                          },
                        ),
                        InputText(
                          labelPosition: 'outside',
                          label: "Email",
                          isFill: false,
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          placeholder: "Do'a Anda",
                          placeholderStyle:
                              Theme.of(context).textTheme.bodySmall,
                          inputPadding: const EdgeInsets.all(15),
                          multiText: false,
                          maxLine: 1,
                          controller: ctrl.emailController,
                          onSubmit: (newValue) {},
                          onEditingComplete: () {},
                          onChanged: (newValue) {},
                          validator: (newValue) {
                            if (newValue!.isEmpty) {
                              return "Mohon untuk diisi.";
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 6,
                        ),
                      ],
                    )))));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(EditAkunController());

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Profile > Edit Profile", context: context, elevation: 0),
        body: layout(context, ctrl),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: Container(
              width: Get.width,
              child: ButtonElevated(
                title: 'Simpan',
                width: Get.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  Get.toNamed(RoutesHome.root);
                },
              ),
            ),
          )
        ]);
  }
}
