import 'package:flutter/widgets.dart';

import 'action_button_style.dart';
import 'action_button_type.dart';
import 'chat_input_style.dart';
import 'fat_colors.dart';
import 'llm_message_style.dart';
import 'user_message_style.dart';

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
  final ChatInputStyle? chatInputStyle;

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

  /// Style for the close menu button.
  final ActionButtonStyle? closeMenuButtonStyle;

  /// Creates a style object for the chat widget.
  const LlmChatViewStyle({
    this.backgroundColor,
    this.progressIndicatorColor,
    this.userMessageStyle,
    this.llmMessageStyle,
    this.chatInputStyle,
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
    this.closeMenuButtonStyle,
  });

  /// Provides default style if none is specified.
  static LlmChatViewStyle get defaultStyles => LlmChatViewStyle(
        backgroundColor: FatColors.containerBackground,
        progressIndicatorColor: FatColors.black,
        userMessageStyle: UserMessageStyle.defaultStyle,
        llmMessageStyle: LlmMessageStyle.defaultStyle,
        chatInputStyle: ChatInputStyle.defaultStyle,
        addButtonStyle: ActionButtonStyle.defaultStyle(ActionButtonType.add),
        cancelButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.cancel),
        recordButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.record),
        submitButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.submit),
        closeMenuButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.closeMenu),
        attachFileButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.attachFile),
        galleryButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.gallery),
        cameraButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.camera),
        closeButtonStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.close),
        copyButtonStyle: ActionButtonStyle.defaultStyle(ActionButtonType.copy),
        editButtonStyle: ActionButtonStyle.defaultStyle(ActionButtonType.edit),
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
      chatInputStyle: ChatInputStyle.resolve(style?.chatInputStyle,
          defaultStyle: defaultStyle.chatInputStyle),
      addButtonStyle: ActionButtonStyle.resolve(
        style?.addButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.add),
      ),
      attachFileButtonStyle: ActionButtonStyle.resolve(
        style?.attachFileButtonStyle,
        defaultStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.attachFile),
      ),
      cameraButtonStyle: ActionButtonStyle.resolve(
        style?.cameraButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.camera),
      ),
      cancelButtonStyle: ActionButtonStyle.resolve(
        style?.cancelButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.cancel),
      ),
      closeButtonStyle: ActionButtonStyle.resolve(
        style?.closeButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.close),
      ),
      copyButtonStyle: ActionButtonStyle.resolve(
        style?.copyButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.copy),
      ),
      editButtonStyle: ActionButtonStyle.resolve(
        style?.editButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.edit),
      ),
      galleryButtonStyle: ActionButtonStyle.resolve(
        style?.galleryButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.gallery),
      ),
      recordButtonStyle: ActionButtonStyle.resolve(
        style?.recordButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.record),
      ),
      submitButtonStyle: ActionButtonStyle.resolve(
        style?.submitButtonStyle,
        defaultStyle: ActionButtonStyle.defaultStyle(ActionButtonType.submit),
      ),
      closeMenuButtonStyle: ActionButtonStyle.resolve(
        style?.closeMenuButtonStyle,
        defaultStyle:
            ActionButtonStyle.defaultStyle(ActionButtonType.closeMenu),
      ),
    );
  }
}
