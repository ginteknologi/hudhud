import 'package:flutter/material.dart';

/// Lightweight drop-in replacement for Skeletonizer to ensure
/// 100% compatibility with Flutter 3.35.x+ (Canvas.clipRSuperellipse)
class Skeletonizer extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final bool ignoreContainers;

  const Skeletonizer({
    super.key,
    required this.child,
    this.enabled = true,
    this.ignoreContainers = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) {
      return child;
    }

    return AnimatedOpacity(
      opacity: 0.6,
      duration: const Duration(milliseconds: 300),
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Colors.grey,
          BlendMode.modulate,
        ),
        child: child,
      ),
    );
  }
}
