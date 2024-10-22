// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ai_toolkit/src/views/circle_button.dart';
import 'package:flutter_ai_toolkit/src/views/view_styles.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';

import '../fat_icons.dart';
import '../models/chat_message.dart';
import 'attachment_view.dart';
import 'jumping_dots_progress.dart';
import 'response_builder.dart';

/// A widget that displays a single chat message with optional selection and
/// editing functionality.
///
/// This widget is responsible for rendering a chat message, handling long press
/// for selection, and providing options to edit or copy the message content.
class ChatMessageView extends StatefulWidget {
  /// Creates a ChatMessageView.
  ///
  /// The [message] parameter is required and represents the chat message to be
  /// displayed. [onEdit] is an optional callback function triggered when the
  /// edit action is selected. [onSelected] is an optional callback function
  /// that is called when the message selection state changes. [selected]
  /// indicates whether the message is currently selected.
  const ChatMessageView({
    required this.message,
    this.onEdit,
    this.onSelected,
    this.selected = false,
    this.responseBuilder,
    super.key,
  });

  /// The chat message to be displayed.
  final ChatMessage message;

  /// Callback function triggered when the edit action is selected.
  final void Function()? onEdit;

  /// Callback function called when the message selection state changes.
  final void Function(bool)? onSelected;

  /// Indicates whether the message is currently selected.
  final bool selected;

  /// A builder function that returns a widget for displaying the message.
  final ResponseBuilder? responseBuilder;

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView> {
  bool get _isUser => widget.message.origin.isUser;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: _onSelect,
        child: Column(
          children: [
            _isUser
                ? _UserMessageView(widget.message)
                : _LlmMessageView(
                    widget.message,
                    responseBuilder: widget.responseBuilder,
                  ),
            const Gap(6),
            if (widget.selected)
              Align(
                alignment:
                    _isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: CircleButtonBar(
                  _isUser
                      ? [
                          if (widget.onEdit != null)
                            CircleButton(
                              onPressed: _onEdit,
                              icon: Icons.edit,
                            ),
                          CircleButton(
                            onPressed: () => _onCopy(context),
                            icon: Icons.copy,
                          ),
                          CircleButton(
                            onPressed: _onSelect,
                            icon: Icons.close,
                            color: FatColors.greyBackground,
                          ),
                        ]
                      : [
                          CircleButton(
                            onPressed: _onSelect,
                            icon: Icons.close,
                            color: FatColors.greyBackground,
                          ),
                          CircleButton(
                            onPressed: () => _onCopy(context),
                            icon: Icons.copy,
                          ),
                        ],
                ),
              ),
          ],
        ),
      );

  void _onSelect() => widget.onSelected?.call(!widget.selected);

  void _onEdit() {
    widget.onSelected?.call(false);
    widget.onEdit?.call();
  }

  Future<void> _onCopy(BuildContext context) async {
    widget.onSelected?.call(false);
    await Clipboard.setData(ClipboardData(text: widget.message.text));

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class _UserMessageView extends StatelessWidget {
  const _UserMessageView(this.message);
  final ChatMessage message;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Flexible(flex: 2, child: SizedBox()),
          Flexible(
            flex: 6,
            child: Column(
              children: [
                ...[
                  for (final attachment in message.attachments)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          height: 80,
                          width: 200,
                          child: AttachmentView(attachment),
                        ),
                      ),
                    ),
                ],
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: FatColors.userMessageBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        message.text,
                        style: FatStyles.body1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _LlmMessageView extends StatelessWidget {
  _LlmMessageView(this.message, {ResponseBuilder? responseBuilder}) {
    this.responseBuilder = responseBuilder ?? _responseBuilder;
  }

  final ChatMessage message;
  late final ResponseBuilder responseBuilder;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Flexible(
            flex: 6,
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE5E5E5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        FatIcons.sparkIcon,
                        color: FatColors.darkIcon,
                        size: 12,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 28),
                      child: message.text.isEmpty
                          ? const SizedBox(
                              width: 24,
                              child: JumpingDotsProgress(fontSize: 24),
                            )
                          : responseBuilder(context, message.text),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Flexible(flex: 2, child: SizedBox()),
        ],
      );

  Widget _responseBuilder(BuildContext context, String response) =>
      // TODO: make this selectable
      // TODO: use the right styles
      _SelectableRegion(
        child: MarkdownBody(
          data: response,
          selectable: false,
        ),
      );
}

class _SelectableRegion extends StatelessWidget {
  const _SelectableRegion({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final SelectionRegistrar? registrar = SelectionContainer.maybeOf(context);
    if (registrar == null) return child;
    return MouseRegion(
      cursor: SystemMouseCursors.text,
      child: _SelectableAdapter(
        registrar: registrar,
        child: child,
      ),
    );
  }
}

class _SelectableAdapter extends SingleChildRenderObjectWidget {
  const _SelectableAdapter({
    required this.registrar,
    required super.child,
  });

  final SelectionRegistrar registrar;

  @override
  _RenderSelectableAdapter createRenderObject(BuildContext context) =>
      _RenderSelectableAdapter(
        DefaultSelectionStyle.of(context).selectionColor!,
        registrar,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderSelectableAdapter renderObject,
  ) =>
      renderObject
        ..selectionColor = DefaultSelectionStyle.of(context).selectionColor!
        ..registrar = registrar;
}

class _RenderSelectableAdapter extends RenderProxyBox
    with Selectable, SelectionRegistrant {
  _RenderSelectableAdapter(
    Color selectionColor,
    SelectionRegistrar registrar,
  ) : _selectionColor = selectionColor {
    this.registrar = registrar;
    _geometry.addListener(markNeedsPaint);
  }

  static const _noSelection =
      SelectionGeometry(status: SelectionStatus.none, hasContent: true);
  final _geometry = ValueNotifier<SelectionGeometry>(_noSelection);

  Color get selectionColor => _selectionColor;
  late Color _selectionColor;

  set selectionColor(Color value) {
    if (_selectionColor == value) return;
    _selectionColor = value;
    markNeedsPaint();
  }

  // ValueListenable APIs
  @override
  void addListener(VoidCallback listener) => _geometry.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      _geometry.removeListener(listener);

  @override
  SelectionGeometry get value => _geometry.value;

  // Selectable APIs
  @override
  List<Rect> get boundingBoxes => <Rect>[paintBounds];

  // Adjust this value to enlarge or shrink the selection highlight.
  static const double _padding = 10.0;
  Rect _getSelectionHighlightRect() => Rect.fromLTWH(0 - _padding, 0 - _padding,
      size.width + _padding * 2, size.height + _padding * 2);

  Offset? _start;
  Offset? _end;

  void _updateGeometry() {
    if (_start == null || _end == null) {
      _geometry.value = _noSelection;
      return;
    }

    final renderObjectRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final selectionRect = Rect.fromPoints(_start!, _end!);

    if (renderObjectRect.intersect(selectionRect).isEmpty) {
      _geometry.value = _noSelection;
    } else {
      final selectionRect = _getSelectionHighlightRect();
      final firstSelectionPoint = SelectionPoint(
        localPosition: selectionRect.bottomLeft,
        lineHeight: selectionRect.size.height,
        handleType: TextSelectionHandleType.left,
      );

      final secondSelectionPoint = SelectionPoint(
        localPosition: selectionRect.bottomRight,
        lineHeight: selectionRect.size.height,
        handleType: TextSelectionHandleType.right,
      );

      final bool isReversed;
      if (_start!.dy > _end!.dy) {
        isReversed = true;
      } else if (_start!.dy < _end!.dy) {
        isReversed = false;
      } else {
        isReversed = _start!.dx > _end!.dx;
      }

      _geometry.value = SelectionGeometry(
        status: SelectionStatus.uncollapsed,
        hasContent: true,
        startSelectionPoint:
            isReversed ? secondSelectionPoint : firstSelectionPoint,
        endSelectionPoint:
            isReversed ? firstSelectionPoint : secondSelectionPoint,
        selectionRects: <Rect>[selectionRect],
      );
    }
  }

  @override
  SelectionResult dispatchSelectionEvent(SelectionEvent event) {
    SelectionResult result = SelectionResult.none;
    switch (event.type) {
      case SelectionEventType.startEdgeUpdate:
      case SelectionEventType.endEdgeUpdate:
        final Rect renderObjectRect =
            Rect.fromLTWH(0, 0, size.width, size.height);
        // Normalize offset in case it is out side of the rect
        final Offset point =
            globalToLocal((event as SelectionEdgeUpdateEvent).globalPosition);
        final Offset adjustedPoint =
            SelectionUtils.adjustDragOffset(renderObjectRect, point);
        if (event.type == SelectionEventType.startEdgeUpdate) {
          _start = adjustedPoint;
        } else {
          _end = adjustedPoint;
        }
        result = SelectionUtils.getResultBasedOnRect(renderObjectRect, point);
      case SelectionEventType.clear:
        _start = _end = null;
      case SelectionEventType.selectAll:
      case SelectionEventType.selectWord:
      case SelectionEventType.selectParagraph:
        _start = Offset.zero;
        _end = Offset.infinite;
      case SelectionEventType.granularlyExtendSelection:
        result = SelectionResult.end;
        final GranularlyExtendSelectionEvent extendSelectionEvent =
            event as GranularlyExtendSelectionEvent;
        // Initialize the offset it there is no ongoing selection.
        if (_start == null || _end == null) {
          if (extendSelectionEvent.forward) {
            _start = _end = Offset.zero;
          } else {
            _start = _end = Offset.infinite;
          }
        }
        // Move the corresponding selection edge.
        final Offset newOffset =
            extendSelectionEvent.forward ? Offset.infinite : Offset.zero;
        if (extendSelectionEvent.isEnd) {
          if (newOffset == _end) {
            result = extendSelectionEvent.forward
                ? SelectionResult.next
                : SelectionResult.previous;
          }
          _end = newOffset;
        } else {
          if (newOffset == _start) {
            result = extendSelectionEvent.forward
                ? SelectionResult.next
                : SelectionResult.previous;
          }
          _start = newOffset;
        }
      case SelectionEventType.directionallyExtendSelection:
        result = SelectionResult.end;
        final DirectionallyExtendSelectionEvent extendSelectionEvent =
            event as DirectionallyExtendSelectionEvent;
        // Convert to local coordinates.
        final double horizontalBaseLine = globalToLocal(Offset(event.dx, 0)).dx;
        final Offset newOffset;
        final bool forward;
        switch (extendSelectionEvent.direction) {
          case SelectionExtendDirection.backward:
          case SelectionExtendDirection.previousLine:
            forward = false;
            // Initialize the offset it there is no ongoing selection.
            if (_start == null || _end == null) {
              _start = _end = Offset.infinite;
            }
            // Move the corresponding selection edge.
            if (extendSelectionEvent.direction ==
                    SelectionExtendDirection.previousLine ||
                horizontalBaseLine < 0) {
              newOffset = Offset.zero;
            } else {
              newOffset = Offset.infinite;
            }
          case SelectionExtendDirection.nextLine:
          case SelectionExtendDirection.forward:
            forward = true;
            // Initialize the offset it there is no ongoing selection.
            if (_start == null || _end == null) {
              _start = _end = Offset.zero;
            }
            // Move the corresponding selection edge.
            if (extendSelectionEvent.direction ==
                    SelectionExtendDirection.nextLine ||
                horizontalBaseLine > size.width) {
              newOffset = Offset.infinite;
            } else {
              newOffset = Offset.zero;
            }
        }
        if (extendSelectionEvent.isEnd) {
          if (newOffset == _end) {
            result = forward ? SelectionResult.next : SelectionResult.previous;
          }
          _end = newOffset;
        } else {
          if (newOffset == _start) {
            result = forward ? SelectionResult.next : SelectionResult.previous;
          }
          _start = newOffset;
        }
    }

    _updateGeometry();
    return result;
  }

  // This method is called when users want to copy selected content in this
  // widget into clipboard
  @override
  SelectedContent? getSelectedContent() => value.hasSelection
      ? const SelectedContent(plainText: 'Custom Text')
      : null;

  LayerLink? _startHandle;
  LayerLink? _endHandle;

  @override
  void pushHandleLayers(LayerLink? startHandle, LayerLink? endHandle) {
    if (_startHandle == startHandle && _endHandle == endHandle) return;
    _startHandle = startHandle;
    _endHandle = endHandle;
    markNeedsPaint();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);
    if (!_geometry.value.hasSelection) return;

    // Draw the selection highlight
    final Paint selectionPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = _selectionColor;

    context.canvas
        .drawRect(_getSelectionHighlightRect().shift(offset), selectionPaint);

    // Push the layer links if any.
    if (_startHandle != null) {
      context.pushLayer(
        LeaderLayer(
          link: _startHandle!,
          offset: offset + value.startSelectionPoint!.localPosition,
        ),
        (PaintingContext context, Offset offset) {},
        Offset.zero,
      );
    }
    if (_endHandle != null) {
      context.pushLayer(
        LeaderLayer(
          link: _endHandle!,
          offset: offset + value.endSelectionPoint!.localPosition,
        ),
        (PaintingContext context, Offset offset) {},
        Offset.zero,
      );
    }
  }

  @override
  void dispose() {
    _geometry.dispose();
    super.dispose();
  }
}
