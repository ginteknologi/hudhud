import 'package:flutter/material.dart';

class EasyImageViewPager extends StatefulWidget {
  final List imageProviders;

  /// Create new instance, using the [imageProviders] to populate the [PageView]
  const EasyImageViewPager({Key? key, required this.imageProviders})
      : super(key: key);

  @override
  _EasyImageViewPagerState createState() => _EasyImageViewPagerState();
}

class _EasyImageViewPagerState extends State<EasyImageViewPager> {
  final PageController _pageController = PageController();
  bool _pagingEnabled = true;

  @override
  void dispose() {
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
        final image = widget.imageProviders[index];
        return EasyImageView(
          imageProvider: image,
          onScaleChanged: (scale) {
            setState(() {
              // Disable paging when image is zoomed-in
              _pagingEnabled = scale <= 1.0;
            });
          },
        );
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
