import 'package:flutter/material.dart';
import '../theme/colors.dart';

/// A draggable analog stick. Emits a normalized (x, y) in [-1, 1] via
/// [onChanged] as the thumb moves, and snaps back to center on release.
/// No values are sent anywhere yet — Phase 2 networking will consume
/// this callback.
class AnalogStick extends StatefulWidget {
  const AnalogStick({
    super.key,
    this.size = 176,
    this.thumbSize = 72,
    this.onChanged,
  });

  final double size;
  final double thumbSize;
  final ValueChanged<Offset>? onChanged;

  @override
  State<AnalogStick> createState() => _AnalogStickState();
}

class _AnalogStickState extends State<AnalogStick> with SingleTickerProviderStateMixin {
  Offset _thumbOffset = Offset.zero;
  late final AnimationController _snapController;
  Animation<Offset>? _snapAnimation;

  double get _maxRadius => (widget.size - widget.thumbSize) / 2;

  @override
  void initState() {
    super.initState();
    _snapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addListener(() {
        if (_snapAnimation != null) {
          setState(() => _thumbOffset = _snapAnimation!.value);
          _emit();
        }
      });
  }

  @override
  void dispose() {
    _snapController.dispose();
    super.dispose();
  }

  void _emit() {
    final normalized = _maxRadius == 0
        ? Offset.zero
        : Offset(_thumbOffset.dx / _maxRadius, _thumbOffset.dy / _maxRadius);
    widget.onChanged?.call(normalized);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    var offset = _thumbOffset + details.delta;
    final distance = offset.distance;
    if (distance > _maxRadius) {
      offset = Offset.fromDirection(offset.direction, _maxRadius);
    }
    setState(() => _thumbOffset = offset);
    _emit();
  }

  void _onPanEnd(DragEndDetails details) {
    _snapAnimation = Tween<Offset>(begin: _thumbOffset, end: Offset.zero)
        .animate(CurvedAnimation(parent: _snapController, curve: Curves.easeOut));
    _snapController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final active = _thumbOffset.distance > 1;
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onPanCancel: () => _onPanEnd(DragEndDetails()),
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: PadColors.stickBase,
                border: Border.all(color: Colors.black.withOpacity(0.3), width: 2),
              ),
            ),
            // Faint ring marking the travel limit of the thumb.
            Container(
              width: widget.size - widget.thumbSize + 8,
              height: widget.size - widget.thumbSize + 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
              ),
            ),
            Transform.translate(
              offset: _thumbOffset,
              child: Container(
                width: widget.thumbSize,
                height: widget.thumbSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? PadColors.stickThumbActive : PadColors.stickThumb,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
