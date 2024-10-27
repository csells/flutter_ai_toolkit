import 'package:flutter/cupertino.dart' as cup;
import 'package:flutter/material.dart' as mat;
import 'package:flutter/widgets.dart';

import '../utility.dart';

/// A utility class for showing adaptive dialogs that match the current platform style.
class AdaptiveAlertDialog {
  /// Shows an adaptive dialog with the given [content] widget as content.
  ///
  /// This method automatically chooses between a Cupertino-style dialog for iOS
  /// and a Material-style dialog for other platforms.
  ///
  /// Parameters:
  ///   * [context]: The build context in which to show the dialog.
  ///   * [child]: The widget to display as the dialog's content.
  ///
  /// Returns a [Future] that completes with the result value when the dialog is dismissed.
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget content,
    bool barrierDismissible = false,
    List<Widget> actions = const [],
  }) =>
      isCupertinoApp(context)
          ? cup.showCupertinoDialog<T>(
              context: context,
              barrierDismissible: barrierDismissible,
              builder: (context) => cup.CupertinoAlertDialog(
                content: content,
                actions: actions,
              ),
            )
          : mat.showDialog<T>(
              context: context,
              barrierDismissible: barrierDismissible,
              builder: (context) => mat.AlertDialog(
                // insetPadding: const EdgeInsets.all(48),
                content: content,
                actions: actions,
              ),
            );
}
