import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/screens/add_recipe_page.dart';
import 'package:recipe_book/screens/recipe_list_page.dart';
import 'package:recipe_book/screens/view_recipe_page.dart';

class RecipeBookHomePage extends StatefulWidget {
  const RecipeBookHomePage({super.key});

  @override
  State<RecipeBookHomePage> createState() => _RecipeBookHomePageState();
}

class _RecipeBookHomePageState extends State<RecipeBookHomePage> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  Recipe? _selectedRecipe;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToHome() {
    setState(() {
      _selectedIndex = 0; // Set the index to HomePage
      _pageController.jumpToPage(0); // Navigate to HomePage
    });
  }

  void _navigateToViewPage(Recipe recipe) {
    setState(() {
      _selectedRecipe = recipe; // Set the selected entry
      _selectedIndex = 2; // Index for ViewPage
      _pageController.jumpToPage(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  const NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  const NavigationRailDestination(
                    icon: Icon(Icons.add),
                    label: Text('Add'),
                  ),
                ],
                selectedIndex: _selectedIndex > 1 ? 0 : _selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    _selectedIndex = value;
                    _pageController
                        .jumpToPage(value); // Navigate to the selected page
                  });
                },
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                // physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
                children: [
                  RecipeListPage(onRecipeSelected: _navigateToViewPage),
                  AddRecipePage(postSave: _navigateToHome),
                  if (_selectedRecipe != null)
                    ViewRecipePage(
                        recipe: _selectedRecipe!, onClose: _navigateToHome),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
