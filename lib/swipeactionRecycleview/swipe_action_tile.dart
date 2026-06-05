import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:library_flutter_swipeaction_recycleview/swipeactionRecycleview/swipe_action.dart';

class CustomSwipeActionTile extends StatefulWidget {
  final Widget child;
  final List<SwipeAction> leftActions;
  final List<SwipeAction> rightActions;

  const CustomSwipeActionTile({
    super.key,
    required this.child,
    required this.leftActions,
    required this.rightActions,
  });

  @override
  State<CustomSwipeActionTile> createState() => _CustomSwipeActionTileState();
}

class _CustomSwipeActionTileState extends State<CustomSwipeActionTile>
    with SingleTickerProviderStateMixin {
  double _offset = 0;
  late AnimationController _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    _animation = Tween<double>(begin: _offset, end: target).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    )..addListener(() {
      setState(() {
        _offset = _animation!.value;
      });
    });
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    const double actionWidth = 80.0;
    final double maxRightOffset = -(widget.rightActions.length * actionWidth);
    final double maxLeftOffset = (widget.leftActions.length * actionWidth);

    return Stack(
      children: [
        // Actions Layer
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Left Actions (reveal when swiping right)
                  if (_offset > 0)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Row(
                        children: widget.leftActions.map((action) {
                          return Material(
                            color: action.color,
                            child: InkWell(
                              onTap: () {
                                _animateTo(0);
                                action.onTap();
                              },
                              child: SizedBox(
                                width: actionWidth,
                                child: Center(
                                  child: Icon(action.icon, color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  // Right Actions (reveal when swiping left)
                  if (_offset < 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Row(
                        children: widget.rightActions.map((action) {
                          return Material(
                            color: action.color,
                            child: InkWell(
                              onTap: () {
                                _animateTo(0);
                                action.onTap();
                              },
                              child: SizedBox(
                                width: actionWidth,
                                child: Center(
                                  child: Icon(action.icon, color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        // Child Layer
        Transform.translate(
          offset: Offset(_offset, 0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_offset != 0) {
                _animateTo(0);
              }
            },
            onHorizontalDragUpdate: (details) {
              setState(() {
                _offset += details.delta.dx;
                // Clamp offset
                if (_offset < maxRightOffset) {
                  _offset = maxRightOffset;
                } else if (_offset > maxLeftOffset) {
                  _offset = maxLeftOffset;
                }
              });
            },
            onHorizontalDragEnd: (details) {
              if (_offset < maxRightOffset / 2) {
                _animateTo(maxRightOffset);
              } else if (_offset > maxLeftOffset / 2) {
                _animateTo(maxLeftOffset);
              } else {
                _animateTo(0);
              }
            },
            child: widget.child,
          ),
        ),
      ],
    );
  }
}
