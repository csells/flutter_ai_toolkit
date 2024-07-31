// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Contains sliders for each configuration option for option passed to the
/// inference engine.
class InferenceConfigurationPanel extends StatelessWidget {
  const InferenceConfigurationPanel({
    required this.topK,
    required this.temp,
    required this.maxTokens,
    this.updateTopK,
    this.updateTemp,
    this.updateMaxTokens,
    super.key,
  });

  /// Top K number of tokens to be sampled from for each decoding step.
  final int topK;

  /// Handler to update [topK].
  final void Function(int)? updateTopK;

  /// Context size window for the LLM.
  final int maxTokens;

  /// Handler to update [maxTokens].
  final void Function(int)? updateMaxTokens;

  /// Randomness when decoding the next token.
  final double temp;

  /// Handler to update [temp].
  final void Function(double)? updateTemp;

  @override
  Widget build(BuildContext context) => ListView(
        children: [
          Text('Top K', style: Theme.of(context).textTheme.bodyLarge),
          Text('Number of tokens to be sampled from for each decoding step.',
              style: Theme.of(context).textTheme.bodySmall),
          Opacity(
            opacity: updateTopK == null ? 0.5 : 1,
            child: Slider(
              value: topK.toDouble(),
              min: 1,
              max: 100,
              divisions: 100,
              onChanged: (newTopK) => updateTopK?.call(newTopK.toInt()),
            ),
          ),
          Text(
            topK.toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey),
          ),
          const Divider(),
          Text('Temperature', style: Theme.of(context).textTheme.bodyLarge),
          Text('Randomness when decoding the next token.',
              style: Theme.of(context).textTheme.bodySmall),
          Opacity(
            opacity: updateTemp == null ? 0.5 : 1,
            child: Slider(
              value: temp,
              min: 0,
              max: 1,
              onChanged: updateTemp,
            ),
          ),
          Text(
            temp.roundTo(3).toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey),
          ),
          const Divider(),
          Text('Max Tokens', style: Theme.of(context).textTheme.bodyLarge),
          Text(
              'Maximum context window for the LLM. Larger windows can tax '
              'certain devices.',
              style: Theme.of(context).textTheme.bodySmall),
          Opacity(
            opacity: updateMaxTokens == null ? 0.5 : 1,
            child: Slider(
              value: maxTokens.toDouble(),
              min: 512,
              max: 8192,
              onChanged: (newMaxTokens) =>
                  updateMaxTokens?.call(newMaxTokens.toInt()),
            ),
          ),
          Text(
            maxTokens.toString(),
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.grey),
          ),
        ],
      );
}

extension on double {
  double roundTo(int decimalPlaces) =>
      double.parse(toStringAsFixed(decimalPlaces));
}
