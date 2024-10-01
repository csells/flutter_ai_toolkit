import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../data/recipe_data.dart';
import 'recipe_content_view.dart';

class RecipeView extends StatelessWidget {
  const RecipeView({
    required this.recipe,
    required this.expanded,
    required this.onExpansionChanged,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final Recipe recipe;
  final bool expanded;
  final ValueChanged<bool>? onExpansionChanged;
  final Function() onEdit;
  final Function() onDelete;

  @override
  Widget build(BuildContext context) => Card(
        child: Column(
          children: [
            ExpansionTile(
              title: Text(recipe.title),
              subtitle: Text(recipe.description),
              initiallyExpanded: expanded,
              onExpansionChanged: onExpansionChanged,
              children: [
                RecipeContentView(recipe: recipe),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OverflowBar(
                    spacing: 8,
                    alignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: onDelete,
                        child: const Text('Delete'),
                      ),
                      OutlinedButton(
                        onPressed: onEdit,
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                ),
                const Gap(16),
              ],
            ),
          ],
        ),
      );
}
