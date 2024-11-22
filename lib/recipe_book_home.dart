import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/screens/add_page.dart';
import 'package:recipe_book/screens/recipe_list_page.dart';
import 'package:recipe_book/recipe_book_app_state.dart';

class RecipeBookHomePage extends StatefulWidget {
  const RecipeBookHomePage({super.key});

  @override
  State<RecipeBookHomePage> createState() => _RecipeBookHomePageState();
}

class _RecipeBookHomePageState extends State<RecipeBookHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<RecipeBookAppState>();
    int currentPage = appState.currentPage;
    selectedIndex = currentPage;

    void _setPage(int value) {
      setState(() {
        selectedIndex = value;
      });
      Provider.of<RecipeBookAppState>(context, listen: false).setCurrentPage(value);
    }

    Widget page;
    switch (currentPage) {
      case 0:
        page = const RecipeListPage();
        break;
      case 1:
        page = const AddPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // Provider.of<RecipeBookAppState>(context, listen: false).setCurrentPage(value);

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
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  _setPage(value);
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
