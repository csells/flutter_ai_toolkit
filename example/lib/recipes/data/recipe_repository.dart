// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pp;

import 'recipe_data.dart';

class RecipeRepository {
  static const newRecipeID = '__NEW_RECIPE__';
  static const _fileName = 'recipes.json';

  static const _assetFileName = 'assets/recipes_default.json';

  static List<Recipe>? _recipes;
  static final items = ValueNotifier<Iterable<Recipe>>([]);

  static Future<void> init() async {
    assert(_recipes == null, 'call init() only once');
    _recipes = await _loadRecipes();
    items.value = _recipes!;
  }

  static Iterable<Recipe> get recipes {
    assert(_recipes != null, 'call init() first');
    return _recipes!;
  }

  static Recipe getRecipe(String recipeId) {
    assert(_recipes != null, 'call init() first');
    if (recipeId == newRecipeID) return Recipe.empty(newRecipeID);
    return _recipes!.singleWhere((r) => r.id == recipeId);
  }

  static Future<void> addNewRecipe(Recipe newRecipe) async {
    assert(_recipes != null, 'call init() first');
    _recipes!.add(newRecipe);
    await _saveRecipes();
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    assert(_recipes != null, 'call init() first');
    final i = _recipes!.indexWhere((r) => r.id == recipe.id);
    assert(i >= 0);
    _recipes![i] = recipe;
    await _saveRecipes();
  }

  static Future<void> deleteRecipe(Recipe recipe) async {
    assert(_recipes != null, 'call init() first');
    final removed = _recipes!.remove(recipe);
    assert(removed);
    await _saveRecipes();
  }

  static Future<io.File> get _recipeFile async {
    final directory = await pp.getApplicationSupportDirectory();
    return io.File(path.join(directory.path, _fileName));
  }

  static Future<List<Recipe>> _loadRecipes() async {
    final recipeFile = await _recipeFile;

    // seed empty recipe file w/ example recipes
    final contents = await recipeFile.exists()
        ? await recipeFile.readAsString()
        : await rootBundle.loadString(_assetFileName);

    final jsonList = json.decode(contents) as List;
    return jsonList.map((json) => Recipe.fromJson(json)).toList();
  }

  static Future<void> _saveRecipes() async {
    final file = await _recipeFile;
    final jsonString = json.encode(recipes.map((r) => r.toJson()).toList());
    await file.writeAsString(jsonString);

    // note: this is a hack to get the UI to update
    items.value = [];
    items.value = _recipes!;
  }
}
