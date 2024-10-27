import 'package:flutter/widgets.dart';

import '../../styles/fat_color.dart';
import 'action_button.dart';

/// A widget that displays a horizontal bar of [ActionButton]s.
///
/// This widget creates a container with rounded corners that houses a series of
/// [ActionButton]s. The buttons are laid out horizontally and can overflow if
/// there's not enough space.
class ActionButtonBar extends StatelessWidget {
  /// Creates a [ActionButtonBar].
  ///
  /// The [buttons] parameter is required and specifies the list of
  /// [ActionButton]s to be displayed in the bar.
  const ActionButtonBar(this.buttons, {super.key});

  /// The list of [ActionButton]s to be displayed in the bar.
  final List<ActionButton> buttons;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: FatColor.darkButtonBackground,
          borderRadius: BorderRadius.circular(20),
        ),
        child: OverflowBar(
          children: buttons,
        ),
      );
}
