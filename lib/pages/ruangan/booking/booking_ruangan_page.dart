import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mesjid_app/components/button/buttonvariant.dart';
import 'package:mesjid_app/components/button/elevatedbutton.dart';
import 'package:mesjid_app/components/input/InputDropdown.dart';
import 'package:mesjid_app/components/input/InputText.dart';
import 'package:mesjid_app/components/layout/app_bar_ws.dart';
import 'package:mesjid_app/components/partial/list_ui.dart';
import 'package:mesjid_app/pages/ruangan/booking/booking_ruangan_controller.dart';
import 'package:mesjid_app/routes/home/index.dart';
import 'package:simple_moment/simple_moment.dart';

class BookingRuanganPage extends StatelessWidget {
  const BookingRuanganPage({super.key});

  layout(BookingRuanganController ctrl, BuildContext context) {
    return SafeArea(
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 21, vertical: 21),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Silahkan Isi Form"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: List.generate(ctrl.formInput.length, (index) {
                      final data = ctrl.formInput[index];
                      if (data['type'] == 'text') {
                        return InputText(
                          enabled: data['enabled'] ?? true,
                          placeholder: data['placeholder'],
                          labelPosition: "outside",
                          label: '',
                          maxLine: data['maxline'],
                          controller: data['controller'],
                          onSubmit: (newValue) {
                            FocusManager.instance.primaryFocus!.unfocus();
                          },
                          multiText: data['multiText'] ?? false,
                          inputType: data['inputType'] ?? TextInputType.text,
                          onEditingComplete: () {},
                          onChanged: (newValue) {
                            data['onChanged'];
                          },
                          validator: (String? newValue) {},
                        );
                      }
                      if (data['type'] == 'datepicker') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  data['label'],
                                ),
                              ),
                              ButtonVariant(
                                  height: 40,
                                  label: data['controller'].value == ""
                                      ? data['placeholder']
                                      : Moment.parse(data['controller'].value)
                                          .format("dd MMMM yyyy"),
                                  shadow: false,
                                  onPressed: () {
                                    // DatePicker.showDatePicker(context,
                                    //     showTitleActions: true,
                                    //     minTime: DateTime(1945, 1, 1),
                                    //     maxTime: DateTime(2015, 6, 7), onConfirm: (date) {
                                    //   data['controller'].value = date.toString();
                                    // }, currentTime: DateTime.now(), locale: LocaleType.id);
                                  }),
                            ],
                          ),
                        );
                      }
                      return SizedBox(
                        height: 20,
                      );
                    }),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  AutoSizeText(
                    "Catatan",
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  AutoSizeText(
                    "Silahkan tunggu 2 x 24 jam setelah anda isi, DKM akan menghubungi anda untuk info lebih lanjut lagi.",
                    style: context.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  )
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(BookingRuanganController());

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Ruangan > List Jadwal > Booking Ruangan",
            context: context,
            elevation: 0),
        body: layout(ctrl, context),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: Container(
              width: Get.width,
              child: ButtonElevated(
                title: 'Booking Sekarang',
                width: Get.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  Get.offAllNamed(RoutesHome.root);
                },
              ),
            ),
          )
        ]);
  }
}
