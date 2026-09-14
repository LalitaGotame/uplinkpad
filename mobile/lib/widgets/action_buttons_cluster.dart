import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'action_button.dart';

/// The Y/X/A/B face buttons arranged in the standard Xbox diamond.
/// Reports presses via [onButtonChanged] using the lowercase button
/// ids from `shared/protocol/packet_format.md` ('a', 'b', 'x', 'y').
class ActionButtonsCluster extends StatelessWidget {
  const ActionButtonsCluster({
    super.key,
    this.buttonSize = 64,
    this.spacing = 8,
    this.onButtonChanged,
  });

  final double buttonSize;
  final double spacing;
  final void Function(String button, bool pressed)? onButtonChanged;

  @override
  Widget build(BuildContext context) {
    final gap = buttonSize + spacing;
    return SizedBox(
      width: gap * 2,
      height: gap * 2,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: gap / 2,
            child: ActionButton(
              label: 'Y',
              color: PadColors.buttonY,
              size: buttonSize,
              onPressedChanged: (v) => onButtonChanged?.call('y', v),
            ),
          ),
          Positioned(
            top: gap,
            left: gap / 2,
            child: ActionButton(
              label: 'A',
              color: PadColors.buttonA,
              size: buttonSize,
              onPressedChanged: (v) => onButtonChanged?.call('a', v),
            ),
          ),
          Positioned(
            top: gap / 2,
            left: 0,
            child: ActionButton(
              label: 'X',
              color: PadColors.buttonX,
              size: buttonSize,
              onPressedChanged: (v) => onButtonChanged?.call('x', v),
            ),
          ),
          Positioned(
            top: gap / 2,
            left: gap,
            child: ActionButton(
              label: 'B',
              color: PadColors.buttonB,
              size: buttonSize,
              onPressedChanged: (v) => onButtonChanged?.call('b', v),
            ),
          ),
        ],
      ),
    );
  }
}
