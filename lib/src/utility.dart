import 'package:flutter/cupertino.dart';

/// Determines if the current application is a Cupertino-style app.
///
/// This function checks the widget tree for the presence of a [CupertinoApp] widget.
/// If found, it indicates that the app is using Cupertino (iOS-style) widgets.
///
/// Parameters:
///   * [context]: The [BuildContext] used to search the widget tree.
///
/// Returns:
///   A [bool] value. `true` if a [CupertinoApp] is found in the widget tree,
///   `false` otherwise.
bool isCupertinoApp(BuildContext context) =>
    context.findAncestorWidgetOfExactType<CupertinoApp>() != null;
