import 'package:flutter/material.dart';

class CezeriPressableCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CezeriPressableCard({
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.color,
    this.elevation,
    this.margin,
    this.padding = const EdgeInsets.all(12),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      elevation: elevation,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: padding!,
          child: child,
        ),
      ),
    );
  }
}
