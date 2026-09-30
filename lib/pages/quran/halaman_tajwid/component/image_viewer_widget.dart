import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masjid_app/core/storage/preferences_service.dart';
import 'package:masjid_app/pages/quran/halaman_tajwid/model/tajwid_ayah_data.dart';

class EasyImageViewPager extends StatefulWidget {
  final List<Map<String, dynamic>> imageProviders;
  final int idxInitial;

  /// Kunci storage riwayat baca (`tajwidLastRead`)
  final String lastReadKey;

  /// Dipanggil tiap halaman berubah
  final void Function(int index) onPageChanged;
  final Function(int) onTap;
  final VoidCallback? onDoubleTap;
  final AyahCoordinate? selectedAyah;
  final void Function(AyahCoordinate?)? onAyahSelected;

  const EasyImageViewPager({
    super.key,
    required this.imageProviders,
    required this.idxInitial,
    required this.lastReadKey,
    required this.onPageChanged,
    required this.onTap,
    this.onDoubleTap,
    this.selectedAyah,
    this.onAyahSelected,
  });

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
        final item = widget.imageProviders[index];
        final image = item['file'] as String;
        final ayahs = TajwidAyahDataSource.fromPageItem(item);

        return EasyImageView(
          imageSource: "server",
          imageProvider: image,
          ayahs: ayahs,
          selectedAyah: widget.selectedAyah,
          onAyahTapped: (ayah) {
            widget.onAyahSelected?.call(ayah);
          },
          onTapOutside: () => widget.onTap(index),
          onDoubleTap: widget.onDoubleTap,
        );
      },
    );
  }
}

/// A full-sized view that displays the given image, supporting pinch & zoom,
/// double tap orientation toggle, and ayah coordinate detection
class EasyImageView extends StatefulWidget {
  final String imageSource;
  final String imageProvider;
  final double minScale;
  final double maxScale;
  final void Function(double)? onScaleChanged;
  final List<AyahCoordinate> ayahs;
  final AyahCoordinate? selectedAyah;
  final void Function(AyahCoordinate?)? onAyahTapped;
  final VoidCallback? onTapOutside;
  final VoidCallback? onDoubleTap;

  const EasyImageView({
    super.key,
    required this.imageProvider,
    required this.imageSource,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.onScaleChanged,
    this.ayahs = const [],
    this.selectedAyah,
    this.onAyahTapped,
    this.onTapOutside,
    this.onDoubleTap,
  });

  @override
  EasyImageViewState createState() => EasyImageViewState();
}

class EasyImageViewState extends State<EasyImageView> {
  late final TransformationController _transformationController =
      TransformationController();
  Size _imageSize = const Size(1000, 1500);
  ImageStream? _imageStream;
  ImageStreamListener? _streamListener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  @override
  void didUpdateWidget(EasyImageView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageProvider != widget.imageProvider) {
      _resolveImage();
    }
  }

  void _resolveImage() {
    if (widget.imageSource != "server") return;
    if (_imageStream != null && _streamListener != null) {
      _imageStream!.removeListener(_streamListener!);
    }
    final provider = CachedNetworkImageProvider(widget.imageProvider);
    _imageStream = provider.resolve(createLocalImageConfiguration(context));
    _streamListener = ImageStreamListener((ImageInfo info, bool _) {
      if (mounted) {
        setState(() {
          _imageSize = Size(
            info.image.width.toDouble(),
            info.image.height.toDouble(),
          );
        });
      }
    });
    _imageStream!.addListener(_streamListener!);
  }

  @override
  void dispose() {
    if (_imageStream != null && _streamListener != null) {
      _imageStream!.removeListener(_streamListener!);
    }
    _transformationController.dispose();
    super.dispose();
  }

  void _handleLongPress(Offset localPos, Rect imageRect) {
    if (!imageRect.contains(localPos)) return;

    final normX = ((localPos.dx - imageRect.left) / imageRect.width) * 1000.0;
    final normY = ((localPos.dy - imageRect.top) / imageRect.height) * 1000.0;

    AyahCoordinate? hitAyah;
    for (final ayah in widget.ayahs) {
      if (ayah.hitTest(normY, normX)) {
        hitAyah = ayah;
        break;
      }
    }

    if (hitAyah != null) {
      HapticFeedback.mediumImpact();
      widget.onAyahTapped?.call(hitAyah);
    }
  }

  void _handleTap(Offset localPos, Rect imageRect) {
    // Jika ada ayat yang sedang terpilih/diblok
    if (widget.selectedAyah != null) {
      if (!imageRect.contains(localPos)) {
        widget.onAyahTapped?.call(null);
        return;
      }

      final normX = ((localPos.dx - imageRect.left) / imageRect.width) * 1000.0;
      final normY = ((localPos.dy - imageRect.top) / imageRect.height) * 1000.0;

      AyahCoordinate? hitAyah;
      for (final ayah in widget.ayahs) {
        if (ayah.hitTest(normY, normX)) {
          hitAyah = ayah;
          break;
        }
      }

      // Tap ayat lain saat mode blok -> pindah blok ke ayat tersebut.
      // Tap ayat yang sama atau tap di area kosong -> unblock / tutup aksi.
      if (hitAyah != null &&
          hitAyah.ayahNumber != widget.selectedAyah?.ayahNumber) {
        HapticFeedback.selectionClick();
        widget.onAyahTapped?.call(hitAyah);
      } else {
        widget.onAyahTapped?.call(null);
      }
      return;
    }

    // Jika belum ada ayat yang diblok, tap biasa memanggil popup halaman bawaan
    widget.onTapOutside?.call();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isLandscape) {
          final renderedHeight =
              constraints.maxWidth * (_imageSize.height / _imageSize.width);
          final imageRect =
              Rect.fromLTWH(0, 0, constraints.maxWidth, renderedHeight);

          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: widget.minScale,
              maxScale: widget.maxScale,
              onInteractionEnd: (scaleEndDetails) {
                double scale =
                    _transformationController.value.getMaxScaleOnAxis();
                if (widget.onScaleChanged != null) {
                  widget.onScaleChanged!(scale);
                }
              },
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onDoubleTap: widget.onDoubleTap,
                  onTapUp: (details) =>
                      _handleTap(details.localPosition, imageRect),
                  onLongPressStart: (details) =>
                      _handleLongPress(details.localPosition, imageRect),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: renderedHeight,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        widget.imageSource == "server"
                            ? CachedNetworkImage(
                                imageUrl: widget.imageProvider,
                                width: constraints.maxWidth,
                                fit: BoxFit.fitWidth,
                                placeholder: (context, url) => const SizedBox(
                                  height: 300,
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    const SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.error_outline,
                                            color: Colors.red, size: 40),
                                        SizedBox(height: 8),
                                        Text("Gambar tidak bisa dibaca",
                                            style: TextStyle(fontSize: 11)),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : Image.asset(
                                widget.imageProvider,
                                width: constraints.maxWidth,
                                fit: BoxFit.fitWidth,
                              ),
                        CustomPaint(
                          painter: AyahHighlightPainter(
                            imageRect: imageRect,
                            selectedAyah: widget.selectedAyah,
                            highlightColor: Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.35),
                            borderColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        final fitted = applyBoxFit(
          BoxFit.contain,
          _imageSize,
          Size(constraints.maxWidth, constraints.maxHeight),
        );
        final dx = (constraints.maxWidth - fitted.destination.width) / 2;
        final dy = (constraints.maxHeight - fitted.destination.height) / 2;
        final imageRect = Rect.fromLTWH(
            dx, dy, fitted.destination.width, fitted.destination.height);

        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: InteractiveViewer(
            transformationController: _transformationController,
            minScale: widget.minScale,
            maxScale: widget.maxScale,
            onInteractionEnd: (scaleEndDetails) {
              double scale =
                  _transformationController.value.getMaxScaleOnAxis();
              if (widget.onScaleChanged != null) {
                widget.onScaleChanged!(scale);
              }
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onDoubleTap: widget.onDoubleTap,
              onTapUp: (details) =>
                  _handleTap(details.localPosition, imageRect),
              onLongPressStart: (details) =>
                  _handleLongPress(details.localPosition, imageRect),
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    widget.imageSource == "server"
                        ? CachedNetworkImage(
                            imageUrl: widget.imageProvider,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red, size: 40),
                                SizedBox(height: 8),
                                Text("Gambar tidak bisa dibaca",
                                    style: TextStyle(fontSize: 11)),
                                Text("Ada masalah pada jaringan Anda",
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          )
                        : Image.asset(
                            widget.imageProvider,
                            width: constraints.maxWidth,
                            height: constraints.maxHeight,
                            fit: BoxFit.contain,
                          ),
                    CustomPaint(
                      painter: AyahHighlightPainter(
                        imageRect: imageRect,
                        selectedAyah: widget.selectedAyah,
                        highlightColor: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.35),
                        borderColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Painter untuk menggambar highlight/blok pada ayat yang dipilih
class AyahHighlightPainter extends CustomPainter {
  final Rect imageRect;
  final AyahCoordinate? selectedAyah;
  final Color highlightColor;
  final Color borderColor;

  AyahHighlightPainter({
    required this.imageRect,
    required this.selectedAyah,
    this.highlightColor = const Color(0x3D048C7C),
    this.borderColor = const Color(0xB3048C7C),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (selectedAyah == null || imageRect.isEmpty) return;

    final fillPaint = Paint()
      ..color = highlightColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final markerPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (final box in selectedAyah!.highlightBoxes) {
      final ymin = box[0];
      final xmin = box[1];
      final ymax = box[2];
      final xmax = box[3];

      final rect = Rect.fromLTRB(
        imageRect.left + (xmin / 1000.0) * imageRect.width,
        imageRect.top + (ymin / 1000.0) * imageRect.height,
        imageRect.left + (xmax / 1000.0) * imageRect.width,
        imageRect.top + (ymax / 1000.0) * imageRect.height,
      );

      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      canvas.drawRRect(rrect, fillPaint);
      canvas.drawRRect(rrect, strokePaint);
    }

    final marker = selectedAyah!.markerBox;
    final markerRect = Rect.fromLTRB(
      imageRect.left + (marker[1] / 1000.0) * imageRect.width,
      imageRect.top + (marker[0] / 1000.0) * imageRect.height,
      imageRect.left + (marker[3] / 1000.0) * imageRect.width,
      imageRect.top + (marker[2] / 1000.0) * imageRect.height,
    );
    canvas.drawOval(markerRect, markerPaint);
  }

  @override
  bool shouldRepaint(covariant AyahHighlightPainter oldDelegate) {
    return oldDelegate.selectedAyah != selectedAyah ||
        oldDelegate.imageRect != imageRect ||
        oldDelegate.highlightColor != highlightColor;
  }
}
