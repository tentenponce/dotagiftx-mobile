import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTextStyles {
  static TextStyle defaultTextStyle(BuildContext context) {
    return GoogleFonts.ubuntu(
      color: Theme.of(context).colorScheme.onSurface,
      fontWeight: FontWeight.w500,
    );
  }
}
