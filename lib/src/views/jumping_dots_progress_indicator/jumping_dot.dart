import 'package:flutter/widgets.dart';

/// A widget that represents a single jumping dot in the progress indicator.
class JumpingDot extends AnimatedWidget {
  /// The color of the dot.
  final Color color;

  /// The font size of the dot.
  final double fontSize;

  /// Creates a [JumpingDot] widget.
  ///
  /// The [animation] parameter is required and controls the vertical movement of the dot.
  /// The [color] parameter sets the color of the dot.
  /// The [fontSize] parameter determines the size of the dot.
  const JumpingDot({
    super.key,
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
            height: 1, // Center the text vertically within its line height
          ),
        ),
      );
}
