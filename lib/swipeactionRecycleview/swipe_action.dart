import 'package:flutter/cupertino.dart';

class SwipeAction {
final IconData icon;
final Color color;
final VoidCallback onTap;

const SwipeAction({required this.color, required this.icon, required this.onTap});
}