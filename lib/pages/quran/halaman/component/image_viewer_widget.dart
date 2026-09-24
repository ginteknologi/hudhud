import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';

class EasyImageViewPager extends StatefulWidget {
  final List<Map<String, dynamic>> imageProviders;
  final int idxInitial;

  /// Kunci storage riwayat baca (`indonesiaLastRead`, `madinahLastRead`,
  /// `tajwidLastRead`) — nilai map di-JSON-encode supaya kompatibel
  /// dengan data yang ditulis versi lama.
  /// dengan data yang ditulis versi lama.
  final String lastReadKey;

  /// Dipanggil tiap halaman berubah — pengganti lookup controller
  /// langsung dari viewer.
  final void Function(int index) onPageChanged;
  final Function(int) onTap;

  /// Create new instance, using the [imageProviders] to populate the [PageView]
  const EasyImageViewPager(
      {super.key,
      required this.imageProviders,
      required this.idxInitial,
      required this.lastReadKey,
      required this.onPageChanged,
      required this.onTap});

  @override
  EasyImageViewPagerState createState() => EasyImageViewPagerState();
}

class EasyImageViewPagerState extends State<EasyImageViewPager> {
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
    if (oldWidget.idxInitial != widget.idxInitial) {
      final target = widget.idxInitial - 1;
      if (target >= 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients &&
              _pageController.page?.round() != target) {
            _pageController.jumpToPage(target);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      onPageChanged: (index) {
        if (index >= 0 && index < widget.imageProviders.length) {
          PreferencesService.setString(
              widget.lastReadKey, jsonEncode(widget.imageProviders[index]));
        }
        widget.onPageChanged(index);
      },
      reverse: true,
      physics: _pagingEnabled
          ? const PageScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: widget.imageProviders.length,
      controller: _pageController,
      itemBuilder: (context, index) {
        final image = widget.imageProviders[index]['file'] as String;
        return EasyImageView(
          imageSource: "server",
          imageProvider: image,
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
    final size = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return SizedBox(
        width: size.width,
        height: !isPortrait ? double.infinity : size.height,
        child: InteractiveViewer(
          constrained: false,
          transformationController: _transformationController,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          child: Stack(
            children: [
              widget.imageSource == "server"
                  ? CachedNetworkImage(
                      imageUrl: widget.imageProvider,
                      width: size.width,
                      height:
                          isPortrait ? size.height - (size.height * 0.1) : null,
                      fit: BoxFit.fitWidth,
                      placeholder: (BuildContext context, String url) {
                        // Penempatan custom placeholder
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [CircularProgressIndicator()],
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
                  : Image.asset(
                      widget.imageProvider,
                      width: size.width,
                      height:
                          isPortrait ? size.height - (size.height * 0.1) : null,
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
