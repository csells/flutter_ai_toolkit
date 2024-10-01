import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../gemini_api_key.dart';
import '../data/recipe_data.dart';
import '../data/recipe_repository.dart';
import '../views/recipe_list_view.dart';
import '../views/recipe_response_view.dart';
import '../views/search_box.dart';

class ResponsiveHomePage extends StatefulWidget {
  const ResponsiveHomePage({super.key});

  @override
  _ResponsiveHomePageState createState() => _ResponsiveHomePageState();
}

class _ResponsiveHomePageState extends State<ResponsiveHomePage>
    with SingleTickerProviderStateMixin {
  String _searchText = '';

  final _provider = GeminiProvider(
    embeddingModel: GenerativeModel(
      model: 'text-embedding-004',
      apiKey: geminiApiKey,
    ),
    chatModel: GenerativeModel(
      model: "gemini-1.5-flash",
      apiKey: geminiApiKey,
      systemInstruction: Content.system(
        '''
You are a helpful assistant that generates recipes based on the ingredients and
instructions provided.

My food preferences are:
- I don't like mushrooms, tomatoes or cilantro.
- I love garlic and onions.
- I avoid milk, so I always replace that with oat milk.
- I try to keep carbs low, so I try to use appropriate substitutions.

When you generate a recipe, you should generate a JSON object with the following
structure:
{
  "title": "Recipe Title",
  "description": "Recipe Description",
  "ingredients": ["Ingredient 1", "Ingredient 2", "Ingredient 3"],
  "instructions": ["Instruction 1", "Instruction 2", "Instruction 3"]
}

You should keep things casual and friendly. Feel free to mix rich text and JSON
output.
''',
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Recipes'),
          actions: [
            IconButton(
              onPressed: _onAdd,
              tooltip: 'Add Recipe',
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: _RowOrTabBar(
          tabs: const [
            Tab(text: 'Recipes'),
            Tab(text: 'Chat'),
          ],
          children: [
            Column(
              children: [
                SearchBox(onSearchChanged: _updateSearchText),
                Expanded(child: RecipeListView(searchText: _searchText)),
              ],
            ),
            LlmChatView(
              provider: _provider,
              responseBuilder: (context, response) =>
                  RecipeResponseView(response),
              messageSender: _messageSender,
            ),
          ],
        ),
      );

  void _updateSearchText(String text) => setState(() => _searchText = text);

  void _onAdd() => context.goNamed(
        'edit',
        pathParameters: {'recipe': RecipeRepository.newRecipeID},
      );

  Stream<String> _messageSender(
    String prompt, {
    Iterable<Attachment> attachments = const [],
  }) async* {
    final buffer = StringBuffer();
    if (prompt.toLowerCase().contains('grandma')) {
      final recipe = await _searchEmbeddings(prompt);
      buffer.writeln('# Grandma\'s Recipe:');
      buffer.write(recipe.toString());
      buffer.writeln();
    }
    buffer.writeln(prompt);

    yield* _provider.sendMessageStream(
      buffer.toString(),
      attachments: attachments,
    );
  }

  List<Recipe>? _grandmasRecipes;
  List<RecipeEmbedding>? _embeddings;

  Future<Recipe?> _searchEmbeddings(String prompt) async {
    if (_embeddings == null) {
      final json = await File('../../recipes_grandma_rag.json').readAsString();
      _grandmasRecipes = await Recipe.loadFrom(json);
      _embeddings = await RecipeEmbedding.loadFrom(json);
    }

    final queryEmbedding = await _provider.getQueryEmbedding(prompt);
    Recipe? topRecipe;
    var topScore = 0.0;
    for (final recipe in _grandmasRecipes!) {
      final embedding = _embeddings!.singleWhere((e) => e.id == recipe.id);
      final score = computeDotProduct(queryEmbedding, embedding.embedding);
      if (score > topScore) {
        topScore = score;
        topRecipe = recipe;
      }
    }

    return topRecipe;
  }
}

class _RowOrTabBar extends StatefulWidget {
  const _RowOrTabBar({required this.tabs, required this.children});
  final List<Widget> tabs;
  final List<Widget> children;

  @override
  State<_RowOrTabBar> createState() => _RowOrTabBarState();
}

class _RowOrTabBarState extends State<_RowOrTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) => MediaQuery.of(context).size.width > 600
      ? Row(
          children: [for (var child in widget.children) Expanded(child: child)],
        )
      : Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: widget.tabs,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: widget.children,
              ),
            ),
          ],
        );
}
