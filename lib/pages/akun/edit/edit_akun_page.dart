import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
import 'package:masjid_app/components/input/input_text.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/providers/akun_provider.dart';
import 'package:masjid_app/providers/auth_provider.dart';

class EditAkunPage extends ConsumerStatefulWidget {
  const EditAkunPage({super.key});

  @override
  ConsumerState<EditAkunPage> createState() => _EditAkunPageState();
}

class _EditAkunPageState extends ConsumerState<EditAkunPage> {
  final txtController = TextEditingController();
  final phoneController = TextEditingController();
  final picker = ImagePicker();

  String inputFoto = '';
  File? newfile;
  String fileName = '';
  bool isNewfile = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authNotifierProvider).valueOrNull;
    inputFoto = user?.photo ?? '';
    txtController.text = user?.name ?? '';
    phoneController.text = AkunRepository.savedPhone;
  }

  @override
  void dispose() {
    txtController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> pilihFile() async {
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
      maxWidth: 1000,
    );
    if (image == null) return;
    setState(() {
      newfile = File(image.path);
      fileName = image.name;
      isNewfile = true;
    });
  }

  Future<void> simpan() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    final ok = await ref.read(akunRepositoryProvider).simpanProfile(
          nama: txtController.text,
          phone: phoneController.text,
          newFile: newfile,
          fileName: fileName,
        );

    if (!mounted) return;
    setState(() => isLoading = false);
    if (ok) context.pop();
  }

  Widget _avatar() {
    if (isNewfile && newfile != null) {
      return CircleAvatar(radius: 70, backgroundImage: FileImage(newfile!));
    }
    if (inputFoto.isNotEmpty) {
      return CircleAvatar(radius: 70, backgroundImage: NetworkImage(inputFoto));
    }
    return const CircleAvatar(
      radius: 70,
      backgroundImage: AssetImage("assets/icons/app_icon.png"),
    );
  }

  SafeArea layout(BuildContext context) {
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
                                                color: Colors.black
                                                    .withValues(alpha: 0.3),
                                                blurRadius: 3,
                                              ),
                                            ],
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(70))),
                                        child: InkWell(
                                          onTap: () {
                                            pilihFile();
                                          },
                                          child: _avatar(),
                                        )),
                                    Positioned(
                                      bottom: 1,
                                      right: 1,
                                      child: Container(
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
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Icon(
                                              Icons.add_a_photo_outlined,
                                              color: Colors.black),
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
                          placeholder: "Nama Anda",
                          placeholderStyle:
                              Theme.of(context).textTheme.bodySmall,
                          inputPadding: const EdgeInsets.all(15),
                          multiText: false,
                          maxLine: 1,
                          controller: txtController,
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
                          inputType: TextInputType.number,
                          labelPosition: 'outside',
                          label: "Nomor Handphone",
                          isFill: false,
                          labelStyle: Theme.of(context).textTheme.bodySmall,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          placeholder: "08xxxxxxx",
                          placeholderStyle:
                              Theme.of(context).textTheme.bodySmall,
                          inputPadding: const EdgeInsets.all(15),
                          multiText: false,
                          maxLine: 1,
                          controller: phoneController,
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Profile > Edit Profile", context: context, elevation: 0),
        body: layout(context),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: SizedBox(
              width: screenWidth,
              child: ButtonElevated(
                title: 'Simpan',
                width: screenWidth,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  simpan();
                },
              ),
            ),
          )
        ]);
  }
}
