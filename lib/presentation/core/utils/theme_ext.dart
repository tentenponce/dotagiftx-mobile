import 'package:flutter/material.dart';

extension ThemeExt on String {
  Brightness? toBrightness() {
    switch (toLowerCase()) {
      case 'light':
        return Brightness.light;
      case 'dark':
        return Brightness.dark;
      default:
        return null;
    }
  }

  /// Converts a hex string like `#RRGGBB` or `#AARRGGBB` to a [Color].
  /// Returns `null` if the string is invalid.
  Color? toColor() {
    var hex = replaceAll('#', '').toUpperCase();

    if (hex.length == 6) {
      // No alpha provided → assume FF (opaque)
      hex = 'FF$hex';
    } else if (hex.length != 8) {
      return null; // Invalid format
    }

    try {
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return null;
    }
  }
}
