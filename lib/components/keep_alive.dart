import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class KeepAliveScrollablePositionedList extends StatefulWidget {
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const KeepAliveScrollablePositionedList({
    super.key,
    required this.itemScrollController,
    required this.itemPositionsListener,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  State<KeepAliveScrollablePositionedList> createState() =>
      _KeepAliveScrollablePositionedListState();

  static void builder(
      {required bool shrinkWrap,
      required itemCount,
      required Column Function(dynamic context, dynamic index) itemBuilder}) {}
}

class _KeepAliveScrollablePositionedListState
    extends State<KeepAliveScrollablePositionedList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure that the state is kept alive
    return ScrollablePositionedList.builder(
      itemScrollController: widget.itemScrollController,
      itemPositionsListener: widget.itemPositionsListener,
      itemCount: widget.itemCount,
      itemBuilder: widget.itemBuilder,
    );
  }
}
