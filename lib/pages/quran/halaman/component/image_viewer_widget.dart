import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class EasyImageViewPager extends StatefulWidget {
  final List imageProviders;
  final int idxInitial;
  final Function(int) onTap;

  /// Create new instance, using the [imageProviders] to populate the [PageView]
  const EasyImageViewPager(
      {Key? key,
      required this.imageProviders,
      required this.idxInitial,
      required this.onTap})
      : super(key: key);

  @override
  _EasyImageViewPagerState createState() => _EasyImageViewPagerState();
}

class _EasyImageViewPagerState extends State<EasyImageViewPager> {
  late PageController _pageController =
      PageController(initialPage: widget.idxInitial);
  bool _pagingEnabled = true;

  @override
  void dispose() {
    _pageController = PageController(initialPage: widget.idxInitial);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      reverse: true,
      physics: _pagingEnabled
          ? const PageScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      itemCount: widget.imageProviders.length,
      controller: _pageController,
      itemBuilder: (context, index) {
        final image = widget.imageProviders[index]['image'];
        return Stack(children: [
          SizedBox(
            width: Get.width - 42,
            child: EasyImageView(
              imageProvider: image,
              onScaleChanged: (scale) {
                setState(() {
                  print(index);
                  // Disable paging when image is zoomed-in
                  // _pagingEnabled = scale <= 1.0;
                });
              },
            ),
          ),
          Positioned(
            top: 0,
            right: 10,
            child: GestureDetector(
              child: SvgPicture.asset(
                'assets/icons/bookmark-page.svg',
                height: 60,
              ),
              onTap: () {
                widget.onTap(index);
                // showPopup(ctrl, context, ctrlHome);
              },
            ),
          ),
        ]);

        //     EasyImageView(
        //   imageProvider: image,
        //   onScaleChanged: (scale) {
        //     setState(() {
        //       print(index);
        //       // Disable paging when image is zoomed-in
        //       _pagingEnabled = scale <= 1.0;
        //     });
        //   },
        // );
      },
    );
  }
}

/// A full-sized view that displays the given image, supporting pinch & zoom
class EasyImageView extends StatefulWidget {
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
    Key? key,
    required this.imageProvider,
    this.minScale = 1.0,
    this.maxScale = 5.0,
    this.onScaleChanged,
  }) : super(key: key);

  @override
  _EasyImageViewState createState() => _EasyImageViewState();
}

class _EasyImageViewState extends State<EasyImageView> {
  late TransformationController _transformationController =
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
          child: Image.asset(
            widget.imageProvider,
            width: MediaQuery.of(context).size.width - 42,
            fit: BoxFit.fitWidth,
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
