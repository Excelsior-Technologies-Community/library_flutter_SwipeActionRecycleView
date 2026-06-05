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

class _SwipeActionTileState extends State<SwipeActionTile>  with SingleTickerProviderStateMixin{
  final double offset=0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
