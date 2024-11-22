import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';

class RecipeBookAppState extends ChangeNotifier {
  final List<Recipe> _recipies = [];

  List<Recipe> get recipies => List.unmodifiable(_recipies);

  void addRecipe(Recipe recipe) {
    _recipies.add(recipe);
    notifyListeners();
  }

  void removeRecipe(Recipe recipe) {
    _recipies.remove(recipe);
    notifyListeners();
  }
}
