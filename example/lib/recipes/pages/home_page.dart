import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:go_router/go_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:split_view/split_view.dart';

import '../../gemini_api_key.dart';
import '../data/recipe_repository.dart';
import '../data/settings.dart';
import '../views/recipe_list_view.dart';
import '../views/recipe_response_view.dart';
import '../views/search_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  String _searchText = '';

  final _provider = GeminiProvider(
    generativeModel: GenerativeModel(
      model: "gemini-1.5-flash",
      apiKey: geminiApiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: Schema(
          SchemaType.object,
          properties: {
            'recipes': Schema(
              SchemaType.array,
              items: Schema(
                SchemaType.object,
                properties: {
                  'text': Schema(
                    SchemaType.string,
                  ),
                  'recipe': Schema(
                    SchemaType.object,
                    properties: {
                      'title': Schema(SchemaType.string),
                      'description': Schema(SchemaType.string),
                      'ingredients': Schema(
                        SchemaType.array,
                        items: Schema(SchemaType.string),
                      ),
                      'instructions': Schema(
                        SchemaType.array,
                        items: Schema(SchemaType.string),
                      ),
                    },
                  ),
                },
              ),
            ),
            'text': Schema(SchemaType.string),
          },
        ),
      ),
      systemInstruction: Content.system(
        '''
You are a helpful assistant that generates recipes based on the ingredients and 
instructions provided as well as my food preferences, which are as follows:
${Settings.foodPreferences.isEmpty ? 'I don\'t have any food preferences' : Settings.foodPreferences}

You should keep things casual and friendly. Feel free to mix in rich text
commentary with the recipes you generate. You may generate multiple recipes in
a single response, but only if asked. Generate each response in JSON format.
''',
      ),
    ),
  );

  final _welcomeMessage =
      'Hello and welcome to the Recipes sample app!\n\nIn this app, you can '
      'generate recipes based on the ingredients and instructions provided '
      'as well as your food preferences.\n\nIt also demonstrates several '
      'real-world use cases for the Flutter AI Toolkit.\n\nEnjoy!';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Example: Recipes'),
          actions: [
            IconButton(
              onPressed: _onAdd,
              tooltip: 'Add Recipe',
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        drawer: Builder(builder: (context) {
          return _SettingsDrawer();
        }),
        body: _SideBySideOrTabBar(
          tabs: const [
            Tab(text: 'Recipes'),
            Tab(text: 'Chat'),
          ],
          children: [
            Column(
              children: [
                SearchBox(onSearchChanged: _updateSearchText),
                Expanded(
                  child: RecipeListView(searchText: _searchText),
                ),
              ],
            ),
            LlmChatView(
              provider: _provider,
              welcomeMessage: _welcomeMessage,
              responseBuilder: (context, response) => RecipeResponseView(
                response,
              ),
            ),
          ],
        ),
      );

  void _updateSearchText(String text) => setState(() => _searchText = text);

  void _onAdd() => context.goNamed(
        'edit',
        pathParameters: {'recipe': RecipeRepository.newRecipeID},
      );
}

class _SettingsDrawer extends StatelessWidget {
  final controller = TextEditingController(
    text: Settings.foodPreferences,
  );

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          children: [
            const DrawerHeader(child: Text('Food Preferences')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter your food preferences...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OverflowBar(
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    OutlinedButton(
                      child: const Text('Save'),
                      onPressed: () {
                        Settings.setFoodPreferences(controller.text);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

class _SideBySideOrTabBar extends StatefulWidget {
  const _SideBySideOrTabBar({required this.tabs, required this.children});
  final List<Widget> tabs;
  final List<Widget> children;

  @override
  State<_SideBySideOrTabBar> createState() => _SideBySideOrTabBarState();
}

class _SideBySideOrTabBarState extends State<_SideBySideOrTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MediaQuery.of(context).size.width > 600
      ? SplitView(
          viewMode: SplitViewMode.Horizontal,
          gripColor: Colors.transparent,
          indicator: SplitIndicator(
            viewMode: SplitViewMode.Horizontal,
            color: Colors.grey,
          ),
          gripColorActive: Colors.transparent,
          activeIndicator: SplitIndicator(
            viewMode: SplitViewMode.Horizontal,
            isActive: true,
            color: Colors.black,
          ),
          children: widget.children,
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
