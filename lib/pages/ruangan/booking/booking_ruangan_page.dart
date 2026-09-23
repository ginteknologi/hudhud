// import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/components/button/buttonvariant.dart';
import 'package:masjid_app/components/button/elevatedbutton.dart';
// import 'package:masjid_app/components/input/InputDropdown.dart';
import 'package:masjid_app/components/input/input_text.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
// import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/providers/ruangan_provider.dart';

class BookingRuanganPage extends ConsumerStatefulWidget {
  const BookingRuanganPage({super.key});

  @override
  ConsumerState<BookingRuanganPage> createState() => _BookingRuanganPageState();
}

class _BookingRuanganPageState extends ConsumerState<BookingRuanganPage> {
  final namaKegiatan = TextEditingController();
  final permintaan = TextEditingController();
  final nama = TextEditingController();
  final kontak = TextEditingController();

  String inputTanggal = "";
  String jamMulai = "";
  String jamSelesai = "";
  bool isLoadingList = false;

  @override
  void dispose() {
    namaKegiatan.dispose();
    permintaan.dispose();
    nama.dispose();
    kontak.dispose();
    super.dispose();
  }

  Future<void> proceedBooking() async {
    setState(() {
      isLoadingList = true;
    });
    try {
      final success = await ref.read(bookingRuanganProvider.notifier).booking(
            BookingRuanganParams(
              tanggal: inputTanggal,
              jamMulai: jamMulai,
              jamSelesai: jamSelesai,
              namaKegiatan: namaKegiatan.text,
              permintaanKhusus: permintaan.text,
              namaPemesan: nama.text,
              kontakPemesan: kontak.text,
            ),
          );
      if (!mounted) return;
      setState(() {
        isLoadingList = false;
      });
      if (success) {
        Fluttertoast.showToast(
            msg: "Permintaan booking berhasil dikirim.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        context.pop();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoadingList = false;
      });
    }
  }

  SafeArea layout(BuildContext context) {
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
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                "Tanggal",
                              ),
                            ),
                            ButtonVariant(
                                height: 40,
                                label: inputTanggal == "" ? "Tanggal" : inputTanggal,
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
                                      setState(() {
                                        inputTanggal = formattedDate;
                                      });
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                "Jam Mulai",
                              ),
                            ),
                            ButtonVariant(
                                height: 40,
                                label: jamMulai == "" ? "Jam Mulai" : jamMulai,
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
                                      setState(() {
                                        jamMulai = formattedTime;
                                      });
                                    }
                                  });
                                }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 5),
                              child: Text(
                                "Jam Selesai",
                              ),
                            ),
                            ButtonVariant(
                                height: 40,
                                label: jamSelesai == "" ? "Jam Selesai" : jamSelesai,
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
                                      setState(() {
                                        jamSelesai = formattedTime;
                                      });
                                    }
                                  });
                                }),
                          ],
                        ),
                      ),
                      InputText(
                        enabled: true,
                        placeholder: "Nama Kegiatan",
                        labelPosition: "outside",
                        label: '',
                        maxLine: 1,
                        controller: namaKegiatan,
                        onSubmit: (newValue) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        multiText: false,
                        inputType: TextInputType.text,
                        onEditingComplete: () {},
                        onChanged: (newValue) {},
                        validator: (String? newValue) {
                          return null;
                        },
                      ),
                      InputText(
                        enabled: true,
                        placeholder: "Permintaan Khusus",
                        labelPosition: "outside",
                        label: '',
                        maxLine: 5,
                        controller: permintaan,
                        onSubmit: (newValue) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        multiText: true,
                        inputType: TextInputType.text,
                        onEditingComplete: () {},
                        onChanged: (newValue) {},
                        validator: (String? newValue) {
                          return null;
                        },
                      ),
                      InputText(
                        enabled: true,
                        placeholder: "Nama Pemesan Ruangan",
                        labelPosition: "outside",
                        label: '',
                        maxLine: 1,
                        controller: nama,
                        onSubmit: (newValue) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        multiText: false,
                        inputType: TextInputType.text,
                        onEditingComplete: () {},
                        onChanged: (newValue) {},
                        validator: (String? newValue) {
                          return null;
                        },
                      ),
                      InputText(
                        enabled: true,
                        placeholder: "Kontak Pemesan",
                        labelPosition: "outside",
                        label: '',
                        maxLine: 1,
                        controller: kontak,
                        onSubmit: (newValue) {
                          FocusManager.instance.primaryFocus!.unfocus();
                        },
                        multiText: false,
                        inputType: TextInputType.text,
                        onEditingComplete: () {},
                        onChanged: (newValue) {},
                        validator: (String? newValue) {
                          return null;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  AutoSizeText(
                    "Catatan",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  AutoSizeText(
                    "Silahkan tunggu 2 x 24 jam setelah anda isi, DKM akan menghubungi anda untuk info lebih lanjut lagi.",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.black),
                  )
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBarWSWidget.getAppbarWidget(
            title: "Ruangan > List Jadwal > Booking Ruangan",
            context: context,
            elevation: 0),
        body: isLoadingList ? const CircularProgressIndicator() : layout(context),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.only(left: 21, right: 21),
            child: SizedBox(
              width: screenWidth,
              child: ButtonElevated(
                title: 'Booking Sekarang',
                width: screenWidth,
                bgcolor: Theme.of(context).primaryColor,
                height: 45,
                color: Colors.white,
                radius: 5,
                onPressed: () {
                  proceedBooking();
                },
              ),
            ),
          )
        ]);
  }
}
