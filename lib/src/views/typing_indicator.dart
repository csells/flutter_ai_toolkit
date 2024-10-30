// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/widgets.dart';

/// A widget that displays an animated typing indicator.
///
/// This widget shows a series of animated bubbles that simulate a typing
/// indicator, commonly used in chat interfaces to show that someone is
/// composing a message.
class TypingIndicator extends StatefulWidget {
  /// Creates a TypingIndicator widget.
  ///
  /// [showIndicator] determines whether the indicator is visible.
  /// [bubbleColor] sets the color of the main bubble.
  /// [flashingCircleDarkColor] and [flashingCircleBrightColor] set the colors
  /// for the flashing animation of the smaller circles.
  const TypingIndicator({
    super.key,
    this.showIndicator = false,
    this.bubbleColor = const Color(0xFF646b7f),
    this.flashingCircleDarkColor = const Color(0xFF333333),
    this.flashingCircleBrightColor = const Color(0xFFaec1dd),
  });

  /// Whether to show the typing indicator.
  final bool showIndicator;

  /// The color of the main bubble in the typing indicator.
  final Color bubbleColor;

  /// The darker color used in the flashing animation of the circles.
  final Color flashingCircleDarkColor;

  /// The brighter color used in the flashing animation of the circles.
  final Color flashingCircleBrightColor;

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _appearanceController;

  late Animation<double> _indicatorSpaceAnimation;

  late Animation<double> _smallBubbleAnimation;
  late Animation<double> _mediumBubbleAnimation;
  late Animation<double> _largeBubbleAnimation;

  late AnimationController _repeatingController;
  final List<Interval> _dotIntervals = const [
    Interval(0.25, 0.8),
    Interval(0.35, 0.9),
    Interval(0.45, 1),
  ];

  @override
  void initState() {
    super.initState();

    _appearanceController = AnimationController(
      vsync: this,
    )..addListener(() {
        setState(() {});
      });

    _indicatorSpaceAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0, 0.4, curve: Curves.easeOut),
      reverseCurve: const Interval(0, 1, curve: Curves.easeOut),
    ).drive(Tween<double>(
      begin: 0,
      end: 60,
    ));

    _smallBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0, 0.5, curve: Curves.elasticOut),
      reverseCurve: const Interval(0, 0.3, curve: Curves.easeOut),
    );
    _mediumBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.2, 0.6, curve: Curves.easeOut),
    );
    _largeBubbleAnimation = CurvedAnimation(
      parent: _appearanceController,
      curve: const Interval(0.3, 1, curve: Curves.elasticOut),
      reverseCurve: const Interval(0.5, 1, curve: Curves.easeOut),
    );

    _repeatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    if (widget.showIndicator) {
      _showIndicator();
    }
  }

  @override
  void didUpdateWidget(TypingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.showIndicator != oldWidget.showIndicator) {
      if (widget.showIndicator) {
        _showIndicator();
      } else {
        _hideIndicator();
      }
    }
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    _repeatingController.dispose();
    super.dispose();
  }

  void _showIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 750)
      ..forward();
    _repeatingController.repeat();
  }

  void _hideIndicator() {
    _appearanceController
      ..duration = const Duration(milliseconds: 150)
      ..reverse();
    _repeatingController.stop();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _indicatorSpaceAnimation,
        builder: (context, child) => SizedBox(
          height: _indicatorSpaceAnimation.value,
          child: child,
        ),
        child: Stack(
          children: [
            _AnimatedBubble(
              animation: _smallBubbleAnimation,
              left: 8,
              bottom: 8,
              bubble: _CircleBubble(
                size: 8,
                bubbleColor: widget.bubbleColor,
              ),
            ),
            _AnimatedBubble(
              animation: _mediumBubbleAnimation,
              left: 10,
              bottom: 10,
              bubble: _CircleBubble(
                size: 16,
                bubbleColor: widget.bubbleColor,
              ),
            ),
            _AnimatedBubble(
              animation: _largeBubbleAnimation,
              left: 12,
              bottom: 12,
              bubble: _StatusBubble(
                repeatingController: _repeatingController,
                dotIntervals: _dotIntervals,
                flashingCircleDarkColor: widget.flashingCircleDarkColor,
                flashingCircleBrightColor: widget.flashingCircleBrightColor,
                bubbleColor: widget.bubbleColor,
              ),
            ),
          ],
        ),
      );
}

class _CircleBubble extends StatelessWidget {
  const _CircleBubble({
    required this.size,
    required this.bubbleColor,
  });

  final double size;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bubbleColor,
        ),
      );
}

class _AnimatedBubble extends StatelessWidget {
  const _AnimatedBubble({
    required this.animation,
    required this.left,
    required this.bottom,
    required this.bubble,
  });

  final Animation<double> animation;
  final double left;
  final double bottom;
  final Widget bubble;

  @override
  Widget build(BuildContext context) => Positioned(
        left: left,
        bottom: bottom,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) => Transform.scale(
            scale: animation.value,
            alignment: Alignment.bottomLeft,
            child: child,
          ),
          child: bubble,
        ),
      );
}

class _StatusBubble extends StatelessWidget {
  const _StatusBubble({
    required this.repeatingController,
    required this.dotIntervals,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
    required this.bubbleColor,
  });

  final AnimationController repeatingController;
  final List<Interval> dotIntervals;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;
  final Color bubbleColor;

  @override
  Widget build(BuildContext context) => Container(
        width: 85,
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(27),
          color: bubbleColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _FlashingCircle(
              index: 0,
              repeatingController: repeatingController,
              dotIntervals: dotIntervals,
              flashingCircleDarkColor: flashingCircleDarkColor,
              flashingCircleBrightColor: flashingCircleBrightColor,
            ),
            _FlashingCircle(
              index: 1,
              repeatingController: repeatingController,
              dotIntervals: dotIntervals,
              flashingCircleDarkColor: flashingCircleDarkColor,
              flashingCircleBrightColor: flashingCircleBrightColor,
            ),
            _FlashingCircle(
              index: 2,
              repeatingController: repeatingController,
              dotIntervals: dotIntervals,
              flashingCircleDarkColor: flashingCircleDarkColor,
              flashingCircleBrightColor: flashingCircleBrightColor,
            ),
          ],
        ),
      );
}

class _FlashingCircle extends StatelessWidget {
  const _FlashingCircle({
    required this.index,
    required this.repeatingController,
    required this.dotIntervals,
    required this.flashingCircleBrightColor,
    required this.flashingCircleDarkColor,
  });

  final int index;
  final AnimationController repeatingController;
  final List<Interval> dotIntervals;
  final Color flashingCircleDarkColor;
  final Color flashingCircleBrightColor;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: repeatingController,
        builder: (context, child) {
          final circleFlashPercent = dotIntervals[index].transform(
            repeatingController.value,
          );
          final circleColorPercent = sin(pi * circleFlashPercent);

          return Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.lerp(
                flashingCircleDarkColor,
                flashingCircleBrightColor,
                circleColorPercent,
              ),
            ),
          );
        },
      );
}
