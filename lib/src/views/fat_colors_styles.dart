// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class FatColors {
  static const Color transparent = Color(0x00000000);
  // static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Color 0 (#FFFFFF)
  static const Color whiteButtonBackground = Color(0xFFFFFFFF);
  static const Color containerBackground = Color(0xFFFFFFFF);
  static const Color llmMessageBackground = Color(0xFFFFFFFF);
  static const Color llmMessageOutline = Color(0xFFFFFFFF);
  static const Color whiteIcon = Color(0xFFFFFFFF);

  // Color 100 (#F5F5F5)
  static const Color userMessageBackground = Color(0xFFF5F5F5);
  static const Color fileContainerBackground = Color(0xFFF5F5F5);
  static const Color lightButtonBackground = Color(0xFFF5F5F5);
  static const Color darkButtonIcon = Color(0xFFF5F5F5);

  // Color 200 (#E5E5E5)
  static const Color outline = Color(0xFFE5E5E5);
  static const Color llmIconBackground = Color(0xFFE5E5E5);
  static const Color disabledButton = Color(0xFFE5E5E5);

  // Color 300 (#CACACA)
  static const Color hintText = Color(0xFFCACACA);
  static const Color greyButtonBackground = Color(0xFFCACACA);
  static const Color lightIcon = Color(0xFFCACACA);
  static const Color imagePlaceholder = Color(0xFFCACACA);
  static const Color lightPaginationCircle = Color(0xFFCACACA);
  static const Color lightVoiceBarLine = Color(0xFFCACACA);

  // Color 400 (#535353)
  static const Color greyBackground = Color(0xFF535353);
  static const Color llmNameText = Color(0xFF535353);

  // Color 500 (#2F2F2F)
  static const Color darkButtonBackground = Color(0xFF2F2F2F);
  static const Color darkIcon = Color(0xFF2F2F2F);
  static const Color enabledText = Color(0xFF2F2F2F);
}

abstract final class FatTextStyles {
  static final TextStyle display = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 32,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle heading1 = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle heading2 = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle body1 = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle code = GoogleFonts.robotoMono(
    color: FatColors.enabledText,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle body2 = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle label = GoogleFonts.roboto(
    color: FatColors.enabledText,
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
