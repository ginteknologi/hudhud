// import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/components/button/buttonvariant.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
// import 'package:masjid_app/components/input/InputDropdown.dart';
import 'package:masjid_app/components/input/input_text.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
// import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/pages/ruangan/booking/booking_ruangan_controller.dart';
class BookingRuanganPage extends StatelessWidget {
  const BookingRuanganPage({super.key});

  SafeArea layout(BookingRuanganController ctrl, BuildContext context) {
    return SafeArea(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 21),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Silahkan Isi Form"),
                  ),
                  const SizedBox(
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
                          validator: (String? newValue) {
                            return null;
                          },
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
                                  label: data['controller'].value == "" ? data['placeholder'] : data['controller'].value,
                                  shadow: false,
                                  onPressed: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1945, 1, 1),
                                      lastDate: DateTime(2050, 12, 31),
                                    ).then((selectedDate) {
                                      if (selectedDate != null) {
                                        // Format tanggal yang dipilih ke dalam format "dd MMMM yyyy"
                                        String formattedDate = DateFormat("yyyy-MM-dd").format(selectedDate);
                                        // Set nilai controller dengan tanggal yang diformat
                                        data['controller'].value = formattedDate;
                                      }
                                    });                                    
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
                      if (data['type'] == 'timepicker') {
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
                                  label: data['controller'].value == "" ? data['placeholder']: data['controller'].value,
                                  shadow: false,
                                  onPressed: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                      builder: (BuildContext context, Widget? child) {
                                        return MediaQuery(
                                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                          child: child!,
                                        );
                                      },
                                    ).then((selectedTime) {
                                      if (selectedTime != null) {
                                        String formattedTime = "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";
                                        // Set nilai controller dengan waktu yang diformat
                                        data['controller'].value = formattedTime;
                                      }
                                    });                               
                                  }),
                            ],
                          ),
                        );
                      }                      
                      return const SizedBox(
                        height: 20,
                      );
                    }),
                  ),
                  const SizedBox(
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Ruangan > List Jadwal > Booking Ruangan",
            context: context,
            elevation: 0),
        body: Obx(() => ctrl.isLoadingList.value ? CircularProgressIndicator() : layout(ctrl, context)),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: SizedBox(
              width: Get.width,
              child: ButtonElevated(
                title: 'Booking Sekarang',
                width: Get.width,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  ctrl.proceedBooking();
                },
              ),
            ),
          )
        ]);
  }
}
