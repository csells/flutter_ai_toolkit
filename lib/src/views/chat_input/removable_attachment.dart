import 'package:flutter/widgets.dart';

import '../../models/chat_view_model/chat_view_model_client.dart';
import '../../providers/llm_provider_interface.dart';
import '../../styles/llm_chat_view_style.dart';
import '../action_button/action_button.dart';
import '../attachment_view/attachment_view.dart';
import '../image_preview_dialog.dart';

/// A widget that displays an attachment with a remove button.
class RemovableAttachment extends StatelessWidget {
  /// Creates a [RemovableAttachment].
  ///
  /// The [attachment] parameter is required and represents the attachment to display.
  /// The [onRemove] parameter is a callback function that is called when the remove button is pressed.
  const RemovableAttachment({
    required this.attachment,
    required this.onRemove,
    super.key,
  });

  /// The attachment to display.
  final Attachment attachment;

  /// Callback function that is called when the remove button is pressed.
  ///
  /// The [Attachment] to be removed is passed as an argument to this function.
  final Function(Attachment) onRemove;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          GestureDetector(
            onTap: attachment is ImageFileAttachment
                ? () => ImagePreviewDialog.show(
                      context,
                      attachment as ImageFileAttachment,
                    )
                : null,
            child: Container(
              padding: const EdgeInsets.only(right: 12),
              height: 80,
              child: AttachmentView(attachment),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2),
            child: ChatViewModelClient(
              builder: (context, viewModel, child) {
                final chatStyle = LlmChatViewStyle.resolve(viewModel.style);
                return ActionButton(
                  style: chatStyle.closeButtonStyle!,
                  size: 20,
                  onPressed: () => onRemove(attachment),
                );
              },
            ),
          ),
        ],
      );
}
