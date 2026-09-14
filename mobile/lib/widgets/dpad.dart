import 'package:flutter/material.dart';
import '../theme/colors.dart';

enum DpadDirection { up, down, left, right }

/// A four-way directional pad. Purely visual/tactile for now — each
/// segment reports press state via [onDirectionChanged] so Phase 2
/// networking can hook in without touching this widget.
class Dpad extends StatefulWidget {
  const Dpad({
    super.key,
    this.size = 176,
    this.onDirectionChanged,
  });

  final double size;
  final ValueChanged<DpadDirection?>? onDirectionChanged;

  @override
  State<Dpad> createState() => _DpadState();
}

class _DpadState extends State<Dpad> {
  DpadDirection? _pressed;

  void _setPressed(DpadDirection? direction) {
    if (_pressed == direction) return;
    setState(() => _pressed = direction);
    widget.onDirectionChanged?.call(direction);
  }

  @override
  Widget build(BuildContext context) {
    final segment = widget.size / 3;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Static center hub that visually joins the four arms.
          Container(
            width: segment,
            height: segment,
            color: PadColors.dpad,
          ),
          Positioned(
            top: 0,
            left: segment,
            child: _DpadArm(
              direction: DpadDirection.up,
              width: segment,
              height: segment,
              icon: Icons.keyboard_arrow_up_rounded,
              borderRadius: BorderRadius.vertical(top: Radius.circular(segment * 0.28)),
              pressed: _pressed == DpadDirection.up,
              onPressed: (v) => _setPressed(v ? DpadDirection.up : null),
            ),
          ),
          Positioned(
            top: segment * 2,
            left: segment,
            child: _DpadArm(
              direction: DpadDirection.down,
              width: segment,
              height: segment,
              icon: Icons.keyboard_arrow_down_rounded,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(segment * 0.28)),
              pressed: _pressed == DpadDirection.down,
              onPressed: (v) => _setPressed(v ? DpadDirection.down : null),
            ),
          ),
          Positioned(
            top: segment,
            left: 0,
            child: _DpadArm(
              direction: DpadDirection.left,
              width: segment,
              height: segment,
              icon: Icons.keyboard_arrow_left_rounded,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(segment * 0.28)),
              pressed: _pressed == DpadDirection.left,
              onPressed: (v) => _setPressed(v ? DpadDirection.left : null),
            ),
          ),
          Positioned(
            top: segment,
            left: segment * 2,
            child: _DpadArm(
              direction: DpadDirection.right,
              width: segment,
              height: segment,
              icon: Icons.keyboard_arrow_right_rounded,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(segment * 0.28)),
              pressed: _pressed == DpadDirection.right,
              onPressed: (v) => _setPressed(v ? DpadDirection.right : null),
            ),
          ),
        ],
      ),
    );
  }
}

class _DpadArm extends StatelessWidget {
  const _DpadArm({
    required this.direction,
    required this.width,
    required this.height,
    required this.icon,
    required this.borderRadius,
    required this.pressed,
    required this.onPressed,
  });

  final DpadDirection direction;
  final double width;
  final double height;
  final IconData icon;
  final BorderRadius borderRadius;
  final bool pressed;
  final ValueChanged<bool> onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => onPressed(true),
      onTapUp: (_) => onPressed(false),
      onTapCancel: () => onPressed(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: pressed ? PadColors.dpadPressed : PadColors.dpad,
          borderRadius: borderRadius,
        ),
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: pressed ? Colors.white : PadColors.labelMuted,
          size: width * 0.55,
        ),
      ),
    );
  }
}
