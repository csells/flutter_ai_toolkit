import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';

class BubbleSpecialThreePlus extends StatelessWidget {
  final bool isSender;
  final Widget child;
  final bool tail;
  final Color color;
  final BoxConstraints? constraints;

  const BubbleSpecialThreePlus({
    required this.child,
    super.key,
    this.isSender = true,
    this.constraints,
    this.color = Colors.white70,
    this.tail = true,
  });

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) => Align(
        alignment: isSender ? Alignment.topRight : Alignment.topLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: CustomPaint(
            painter: SpecialChatBubbleThree(
              color: color,
              alignment: isSender ? Alignment.topRight : Alignment.topLeft,
              tail: tail,
            ),
            child: Container(
              constraints: constraints ??
                  BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * .7,
                  ),
              margin: isSender
                  ? const EdgeInsets.fromLTRB(7, 7, 17, 7)
                  : const EdgeInsets.fromLTRB(17, 7, 7, 7),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: child,
                  ),
                  const SizedBox(width: 1),
                ],
              ),
            ),
          ),
        ),
      );
}
