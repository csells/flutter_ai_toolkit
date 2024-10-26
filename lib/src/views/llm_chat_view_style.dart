import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../fat_icons.dart';
import 'fat_colors_styles.dart';

// TODO: merge this with view_styles.dart

enum _ActionButtonType {
  add,
  attachFile,
  camera,
  cancel,
  close,
  copy,
  edit,
  gallery,
  record,
  submit,
  toggle,
}

/// Style for the entire chat widget.
class LlmChatViewStyle {
  /// Background color of the entire chat widget.
  final Color? backgroundColor;

  /// The color of the progress indicator.
  final Color? progressIndicatorColor;

  /// Style for user messages.
  final UserMessageStyle? userMessageStyle;

  /// Style for LLM messages.
  final LlmMessageStyle? llmMessageStyle;

  /// Style for the input text box.
  final InputBoxStyle? inputBoxStyle;

  /// Style for the add button.
  final ActionButtonStyle? addButtonStyle;

  /// Style for the attach file button.
  final ActionButtonStyle? attachFileButtonStyle;

  /// Style for the camera button.
  final ActionButtonStyle? cameraButtonStyle;

  /// Style for the cancel button.
  final ActionButtonStyle? cancelButtonStyle;

  /// Style for the close button.
  final ActionButtonStyle? closeButtonStyle;

  /// Style for the copy button.
  final ActionButtonStyle? copyButtonStyle;

  /// Style for the edit button.
  final ActionButtonStyle? editButtonStyle;

  /// Style for the gallery button.
  final ActionButtonStyle? galleryButtonStyle;

  /// Style for the record button.
  final ActionButtonStyle? recordButtonStyle;

  /// Style for the submit button.
  final ActionButtonStyle? submitButtonStyle;

  /// Style for the toggle button.
  final ActionButtonStyle? toggleButtonStyle;

  /// Creates a style object for the chat widget.
  const LlmChatViewStyle({
    this.backgroundColor,
    this.progressIndicatorColor,
    this.userMessageStyle,
    this.llmMessageStyle,
    this.inputBoxStyle,
    this.addButtonStyle,
    this.attachFileButtonStyle,
    this.cameraButtonStyle,
    this.cancelButtonStyle,
    this.closeButtonStyle,
    this.copyButtonStyle,
    this.editButtonStyle,
    this.galleryButtonStyle,
    this.recordButtonStyle,
    this.submitButtonStyle,
    this.toggleButtonStyle,
  });

  /// Provides default style if none is specified.
  static LlmChatViewStyle get defaultStyles => LlmChatViewStyle(
        backgroundColor: FatColors.containerBackground,
        progressIndicatorColor: FatColors.black,
        userMessageStyle: UserMessageStyle.defaultStyle,
        llmMessageStyle: LlmMessageStyle.defaultStyle,
        inputBoxStyle: InputBoxStyle.defaultStyle,
        addButtonStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.add),
        cancelButtonStyle:
            ActionButtonStyle.defaultStyle(_ActionButtonType.cancel),
        recordButtonStyle:
            ActionButtonStyle.defaultStyle(_ActionButtonType.record),
        submitButtonStyle:
            ActionButtonStyle.defaultStyle(_ActionButtonType.submit),
        toggleButtonStyle:
            ActionButtonStyle.defaultStyle(_ActionButtonType.toggle),
        attachFileButtonStyle:
            ActionButtonStyle.defaultStyle(_ActionButtonType.attachFile),
        galleryButtonStyle:
            ActionButtonStyle.defaultStyle(_ActionButtonType.gallery),
        cameraButtonStyle:
            ActionButtonStyle.defaultStyle(_ActionButtonType.camera),
        closeButtonStyle:
            ActionButtonStyle.defaultStyle(_ActionButtonType.close),
        copyButtonStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.copy),
        editButtonStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.edit),
      );

  /// Resolves the LlmChatViewStyle by combining the provided style with default values.
  ///
  /// This method takes an optional [style] and merges it with the [defaultStyle].
  /// If [defaultStyle] is not provided, it uses [LlmChatViewStyle.defaultStyles].
  ///
  /// [style] - The custom LlmChatViewStyle to apply. Can be null.
  /// [defaultStyle] - The default LlmChatViewStyle to use as a base. If null, uses [LlmChatViewStyle.defaultStyles].
  ///
  /// Returns a new [LlmChatViewStyle] instance with resolved properties.
  static LlmChatViewStyle resolve(
    LlmChatViewStyle? style, {
    LlmChatViewStyle? defaultStyle,
  }) {
    defaultStyle ??= LlmChatViewStyle.defaultStyles;
    return LlmChatViewStyle(
      backgroundColor: style?.backgroundColor ?? defaultStyle.backgroundColor,
      progressIndicatorColor:
          style?.progressIndicatorColor ?? defaultStyle.progressIndicatorColor,
      userMessageStyle: UserMessageStyle.resolve(style?.userMessageStyle,
          defaultStyle: defaultStyle.userMessageStyle),
      llmMessageStyle: LlmMessageStyle.resolve(style?.llmMessageStyle,
          defaultStyle: defaultStyle.llmMessageStyle),
      inputBoxStyle: InputBoxStyle.resolve(style?.inputBoxStyle,
          defaultStyle: defaultStyle.inputBoxStyle),
      addButtonStyle: ActionButtonStyle.resolve(
        style?.addButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.add),
      ),
      attachFileButtonStyle: ActionButtonStyle.resolve(
        style?.attachFileButtonStyle,
        defaultStyle:
            ActionButtonStyle.defaultStyle(_ActionButtonType.attachFile),
      ),
      cameraButtonStyle: ActionButtonStyle.resolve(
        style?.cameraButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.camera),
      ),
      cancelButtonStyle: ActionButtonStyle.resolve(
        style?.cancelButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.cancel),
      ),
      closeButtonStyle: ActionButtonStyle.resolve(
        style?.closeButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.close),
      ),
      copyButtonStyle: ActionButtonStyle.resolve(
        style?.copyButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.copy),
      ),
      editButtonStyle: ActionButtonStyle.resolve(
        style?.editButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.edit),
      ),
      galleryButtonStyle: ActionButtonStyle.resolve(
        style?.galleryButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.gallery),
      ),
      recordButtonStyle: ActionButtonStyle.resolve(
        style?.recordButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.record),
      ),
      submitButtonStyle: ActionButtonStyle.resolve(
        style?.submitButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.submit),
      ),
      toggleButtonStyle: ActionButtonStyle.resolve(
        style?.toggleButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(_ActionButtonType.toggle),
      ),
    );
  }
}

/// Style for user messages.
class UserMessageStyle {
  /// The text style for user messages.
  final TextStyle? textStyle;

  /// The background color for user message bubbles.
  final Color? backgroundColor;

  /// The outline color for user message bubbles.
  final Color? outlineColor;

  /// The shape of user message bubbles.
  final ShapeBorder? shape;

  /// Creates a UserMessageStyle.
  const UserMessageStyle({
    this.textStyle,
    this.backgroundColor,
    this.outlineColor,
    this.shape,
  });

  /// Provides default style data for user messages.
  static UserMessageStyle get defaultStyle => UserMessageStyle(
        // TODO
        // textStyle: theme.textTheme.bodyLarge?.copyWith(
        //   color: FatColors.black,
        //   fontWeight: FontWeight.normal,
        // ),
        // backgroundColor: Colors.blue[100],
        // outlineColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      );

  /// Resolves the UserMessageStyle by combining the provided style with default values.
  ///
  /// This method takes an optional [userMessageStyle] and merges it with the
  /// [defaultStyle]. If [defaultStyle] is not provided, it uses [UserMessageStyle.defaultStyle].
  ///
  /// [userMessageStyle] - The custom UserMessageStyle to apply. Can be null.
  /// [defaultStyle] - The default UserMessageStyle to use as a base. If null, uses [UserMessageStyle.defaultStyle].
  ///
  /// Returns a new [UserMessageStyle] instance with resolved properties.
  static UserMessageStyle resolve(
    UserMessageStyle? userMessageStyle, {
    UserMessageStyle? defaultStyle,
  }) {
    defaultStyle ??= UserMessageStyle.defaultStyle;
    return UserMessageStyle(
      textStyle: userMessageStyle?.textStyle ?? defaultStyle.textStyle,
      backgroundColor:
          userMessageStyle?.backgroundColor ?? defaultStyle.backgroundColor,
      outlineColor: userMessageStyle?.outlineColor ?? defaultStyle.outlineColor,
      shape: userMessageStyle?.shape ?? defaultStyle.shape,
    );
  }
}

/// Style for LLM messages.
class LlmMessageStyle {
  /// Creates an LlmMessageStyle.
  const LlmMessageStyle({
    this.icon,
    this.iconColor,
    this.iconDecoration,
    this.decoration,
    this.markdownStyle,
  });

  /// The icon to display for the LLM messages.
  final IconData? icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The decoration for the icon.
  final Decoration? iconDecoration;

  /// The decoration for LLM message bubbles.
  final Decoration? decoration;

  /// The markdown style sheet for LLM messages.
  final MarkdownStyleSheet? markdownStyle;

  /// Provides default style for LLM messages.
  static LlmMessageStyle get defaultStyle => LlmMessageStyle(
        icon: FatIcons.spark_icon,
        iconColor: FatColors.darkIcon,
        iconDecoration: BoxDecoration(
          color: FatColors.llmIconBackground,
          shape: BoxShape.circle,
        ),
        markdownStyle: MarkdownStyleSheet(
          a: FatTextStyles.body1,
          blockquote: FatTextStyles.body1,
          checkbox: FatTextStyles.body1,
          code: FatTextStyles.code,
          del: FatTextStyles.body1,
          em: FatTextStyles.body1,
          h1: FatTextStyles.heading1,
          h2: FatTextStyles.heading2,
          h3: FatTextStyles.body1,
          h4: FatTextStyles.body1,
          h5: FatTextStyles.body1,
          h6: FatTextStyles.body1,
          listBullet: FatTextStyles.body1,
          img: FatTextStyles.body1,
          strong: FatTextStyles.body1,
          p: FatTextStyles.body1,
          tableBody: FatTextStyles.body1,
          tableHead: FatTextStyles.body1,
        ),
        decoration: BoxDecoration(
          color: FatColors.llmMessageBackground,
          border: Border.all(
            color: FatColors.llmMessageOutline,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.zero,
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      );

  /// Resolves the provided style with the default style.
  ///
  /// This method creates a new [LlmMessageStyle] by combining the provided [style]
  /// with the [defaultStyle]. If a property is not specified in the provided [style],
  /// it falls back to the corresponding property in the [defaultStyle].
  ///
  /// If [defaultStyle] is not provided, it uses [LlmMessageStyle.defaultStyle].
  ///
  /// Parameters:
  ///   - [style]: The custom style to apply. Can be null.
  ///   - [defaultStyle]: The default style to use as a fallback. If null, uses [LlmMessageStyle.defaultStyle].
  ///
  /// Returns:
  ///   A new [LlmMessageStyle] instance with resolved properties.
  static LlmMessageStyle resolve(
    LlmMessageStyle? style, {
    LlmMessageStyle? defaultStyle,
  }) {
    defaultStyle ??= LlmMessageStyle.defaultStyle;
    return LlmMessageStyle(
      icon: style?.icon ?? defaultStyle.icon,
      iconColor: style?.iconColor ?? defaultStyle.iconColor,
      iconDecoration: style?.iconDecoration ?? defaultStyle.iconDecoration,
      markdownStyle: style?.markdownStyle ?? defaultStyle.markdownStyle,
      decoration: style?.decoration ?? defaultStyle.decoration,
    );
  }
}

/// Style for the input text box.
class InputBoxStyle {
  /// Creates an InputBoxStyle.
  const InputBoxStyle({
    this.textStyle,
    this.hintStyle,
    this.hintText,
    this.backgroundColor,
    this.decoration,
  });

  /// The text style for the input text box.
  final TextStyle? textStyle;

  /// The hint text style for the input text box.
  final TextStyle? hintStyle;

  /// The hint text for the input text box.
  final String? hintText;

  /// The background color of the input box.
  final Color? backgroundColor;

  /// The shape of the input box.
  final BoxDecoration? decoration;

  /// Provides default style for the input text box.
  static InputBoxStyle get defaultStyle => InputBoxStyle(
        textStyle: FatTextStyles.body2,
        hintStyle: FatTextStyles.body2.copyWith(color: FatColors.hintText),
        hintText: "Ask me anything...",
        backgroundColor: FatColors.containerBackground,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: FatColors.outline),
          borderRadius: BorderRadius.circular(24),
        ),
      );

  /// Merges the provided styles with the default styles.
  static InputBoxStyle resolve(
    InputBoxStyle? style, {
    InputBoxStyle? defaultStyle,
  }) {
    defaultStyle ??= InputBoxStyle.defaultStyle;
    return InputBoxStyle(
      textStyle: style?.textStyle ?? defaultStyle.textStyle,
      hintStyle: style?.hintStyle ?? defaultStyle.hintStyle,
      hintText: style?.hintText ?? defaultStyle.hintText,
      backgroundColor: style?.backgroundColor ?? defaultStyle.backgroundColor,
      decoration: style?.decoration ?? defaultStyle.decoration,
    );
  }
}

/// Style for icon buttons.
class ActionButtonStyle {
  /// The icon to display for the icon button.
  final IconData? icon;

  /// The color of the icon.
  final Color? iconColor;

  /// The decoration for the icon.
  final Decoration? iconDecoration;

  /// Creates an IconButtonStyle.
  const ActionButtonStyle({
    this.icon,
    this.iconColor,
    this.iconDecoration,
  });

  /// Provides default style for icon buttons.
  static ActionButtonStyle defaultStyle(_ActionButtonType type) {
    IconData icon;
    var color = FatColors.darkIcon;
    var bgColor = FatColors.lightButtonBackground;

    switch (type) {
      case _ActionButtonType.add:
        icon = FatIcons.add;
        break;
      case _ActionButtonType.attachFile:
        icon = FatIcons.attach_file;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        break;
      case _ActionButtonType.camera:
        icon = FatIcons.camera_alt;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        break;
      case _ActionButtonType.cancel:
        icon = FatIcons.stop;
        break;
      case _ActionButtonType.close:
        icon = FatIcons.close;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        break;
      case _ActionButtonType.copy:
        icon = FatIcons.content_copy;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        break;
      case _ActionButtonType.edit:
        icon = FatIcons.edit;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        break;
      case _ActionButtonType.gallery:
        icon = FatIcons.image;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        break;
      case _ActionButtonType.record:
        icon = FatIcons.mic;
        break;
      case _ActionButtonType.submit:
        icon = FatIcons.submit_icon;
        color = FatColors.whiteIcon;
        bgColor = FatColors.darkButtonBackground;
        break;
      case _ActionButtonType.toggle:
        icon = FatIcons.close;
        color = FatColors.whiteIcon;
        bgColor = FatColors.greyBackground;
        break;
    }

    return ActionButtonStyle(
      icon: icon,
      iconColor: color,
      iconDecoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
    );
  }

  /// Resolves the IconButtonStyle by combining the provided style with default
  /// values.
  ///
  /// This method takes an optional [style] and merges it with the
  /// [defaultStyle]. If [defaultStyle] is not provided, it uses
  /// [IconButtonStyle.defaultStyle()].
  ///
  /// [style] - The custom IconButtonStyle to apply. Can be null. [defaultStyle]
  /// - The default IconButtonStyle to use as a base. If null, uses
  /// [IconButtonStyle.defaultStyle()].
  ///
  /// Returns a new [ActionButtonStyle] instance with resolved properties.
  static ActionButtonStyle resolve(
    ActionButtonStyle? style, {
    required ActionButtonStyle defaultStyle,
  }) {
    return ActionButtonStyle(
      icon: style?.icon ?? defaultStyle.icon,
      iconColor: style?.iconColor ?? defaultStyle.iconColor,
      iconDecoration: style?.iconDecoration ?? defaultStyle.iconDecoration,
    );
  }
}
