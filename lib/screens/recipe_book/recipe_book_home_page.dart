import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/app_state.dart';
import 'package:recipe_book/screens/recipe_book/recipe_edit_page.dart';
import 'package:recipe_book/screens/recipe_book/recipe_list_page.dart';
import 'package:recipe_book/screens/recipe_book/recipe_view_page.dart';

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
      _selectedIndex = 0;
      _pageController.jumpToPage(0);
    });
  }

  void _navigateToViewPage(Recipe recipe) {
    setState(() {
      _selectedRecipe = recipe;
      _selectedIndex = 2;
      _pageController.jumpToPage(2);
    });
  }

  void _removeRecipe() {
    if (_selectedRecipe != null) {
      final appState = Provider.of<AppState>(context, listen: false);
      appState.removeRecipe(_selectedRecipe!);
      _navigateToHome();
    }
  }

  void _navigateToEdit(Recipe recipe) {
    setState(() {
      if (_selectedRecipe != recipe) {
        _selectedRecipe = recipe;
      }
      _selectedIndex = 3;
      _pageController.jumpToPage(3);
    });
  }

  void _logout() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.logout();
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
                minExtendedWidth: 160,
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
                backgroundColor:
                    Theme.of(context).colorScheme.surfaceContainerLow,
                trailing: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 160,
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout_outlined),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable swipe navigation
                children: [
                  RecipeListPage(onRecipeSelected: _navigateToViewPage),
                  RecipeEditPage(postSave: _navigateToViewPage),
                  if (_selectedRecipe != null)
                    RecipeViewPage(
                      recipe: _selectedRecipe!,
                      onClose: _navigateToHome,
                      onRemove: _removeRecipe,
                      onEdit: _navigateToEdit,
                    ),
                  if (_selectedRecipe != null)
                    RecipeEditPage(
                        recipe: _selectedRecipe!,
                        postSave: _navigateToViewPage),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
