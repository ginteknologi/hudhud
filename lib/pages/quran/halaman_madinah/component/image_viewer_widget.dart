import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:masjid_app/pages/quran/halaman_madinah/halaman_quran_madinah_controller.dart';
// import 'package:masjid_app/configs/main_controller.dart';
class EasyImageViewPager extends StatefulWidget {
  final List imageProviders;
  final int idxInitial;
  // final bool search;
  final Function(int) onTap;

  /// Create new instance, using the [imageProviders] to populate the [PageView]
  const EasyImageViewPager(
      {super.key,
      required this.imageProviders,
      required this.idxInitial,
      // required this.search,
      required this.onTap});

  @override
  EasyImageViewPagerState createState() => EasyImageViewPagerState();
}

class EasyImageViewPagerState extends State<EasyImageViewPager> {
  final dataStore = GetStorage();
  late PageController _pageController =
      PageController(initialPage: widget.idxInitial - 1);
  final bool _pagingEnabled = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.idxInitial - 1);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(EasyImageViewPager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.idxInitial != widget.idxInitial - 1) {
      // Jika nilai idxInitial berubah, lompat ke halaman yang baru
      _pageController.jumpToPage(widget.idxInitial - 1);
    }
  }

  @override
Widget build(BuildContext context) {
  final ctrl = Get.find<HalamanQuranMadinahController>();
  // final gctrl = Get.find<MainController>();
  return PageView.builder(
onPageChanged: (index) {
    ctrl.surahSaatIni.value = widget.imageProviders[index]['surat'];
    ctrl.halSaatIni.value = widget.imageProviders[index]['hal'].toString();
  if (kDebugMode) {
    debugPrint('asdssad');
  }
},
    reverse: true,
    physics: _pagingEnabled
        ? const PageScrollPhysics()
        : const NeverScrollableScrollPhysics(),
    itemCount: widget.imageProviders.length,
    controller: _pageController,
    itemBuilder: (context, index) {
      final image = widget.imageProviders[index]['file'];
      dataStore.write('madinahLastRead', widget.imageProviders[index]);
      // gctrl.madinahLastRead = widget.imageProviders[index];
      if (kDebugMode) {
        debugPrint('<<<<<<<wei>>>>>>>');
      }
      if (kDebugMode) {
        debugPrint(widget.imageProviders[index].toString());
      }
      return EasyImageView(
        imageSource: "server",
        imageProvider: image,
        // onScaleChanged: (scale) {
        //   setState(() {
        //     print(index);
        //   });
        // },
      );
    },
  );
}

}

/// A full-sized view that displays the given image, supporting pinch & zoom
class EasyImageView extends StatefulWidget {
  final String imageSource;

  /// The image to display
  final String imageProvider;

  /// Minimum scale factor
  final double minScale;

  /// Maximum scale factor
  final double maxScale;

  /// Callback for when the scale has changed, only invoked at the end of
  /// an interaction.
  final void Function(double)? onScaleChanged;

  /// Create a new instance
  const EasyImageView({
    super.key,
    required this.imageProvider,
    required this.imageSource,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.onScaleChanged,
  });

  @override
  EasyImageViewState createState() => EasyImageViewState();
}

class EasyImageViewState extends State<EasyImageView> {
  late final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    final zoomFactor = 30.0;
    final xTranslate = 100.0;
    final yTranslate = 100.0;
    // _transformationController = TransformationController(scaleMatrix);
    _transformationController.value.setEntry(0, 0, zoomFactor);
    _transformationController.value.setEntry(1, 1, zoomFactor);
    _transformationController.value.setEntry(2, 2, zoomFactor);
    _transformationController.value.setEntry(0, 3, -xTranslate);
    _transformationController.value.setEntry(1, 3, -yTranslate);
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).orientation != Orientation.portrait
            ? double.infinity
            : MediaQuery.of(context).size.height,
        child: InteractiveViewer(
          constrained: false,
          transformationController: _transformationController,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          child: Stack(
            children: [
              // Text(widget.imageProvider.toString(), style: TextStyle(fontSize: 10)),
              widget.imageSource == "server"
                  ? CachedNetworkImage(
                      imageUrl: widget.imageProvider,
                      width: Get.width,
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? Get.height - (Get.height * 0.1)
                          : null,
                      fit: BoxFit.fitWidth,
                      placeholder: (BuildContext context, String url) {
                        // Penempatan custom placeholder
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator()
                          ],
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 40,
                                ),
                                Text(
                                  "image tidak bisa dibaca",
                                  style: TextStyle(fontSize: 11),
                                )
                              ],
                            ),
                            Text("Ada masalah pada jaringan anda")
                          ],
                        );
                      },
                    )
                  // ? Image.network(
                  //     widget.imageProvider,
                  //     width: Get.width,
                  //     height: MediaQuery.of(context).orientation ==
                  //             Orientation.portrait
                  //         ? Get.height - (Get.height * 0.1)
                  //         : null,
                  //     fit: BoxFit.fitWidth,
                  //   )
                  : Image.asset(
                      widget.imageProvider,
                      width: Get.width,
                      height: MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? Get.height - (Get.height * 0.1)
                          : null,
                      fit: BoxFit.fitWidth,
                    )
            ],
          ),
          onInteractionEnd: (scaleEndDetails) {
            double scale = _transformationController.value.getMaxScaleOnAxis();

            if (widget.onScaleChanged != null) {
              widget.onScaleChanged!(scale);
            }
          },
        ));
  }
}
