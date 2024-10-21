import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A text field that adapts to the current app style (Material or Cupertino).
///
/// This widget will render either a [CupertinoTextField] or a [TextField]
/// depending on whether the app is using Cupertino or Material design.
class AdaptiveTextField extends StatelessWidget {
  /// Creates an adaptive text field.
  ///
  /// Many of the parameters are required to ensure consistent behavior
  /// across both Cupertino and Material designs.
  const AdaptiveTextField({
    super.key,
    required this.minLines,
    required this.maxLines,
    required this.autofocus,
    required this.style,
    required this.textInputAction,
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    required this.hintText,
    required this.hintStyle,
    required this.hintPadding,
  });

  /// The minimum number of lines to show.
  final int minLines;

  /// The maximum number of lines to show.
  final int maxLines;

  /// Whether the text field should be focused initially.
  final bool autofocus;

  /// The style to use for the text being edited.
  final TextStyle style;

  /// The type of action button to use for the keyboard.
  final TextInputAction textInputAction;

  /// Controls the text being edited.
  final TextEditingController controller;

  /// Defines the keyboard focus for this widget.
  final FocusNode focusNode;

  /// The text to show when the text field is empty.
  final String hintText;

  /// The style to use for the hint text.
  final TextStyle hintStyle;

  /// The padding to use for the hint text.
  final EdgeInsetsGeometry? hintPadding;

  /// Called when the user submits editable content.
  final void Function(String text) onSubmitted;

  @override
  Widget build(BuildContext context) => _isCupertinoApp(context)
      ? CupertinoTextField(
          minLines: minLines,
          maxLines: maxLines,
          controller: controller,
          autofocus: autofocus,
          focusNode: focusNode,
          onSubmitted: onSubmitted,
          style: style,
          decoration: null, // TODO: hint text
        )
      : TextField(
          minLines: minLines,
          maxLines: maxLines,
          controller: controller,
          autofocus: autofocus,
          focusNode: focusNode,
          textInputAction: textInputAction,
          onSubmitted: onSubmitted,
          style: style,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: hintStyle,
            contentPadding: hintPadding,
          ),
        );

  /// Determines if the current app is using Cupertino style.
  bool _isCupertinoApp(BuildContext context) =>
      context.findAncestorWidgetOfExactType<CupertinoApp>() != null;
}
