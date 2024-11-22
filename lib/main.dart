import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/recipe_book_app_state.dart';
import 'package:recipe_book/recipe_book_home.dart';

void main() {
  runApp(const RecipeBookApp());
}

class RecipeBookApp extends StatelessWidget {
  const RecipeBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RecipeBookAppState>(
      create: (BuildContext context) => RecipeBookAppState(),
      child: MaterialApp(
        title: 'Recipe Book',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        ),
        home: const RecipeBookHomePage(),
      ),
    );
  }
}
