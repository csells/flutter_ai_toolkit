// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// this file forked from https://github.com/wal33d006/progress_indicators due to
// lack of activity

import 'package:flutter/widgets.dart';

class _JumpingDot extends AnimatedWidget {
  final Color color;
  final double fontSize;

  const _JumpingDot({
    required Animation<double> animation,
    required this.color,
    required this.fontSize,
  }) : super(listenable: animation);

  Animation<double> get _animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _animation.value + fontSize,
        child: Text(
          '.',
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            // Center the text vertically within its line height
            height: 1,
          ),
        ),
      );
}

/// Creates a list with [numberOfDots] text dots, with 3 dots as default
/// default [fontSize] of 10.0, default [color] as black, [dotSpacing] (gap
/// between each dot) as 0.0 and default time for one cycle of animation
/// [milliseconds] as 250.
/// One cycle of animation is one complete round of a dot animating up and back
/// to its original position.
class JumpingDotsProgress extends StatefulWidget {
  /// Number of dots that are added in a horizontal list, default = 3.
  final int numberOfDots;

  /// Font size of each dot, default = 10.0.
  final double fontSize;

  /// Spacing between each dot, default 0.0.
  final double dotSpacing;

  /// Color of the dots, default black.
  final Color color;

  /// Time of one complete cycle of animation, default 250 milliseconds.
  final int milliseconds;

  /// The starting value for the animation tween.
  final double beginTweenValue = 0.0;

  /// The ending value for the animation tween.
  final double endTweenValue = 8.0;

  /// Creates a jumping dot progress indicator.
  const JumpingDotsProgress({
    super.key,
    this.numberOfDots = 3,
    this.fontSize = 10.0,
    required this.color,
    this.dotSpacing = 0.0,
    this.milliseconds = 250,
  });

  @override
  _JumpingDotsProgressState createState() => _JumpingDotsProgressState();
}

class _JumpingDotsProgressState extends State<JumpingDotsProgress>
    with TickerProviderStateMixin {
  final _controllers = <AnimationController>[];
  final _animations = <Animation<double>>[];
  final _widgets = <Widget>[];

  @override
  initState() {
    super.initState();

    // for each dot...
    for (var dot = 0; dot < widget.numberOfDots; dot++) {
      // add an animation controller for the dot
      _controllers.add(AnimationController(
        duration: Duration(milliseconds: widget.milliseconds),
        vsync: this,
      ));

      // build an animation for the dot using the controller
      _animations.add(
        Tween(begin: widget.beginTweenValue, end: widget.endTweenValue)
            .animate(_controllers[dot])
          ..addStatusListener((status) => _dotListener(status, dot)),
      );

      // add a dot widget with that animation
      _widgets.add(
        Padding(
          padding: EdgeInsets.only(right: widget.dotSpacing),
          child: _JumpingDot(
            animation: _animations[dot],
            fontSize: widget.fontSize,
            color: widget.color,
          ),
        ),
      );
    }

    // start the animation
    _controllers[0].forward();
  }

  void _dotListener(AnimationStatus status, int dot) {
    if (status == AnimationStatus.completed) {
      _controllers[dot].reverse();
    }

    if (dot == widget.numberOfDots - 1 && status == AnimationStatus.dismissed) {
      _controllers[0].forward();
    }

    if (_animations[dot].value > widget.endTweenValue / 2 &&
        dot < widget.numberOfDots - 1) {
      _controllers[dot + 1].forward();
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
        height: widget.fontSize + (widget.fontSize * 0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _widgets,
        ),
      );

  @override
  dispose() {
    for (var i = 0; i < widget.numberOfDots; i++) {
      _controllers[i].dispose();
    }

    super.dispose();
  }
}
