import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class EasyImageViewPager extends StatefulWidget {
  final List imageProviders;
  final int idxInitial;

  /// Create new instance, using the [imageProviders] to populate the [PageView]
  const EasyImageViewPager(
      {Key? key, required this.imageProviders, required this.idxInitial})
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
                  _pagingEnabled = scale <= 1.0;
                });
              },
            ),
          ),
          Positioned(
            top: -20,
            right: 10,
            child: GestureDetector(
              child: SvgPicture.asset(
                'assets/icons/bookmark-page.svg',
                height: 60,
              ),
              onTap: () {
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
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: widget.minScale,
          maxScale: widget.maxScale,
          child: Image.asset(widget.imageProvider),
          onInteractionEnd: (scaleEndDetails) {
            double scale = _transformationController.value.getMaxScaleOnAxis();

            if (widget.onScaleChanged != null) {
              widget.onScaleChanged!(scale);
            }
          },
        ));
  }
}
