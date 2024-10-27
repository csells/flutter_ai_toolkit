// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../dialogs/adaptive_snack_bar/adaptive_snack_bar.dart';
import '../../models/chat_view_model/chat_view_model_client.dart';
import '../../providers/interface/attachments.dart';
import '../../styles/llm_chat_view_style.dart';
import '../action_button/action_button.dart';
import '../action_button/action_button_bar.dart';

/// A widget that provides an action bar for attaching files or images.
class AttachmentActionBar extends StatefulWidget {
  /// Creates an [AttachmentActionBar].
  ///
  /// The [onAttachments] parameter is required and is called when attachments are selected.
  const AttachmentActionBar({required this.onAttachments, super.key});

  /// Callback function that is called when attachments are selected.
  ///
  /// The selected [Attachment]s are passed as an argument to this function.
  final Function(Iterable<Attachment> attachments) onAttachments;

  @override
  State<AttachmentActionBar> createState() => _AttachmentActionBarState();
}

class _AttachmentActionBarState extends State<AttachmentActionBar> {
  var _expanded = false;
  late final bool _canCamera;
  late final bool _canFile;

  @override
  void initState() {
    super.initState();
    _canCamera = ImagePicker().supportsImageSource(ImageSource.camera);

    // _canFile is a temporary work around for this bug:
    // https://github.com/csells/flutter_ai_toolkit/issues/18
    _canFile = !kIsWeb;
  }

  @override
  Widget build(BuildContext context) => ChatViewModelClient(
        builder: (context, viewModel, child) {
          final chatStyle = LlmChatViewStyle.resolve(viewModel.style);
          return _expanded
              ? ActionButtonBar(style: chatStyle, [
                  ActionButton(
                    onPressed: _onToggleMenu,
                    style: chatStyle.closeMenuButtonStyle!,
                  ),
                  if (_canCamera)
                    ActionButton(
                      onPressed: _onCamera,
                      style: chatStyle.cameraButtonStyle!,
                    ),
                  ActionButton(
                    onPressed: _onGallery,
                    style: chatStyle.galleryButtonStyle!,
                  ),
                  if (_canFile)
                    ActionButton(
                      onPressed: _onFile,
                      style: chatStyle.attachFileButtonStyle!,
                    ),
                ])
              : ActionButton(
                  onPressed: _onToggleMenu,
                  style: chatStyle.addButtonStyle!,
                );
        },
      );

  void _onToggleMenu() => setState(() => _expanded = !_expanded);
  void _onCamera() => _pickImage(ImageSource.camera);
  void _onGallery() => _pickImage(ImageSource.gallery);

  void _pickImage(ImageSource source) async {
    _onToggleMenu(); // close the menu

    final picker = ImagePicker();
    try {
      if (source == ImageSource.gallery) {
        final pics = await picker.pickMultiImage();
        final attachments = await Future.wait(pics.map(
          ImageFileAttachment.fromFile,
        ));
        widget.onAttachments(attachments);
      } else {
        final pic = await picker.pickImage(source: source);
        if (pic == null) return;
        widget.onAttachments([await ImageFileAttachment.fromFile(pic)]);
      }
    } on Exception catch (ex) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        AdaptiveSnackBar.show(context, 'Unable to pick an image: $ex');
      }
    }
  }

  void _onFile() async {
    _onToggleMenu(); // close the menu

    try {
      final files = await openFiles();
      final attachments = await Future.wait(files.map(FileAttachment.fromFile));
      widget.onAttachments(attachments);
    } on Exception catch (ex) {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        AdaptiveSnackBar.show(context, 'Unable to pick a file: $ex');
      }
    }
  }
}
