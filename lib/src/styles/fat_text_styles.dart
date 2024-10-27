import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'fat_colors.dart';

/// A utility class that defines text styles for the Fat design system.
abstract final class FatTextStyles {
  /// Large display text style.
  ///
  /// Used for the most prominent text elements, typically headers or titles.
  static final TextStyle display = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 32,
    fontWeight: FontWeight.w400,
  );

  /// Primary heading text style.
  ///
  /// Used for main section headings or important subheadings.
  static final TextStyle heading1 = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  /// Secondary heading text style.
  ///
  /// Used for subsection headings or less prominent titles.
  static final TextStyle heading2 = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  /// Primary body text style.
  ///
  /// Used for the main content text in the application.
  static final TextStyle body1 = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  /// Code text style.
  ///
  /// Used for displaying code snippets or monospaced text.
  static final TextStyle code = GoogleFonts.robotoMono(
    color: FatColors.enabledText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  /// Secondary body text style.
  ///
  /// Used for less prominent body text or supporting information.
  static final TextStyle body2 = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// Label text style.
  ///
  /// Used for small labels, captions, or helper text.
  static final TextStyle label = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
