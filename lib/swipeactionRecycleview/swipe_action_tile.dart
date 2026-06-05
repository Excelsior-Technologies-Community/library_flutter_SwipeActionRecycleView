import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:library_flutter_swipeaction_recycleview/swipeactionRecycleview/swipe_action.dart';

class CustomSwipeActionTile extends StatefulWidget {
  final Widget child;
  final List<SwipeAction> leftActions;
  final List<SwipeAction> rightActions;
  final double actionWidth;
  final double dragResistance;

  const CustomSwipeActionTile({
    super.key,
    required this.child,
    this.leftActions = const [],
    this.rightActions = const [],
    this.actionWidth = 80.0,
    this.dragResistance = 0.8,
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

    _controller.addListener(() {
      if (_animation != null) {
        setState(() {
          _offset = _animation!.value;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant CustomSwipeActionTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.child != oldWidget.child) {
      _offset = 0;
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _animateTo(double target) {
    _controller.stop();
    _animation = Tween<double>(
      begin: _offset,
      end: target,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward(from: 0);
  }

  void _handleActionTap(SwipeAction action) async {
    HapticFeedback.mediumImpact();
    _animateTo(0);
    // Brief delay for visual smoothness before triggering action
    await Future.delayed(const Duration(milliseconds: 150));
    action.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final double maxRightOffset = -(widget.rightActions.length * widget.actionWidth);
    final double maxLeftOffset = (widget.leftActions.length * widget.actionWidth);

    return Stack(
      children: [
        Positioned.fill(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  if (_offset > 0 && widget.leftActions.isNotEmpty)
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: Row(
                        children: widget.leftActions.map((action) {
                          return _buildAction(action);
                        }).toList(),
                      ),
                    ),
                  if (_offset < 0 && widget.rightActions.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Row(
                        children: widget.rightActions.map((action) {
                          return _buildAction(action);
                        }).toList(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
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
              if (_controller.isAnimating) _controller.stop();
              
              setState(() {
                _offset += details.delta.dx * widget.dragResistance;
                
                // Clamp and allow slight overscroll resistance
                if (_offset < maxRightOffset) {
                  _offset = maxRightOffset + (details.delta.dx * 0.1);
                } else if (_offset > maxLeftOffset) {
                  _offset = maxLeftOffset + (details.delta.dx * 0.1);
                }
                
                // Hard clamp for sanity
                _offset = _offset.clamp(
                  maxRightOffset - 20, 
                  maxLeftOffset + 20
                );
              });
            },
            onHorizontalDragEnd: (details) {
              final velocity = details.primaryVelocity ?? 0;
              
              if (velocity < -300) {
                _animateTo(maxRightOffset);
              } else if (velocity > 300) {
                _animateTo(maxLeftOffset);
              } else if (_offset < maxRightOffset / 2) {
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

  Widget _buildAction(SwipeAction action) {
    return Material(
      color: action.color,
      child: InkWell(
        onTap: () => _handleActionTap(action),
        child: SizedBox(
          width: widget.actionWidth,
          child: Center(
            child: Icon(
              action.icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}