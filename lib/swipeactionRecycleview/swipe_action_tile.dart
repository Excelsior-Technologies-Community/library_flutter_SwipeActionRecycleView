import 'package:flutter/material.dart';
import 'package:library_flutter_swipeaction_recycleview/swipeactionRecycleview/swipe_action.dart';

class SwipeActionTile extends StatefulWidget {
  final Widget child;
  final List<SwipeAction> leftActions;
  final List<SwipeAction> rightActions;

  const SwipeActionTile({
    super.key,
    required this.child,
    required this.leftActions,
    required this.rightActions,
  });

  @override
  State<SwipeActionTile> createState() => _SwipeActionTileState();
}

class _SwipeActionTileState extends State<SwipeActionTile> with SingleTickerProviderStateMixin {
  double offset = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        setState(() {
          offset += details.delta.dx;
          if (offset > 120) offset = 120;
          if (offset < -120) offset = -120;
        });
      },
      child: Transform.translate(
        offset: Offset(offset, 0),
        child: widget.child,
      ),
    );
  }
}