import 'package:flutter/widgets.dart';

import '../../styles/fat_colors.dart';

/// A widget that displays a list of chat suggestions.
///
/// This widget takes a list of suggestions and a callback function that is
/// triggered when a suggestion is selected. Each suggestion is displayed
/// as a tappable container with padding and a background color.
class ChatSuggestionsView extends StatelessWidget {
  /// Creates a [ChatSuggestionsView] widget.
  ///
  /// The [suggestions] parameter is a list of suggestion strings to display.
  /// The [onSelectSuggestion] parameter is a callback function that is called
  /// when a suggestion is tapped.
  const ChatSuggestionsView({
    required this.suggestions,
    required this.onSelectSuggestion,
    super.key,
  });

  /// The list of suggestions to display.
  final List<String> suggestions;

  /// The callback function to call when a suggestion is selected.
  final void Function(String suggestion) onSelectSuggestion;

  @override
  Widget build(BuildContext context) => Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.spaceEvenly,
        children: [
          for (final suggestion in suggestions)
            GestureDetector(
              onTap: () => onSelectSuggestion(suggestion),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: FatColors.lightButtonBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Wrap(children: [Text(suggestion)]),
                ),
              ),
            ),
        ],
      );
}
