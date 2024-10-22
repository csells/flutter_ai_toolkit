import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'utility.dart';

/// A utility class for showing adaptive snack bars in Flutter applications.
///
/// This class provides a static method to display snack bars that adapt to the
/// current application environment, showing either a Material Design snack bar
/// or a Cupertino-style snack bar based on the app's context.
class AdaptiveSnackBar {
  /// Shows an adaptive snack bar with the given message.
  ///
  /// This method determines whether the app is using Cupertino or Material design
  /// and displays an appropriate snack bar.
  ///
  /// Parameters:
  ///   * [context]: The build context in which to show the snack bar.
  ///   * [message]: The text message to display in the snack bar.
  static void show(BuildContext context, String message) {
    if (isCupertinoApp(context)) {
      _showCupertinoSnackBar(context: context, message: message);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  static void _showCupertinoSnackBar({
    required BuildContext context,
    required String message,
    int durationMillis = 4000,
  }) {
    const animationDurationMillis = 200;
    final overlayEntry = OverlayEntry(
      builder: (context) => _CupertinoSnackBar(
        message: message,
        animationDurationMillis: animationDurationMillis,
        waitDurationMillis: durationMillis,
      ),
    );
    Future.delayed(
      Duration(milliseconds: durationMillis + 2 * animationDurationMillis),
      overlayEntry.remove,
    );
    Overlay.of(context).insert(overlayEntry);
  }
}

class _CupertinoSnackBar extends StatefulWidget {
  final String message;
  final int animationDurationMillis;
  final int waitDurationMillis;

  const _CupertinoSnackBar({
    required this.message,
    required this.animationDurationMillis,
    required this.waitDurationMillis,
  });

  @override
  State<_CupertinoSnackBar> createState() => _CupertinoSnackBarState();
}

class _CupertinoSnackBarState extends State<_CupertinoSnackBar> {
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
