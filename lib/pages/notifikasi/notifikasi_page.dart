import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/providers/notifikasi_provider.dart';

class NotifikasiPage extends ConsumerWidget {
  const NotifikasiPage({super.key});

  SafeArea layout(BuildContext context, List<dynamic> list) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 21),
                child: list.isNotEmpty ?
                ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return FadeInUp(
                      child: ListItemUiWidget(
                        id: list[index]['id'],
                        title: list[index]['judul'],
                        onTap: () {
                          if (list[index]['jenis_notifikasi'] == 'transaksi') {
                            context.push(AppRoutes.notifikasiDetail.replaceFirst(
                                ':id', list[index]['id'].toString()));
                          }
                        },
                        titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                        category: list[index]['jenis_notifikasi'],
                        hasRightContent: true,
                        rightContent: [
                          // Text(
                          //     ctrl.list[index]['type'] == "success"
                          //         ? "Berhasil"
                          //         : ctrl.list[index]['type'] == "pending"
                          //             ? "Menunggu Pembayaran"
                          //             : "Dibatalkan",
                          //     textAlign: TextAlign.end,
                          //     style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          //         fontWeight: FontWeight.bold,
                          //         color:
                          //             ctrl.list[index]['type'] == "success"
                          //                 ? Theme.of(context).primaryColor
                          //                 : ctrl.list[index]['type'] ==
                          //                         "pending"
                          //                     ? Color(0xFFFFA800)
                          //                     : Color(0xFFFF0000))),
                          Text(DateFormat('HH:mm, dd MMMM yyyy').format(DateTime.parse(list[index]['createdAt'])),
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.normal,
                              ))
                        ],
                      ),
                    );
                  },
                )
                :
                Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.notifications_off,
                          size: 100,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum ada notifikasi',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              )
            )
          );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(notifikasiListProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Notifikasi", context: context, elevation: 0),
      body: listAsync.when(
        data: (list) => layout(context, list),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat notifikasi: $err')),
      ),
    );
  }
}
