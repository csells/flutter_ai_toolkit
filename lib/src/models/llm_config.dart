// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Configuration class for the Language Model (LLM) parameters.
///
/// This class encapsulates various settings that control the behavior
/// of the LLM during text generation or processing.
class LlmConfig {
  /// Top K number of tokens to be sampled from for each decoding step.
  ///
  /// This parameter limits the selection of the next token to the top K
  /// most likely tokens, which can help in maintaining coherence and
  /// reducing the likelihood of generating nonsensical text.
  int topK = 40;

  /// Context size window for the LLM.
  ///
  /// This defines the maximum number of tokens that the model can consider
  /// as context when generating or processing text. A larger context size
  /// allows the model to consider more information but may increase
  /// computational requirements.
  int maxTokens = 1024;

  /// Randomness when decoding the next token.
  ///
  /// This value, typically between 0 and 1, controls the randomness in
  /// token selection. A higher value (e.g., 0.8) introduces more randomness
  /// and creativity, while a lower value makes the output more deterministic
  /// and focused.
  double temp = 0.8;
}
