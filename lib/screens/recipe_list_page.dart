import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/recipe_book_app_state.dart';

class RecipeListPage extends StatelessWidget {
  final void Function(Recipe recipe) onRecipeSelected;

  const RecipeListPage({super.key, required this.onRecipeSelected});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<RecipeBookAppState>();
    var recipies = appState.recipies;

    if (recipies.isEmpty) {
      return const Center(
        child: Text('No recipies yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${recipies.length} recipies:'),
        ),
        for (Recipe recipe in recipies)
          ListTile(
            title: Text(recipe.title),
            subtitle: Text(
                'Items: ${recipe.items.length}, Steps: ${recipe.steps.length}'),
            onTap: () => onRecipeSelected(recipe),
          ),
      ],
    );
  }
}
