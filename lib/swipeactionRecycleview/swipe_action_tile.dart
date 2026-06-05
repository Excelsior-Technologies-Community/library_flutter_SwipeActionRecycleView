import 'package:flutter/material.dart';
import 'package:library_flutter_swipeaction_recycleview/swipeactionRecycleview/swipe_action.dart';

class SwipeActionTile extends StatefulWidget {
  final Widget child;
  final double iconSize;
  final List<SwipeAction> leftActions;
  final List<SwipeAction> rightActions;

  const SwipeActionTile({
    super.key,
    required this.child,
    required this.leftActions,
    required this.rightActions,
    this.iconSize=20,
  });

  @override
  State<SwipeActionTile> createState() => _SwipeActionTileState();
}

class _SwipeActionTileState extends State<SwipeActionTile> with SingleTickerProviderStateMixin {
  double offset = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: widget.rightActions.map((action) {
              return Container(
                width: 80,
                color: action.color,
                child: IconButton(
                  icon: Icon(
                    action.icon,
                    color: Colors.white,
                    size: widget.iconSize,
                  ),
                  onPressed: action.onTap,
                ),
              );
            }).toList(),
          ),
        ),

        GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              offset += details.delta.dx;

              if (offset > 0) offset = 0;
              final maxOffset = -(widget.rightActions.length * 80);

              if (offset < maxOffset) {
                offset = maxOffset as double;
              }
            });
          },
          child: Transform.translate(
            offset: Offset(offset, 0),
            child: widget.child,
          ),
        ),
      ],
    );
  }
}