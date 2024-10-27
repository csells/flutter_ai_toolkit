// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import '../../llm_exception.dart';
import '../../models/llm_chat_message/llm_chat_message.dart';

/// Represents a response from an LLM (Language Learning Model).
///
/// This class manages the streaming of LLM responses, handling the
/// message appending, error handling, and cleanup.
class LlmResponse {
  /// The chat message associated with this response.
  final LlmChatMessage message;

  /// Callback function to be called when the response is complete or encounters an error.
  final void Function(LlmException? error)? onDone;

  /// The subscription to the response stream.
  StreamSubscription<String>? _subscription;

  /// Creates an LlmResponse.
  ///
  /// [stream] is the stream of text chunks from the LLM.
  /// [message] is the chat message to append the response to.
  /// [onDone] is an optional callback for when the response is complete or encounters an error.
  LlmResponse({
    required Stream<String> stream,
    required this.message,
    this.onDone,
  }) {
    _subscription = stream.listen(
      (text) => message.append(text),
      onDone: () => onDone?.call(null),
      cancelOnError: true,
      onError: _error,
    );
  }

  /// Cancels the response stream.
  void cancel() => _close(const LlmCancelException());

  /// Handles errors from the response stream.
  void _error(dynamic err) => _close(_exception(err));

  /// Converts errors to LlmExceptions.
  LlmException _exception(dynamic err) => switch (err) {
        (LlmCancelException _) => const LlmCancelException(),
        (LlmFailureException ex) => ex,
        _ => LlmFailureException(err.toString()),
      };

  /// Closes the subscription and calls the onDone callback with the given error.
  void _close(LlmException error) {
    assert(_subscription != null);
    _subscription!.cancel();
    _subscription = null;
    onDone?.call(error);
  }
}
