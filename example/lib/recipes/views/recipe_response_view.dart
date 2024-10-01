import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';

import '../data/recipe_data.dart';
import '../data/recipe_repository.dart';
import 'recipe_content_view.dart';

class RecipeResponseView extends StatelessWidget {
  const RecipeResponseView(this.response, {super.key});

  static var re = RegExp(
    '```json(?<recipe>.*?)```',
    multiLine: true,
    dotAll: true,
  );

  final String response;

  @override
  Widget build(BuildContext context) {
    // find all of the chunks of json that represent recipes
    final matches = re.allMatches(response);

    var end = 0;
    final children = <Widget>[];
    for (final match in matches) {
      // extract the text before the json
      if (match.start > end) {
        final text = response.substring(end, match.start);
        children.add(MarkdownBody(data: text));
      }

      // extract the json
      final json = match.namedGroup('recipe')!;
      final recipe = Recipe.fromJson(jsonDecode(json));
      children.add(const Gap(16));
      children.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(recipe.title, style: Theme.of(context).textTheme.titleLarge),
          Text(recipe.description),
          RecipeContentView(recipe: recipe),
        ],
      ));

      // add a button to add the recipe to the list
      children.add(const Gap(16));
      children.add(OutlinedButton(
        onPressed: () => RecipeRepository.addNewRecipe(recipe),
        child: const Text('Add Recipe'),
      ));
      children.add(const Gap(16));

      // exclude the raw json output
      end = match.end;
    }

    // add the remaining text
    if (end < response.length) {
      children.add(MarkdownBody(data: response.substring(end)));
    }

    // return the children as rows in a column
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}
