// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// A library for integrating AI-powered chat functionality into Flutter
/// applications.
///
/// This library provides a set of tools and widgets to easily incorporate AI
/// language models into your Flutter app, enabling interactive chat experiences
/// with various AI providers.
///
/// Key components:
/// - LLM providers: Interfaces and implementations for different AI services.
/// - Chat UI: Ready-to-use widgets for displaying chat interfaces.
library flutter_ai_toolkit;

export 'src/providers/providers.dart';
export 'src/views/llm_chat_view.dart';

/// Computes the dot product of two embedding vectors represented as lists of
/// doubles.
///
/// This method calculates the sum of the products of corresponding elements
/// in two vectors. It's commonly used in various machine learning and natural
/// language processing tasks, such as computing similarity between
/// embeddings.
///
/// [e1] is the first vector, represented as a List<double>. [e2] is the
/// second vector, represented as a List<double>.
///
/// Both input vectors must have the same length. If they don't, this method
/// will throw a RangeError when accessing elements.
///
/// Returns a double representing the dot product of the two input vectors.
double computeDotProduct(List<double> e1, List<double> e2) {
  assert(e1.length == e2.length);

  double sum = 0.0;
  for (var i = 0; i < e1.length; ++i) {
    sum += e1[i] * e2[i];
  }

  return sum;
}
