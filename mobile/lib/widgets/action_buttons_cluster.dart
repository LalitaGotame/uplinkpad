import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'action_button.dart';

/// The Y/X/A/B face buttons arranged in the standard Xbox diamond.
class ActionButtonsCluster extends StatelessWidget {
  const ActionButtonsCluster({
    super.key,
    this.buttonSize = 64,
    this.spacing = 8,
  });

  final double buttonSize;
  final double spacing;

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
            child: ActionButton(label: 'Y', color: PadColors.buttonY, size: buttonSize),
          ),
          Positioned(
            top: gap,
            left: gap / 2,
            child: ActionButton(label: 'A', color: PadColors.buttonA, size: buttonSize),
          ),
          Positioned(
            top: gap / 2,
            left: 0,
            child: ActionButton(label: 'X', color: PadColors.buttonX, size: buttonSize),
          ),
          Positioned(
            top: gap / 2,
            left: gap,
            child: ActionButton(label: 'B', color: PadColors.buttonB, size: buttonSize),
          ),
        ],
      ),
    );
  }
}
