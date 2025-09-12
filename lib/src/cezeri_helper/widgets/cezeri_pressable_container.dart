import 'package:flutter/material.dart';

class CezeriPressableContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double? borderRadius;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color? color;
  final double? elevation;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CezeriPressableContainer({
    required this.child,
    this.height,
    this.width,
    this.borderRadius = 12,
    required this.onTap,
    this.onLongPress,
    this.color,
    this.elevation,
    this.border,
    this.margin,
    this.padding = const EdgeInsets.all(12),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius!),
        border: border,
        boxShadow:
            elevation != null ? [BoxShadow(color: Colors.black.withValues(alpha: .1), blurRadius: elevation!, offset: const Offset(0, 2))] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: Material(
          color: Colors.transparent,
          child: InkWell(onTap: onTap, onLongPress: onLongPress, child: Padding(padding: padding!, child: child)),
        ),
      ),
    );
  }
}
