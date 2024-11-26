import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';

class AppState extends ChangeNotifier {
  final List<Recipe> _recipies = [];
  final Map<String, String> _users = {'test': 'test'};
  String? _currentUser;

  List<Recipe> get recipies => List.unmodifiable(_recipies);
  String? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  void addRecipe(Recipe recipe) {
    _recipies.add(recipe);
    notifyListeners();
  }

  void updateRecipe(Recipe oldRecipe, Recipe newRecipe) {
    final index = _recipies.indexOf(oldRecipe);
    if (index != -1) {
      _recipies[index] = newRecipe;
      notifyListeners();
    }
  }

  void removeRecipe(Recipe recipe) {
    _recipies.remove(recipe);
    notifyListeners();
  }

  bool signUp(String email, String password) {
    if (_users.containsKey(email)) return false;
    _users[email] = password;
    notifyListeners();
    return true;
  }

  bool login(String email, String password) {
    if (_users[email] == password) {
      _currentUser = email;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
