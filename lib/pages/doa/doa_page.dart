import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:masjid_app/components/layout/app_bar_ws.dart';
import 'package:masjid_app/components/partial/list_ui.dart';
import 'package:masjid_app/core/router/app_router.dart';
import 'package:masjid_app/models/doa_models.dart';
import 'package:masjid_app/providers/doa_providers.dart';

class DoaPage extends ConsumerWidget {
  const DoaPage({super.key});

  SafeArea layout(BuildContext context, List<DoaCategoryModel> list) {
    return SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21),
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  itemCount: list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    // Datum model = filteredEvents[index];
                    return FadeInUp(
                      child: ListItemUiWidget(
                        id: list[index].id,
                        title: list[index].nama,
                        onTap: () {
                          context.push(AppRoutes.doaDetail
                              .replaceFirst(':id', list[index].id.toString()));
                        },
                        titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        // subTitle: list[index]['subtitle'],
                        subtitleStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w300, color: Colors.black),
                        hasRightContent: true,
                        showIcon: IconPosition.both,
                        // iconLeft: SvgPicture.asset(
                        //     list[index]['icon'],
                        //     height: 35,
                        //     width: 35),
                        iconRight: const Icon(Icons.chevron_right_rounded),
                      ),
                    );
                  },
                ),
              ),
            )));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final doaAsync = ref.watch(doaCategoriesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBarWSWidget.getAppbarWidget(
          title: "Do'a", context: context, elevation: 0),
      body: doaAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => layout(context, const []),
        data: (list) => layout(context, list),
      ),
    );
  }
}
