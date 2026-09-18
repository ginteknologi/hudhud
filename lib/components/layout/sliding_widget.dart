import 'package:flutter/widgets.dart';

class SlidingWidget extends StatelessWidget {
  const SlidingWidget({
    super.key,
    this.child,
    required this.controller,
    required this.visible,
    this.from,
    this.to,
  });

  final Widget? child;
  final AnimationController controller;
  final bool visible;
  final Offset? from;
  final Offset? to;

  @override
  Widget build(BuildContext context) {
    visible ? controller.reverse() : controller.forward();
    return SlideTransition(
      position:
          Tween<Offset>(begin: from ?? Offset.zero, end: to ?? Offset(0, -1))
              .animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}
