import 'package:flutter/material.dart';

/// Shared color palette for the controller UI. Kept dark so the pad
/// reads well against any phone bezel and doesn't wash out at night.
class PadColors {
  PadColors._();

  static const background = Color(0xFF14161C);
  static const surface = Color(0xFF1E212B);
  static const accent = Color(0xFF5B8CFF);

  static const dpad = Color(0xFF2A2E3A);
  static const dpadPressed = Color(0xFF3B4152);

  static const stickBase = Color(0xFF2A2E3A);
  static const stickThumb = Color(0xFF454C5E);
  static const stickThumbActive = Color(0xFF5B8CFF);

  static const buttonA = Color(0xFF3FA34D);
  static const buttonB = Color(0xFFD64545);
  static const buttonX = Color(0xFF3B7FD6);
  static const buttonY = Color(0xFFD6A93B);

  static const labelMuted = Color(0xFF6B7280);
}
