// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:universal_platform/universal_platform.dart';

bool? _isCupertinoApp;

/// Determines if the current application is a Cupertino-style app.
///
/// This function checks the widget tree for the presence of a [CupertinoApp]
/// widget. If found, it indicates that the app is using Cupertino (iOS-style)
/// widgets.
///
/// Parameters:
///   * [context]: The [BuildContext] used to search the widget tree.
///
/// Returns: A [bool] value. `true` if a [CupertinoApp] is found in the widget
///   tree, `false` otherwise.
bool isCupertinoApp(BuildContext context) {
  // caching the result to avoid recomputing it on every call; it's not likely
  // to change during the lifetime of the app
  _isCupertinoApp ??=
      context.findAncestorWidgetOfExactType<CupertinoApp>() != null;
  return _isCupertinoApp!;
}

/// Determines if the current platform is a mobile device (Android or iOS).
///
/// This constant uses the [UniversalPlatform] package to check the platform.
///
/// Returns:
///   A [bool] value. `true` if the platform is either Android or iOS,
///   `false` otherwise.
final isMobile = UniversalPlatform.isAndroid || UniversalPlatform.isIOS;
