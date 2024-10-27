// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

/// A widget that displays a Cupertino-style snack bar.
///
/// This widget creates an animated snack bar that slides up from the bottom of the screen,
/// displays a message for a specified duration, and then slides back down.
///
/// The snack bar uses Cupertino styling to match iOS design guidelines.
class CupertinoSnackBar extends StatefulWidget {
  /// The message to display in the snack bar.
  final String message;

  /// The duration of the slide-in and slide-out animations in milliseconds.
  final int animationDurationMillis;

  /// The duration for which the snack bar remains visible in milliseconds.
  final int waitDurationMillis;

  /// Creates a [CupertinoSnackBar].
  ///
  /// All parameters are required:
  /// * [message] is the text to display in the snack bar.
  /// * [animationDurationMillis] defines how long the slide animations take.
  /// * [waitDurationMillis] sets how long the snack bar stays visible before dismissing.
  const CupertinoSnackBar({
    super.key,
    required this.message,
    required this.animationDurationMillis,
    required this.waitDurationMillis,
  });

  @override
  State<CupertinoSnackBar> createState() => _CupertinoSnackBarState();
}

class _CupertinoSnackBarState extends State<CupertinoSnackBar> {
  bool show = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => setState(() => show = true));
    Future.delayed(
      Duration(
        milliseconds: widget.waitDurationMillis,
      ),
      () {
        if (mounted) {
          setState(() => show = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: show ? 8.0 : -50.0,
      left: 8.0,
      right: 8.0,
      curve: show ? Curves.linearToEaseOut : Curves.easeInToLinear,
      duration: Duration(milliseconds: widget.animationDurationMillis),
      child: CupertinoPopupSurface(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: Text(
            widget.message,
            style: TextStyle(
              fontSize: 14.0,
              color: CupertinoColors.secondaryLabel,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
