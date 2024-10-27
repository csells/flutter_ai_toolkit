import 'package:flutter/widgets.dart';

import '../../models/chat_view_model/chat_view_model_client.dart';
import '../../models/llm_chat_message/llm_chat_message.dart';
import '../../styles/styles.dart';
import '../attachment_view/attachment_view.dart';

/// A widget that displays a user's message in a chat interface.
///
/// This widget is responsible for rendering the user's message, including any
/// attachments, in a right-aligned layout. It uses a [Row] and [Column] to
/// structure the content, with the message text displayed in a styled container.
class UserMessageView extends StatelessWidget {
  /// Creates a [UserMessageView].
  ///
  /// The [message] parameter is required and contains the [LlmChatMessage] to be displayed.
  const UserMessageView(this.message, {super.key});

  /// The chat message to be displayed.
  final LlmChatMessage message;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Flexible(flex: 2, child: SizedBox()),
          Flexible(
            flex: 6,
            child: Column(
              children: [
                ...[
                  for (final attachment in message.attachments)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          height: 80,
                          width: 200,
                          child: AttachmentView(attachment),
                        ),
                      ),
                    ),
                ],
                ChatViewModelClient(
                  builder: (context, viewModel, child) {
                    final userStyle = UserMessageStyle.resolve(
                      viewModel.style?.userMessageStyle,
                    );

                    return Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        decoration: userStyle.decoration,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 12,
                            bottom: 12,
                          ),
                          child: Text(message.text, style: userStyle.textStyle),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      );
}
