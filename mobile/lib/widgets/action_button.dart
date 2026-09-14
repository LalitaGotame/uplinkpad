import 'package:flutter/material.dart';

/// A single round face button (A/B/X/Y). Reports press state via
/// [onPressedChanged]; no networking is wired up yet in Phase 1.
class ActionButton extends StatefulWidget {
  const ActionButton({
    super.key,
    required this.label,
    required this.color,
    this.size = 64,
    this.onPressedChanged,
  });

  final String label;
  final Color color;
  final double size;
  final ValueChanged<bool>? onPressedChanged;

  @override
  State<ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
    widget.onPressedChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 80),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color.withOpacity(_pressed ? 1.0 : 0.75),
            border: Border.all(
              color: Colors.white.withOpacity(_pressed ? 0.9 : 0.35),
              width: 2,
            ),
            boxShadow: _pressed
                ? []
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: TextStyle(
              color: Colors.white,
              fontSize: widget.size * 0.36,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
