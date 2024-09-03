import 'package:flutter/widgets.dart';

import 'view_styles.dart';

class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color = iconColor,
    this.size = 40,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _enabled ? color : disabledButtonColor,
          ),
          child: Icon(
            icon,
            color: _enabled ? backgroundColor : iconColor,
            size: size * 0.6,
          ),
        ),
      );

  bool get _enabled => onPressed != null;
}

class CircleButtonBar extends StatelessWidget {
  const CircleButtonBar(this.buttons, {super.key});
  final List<CircleButton> buttons;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: buttonBackground1Color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: OverflowBar(
          children: buttons,
        ),
      );
}
