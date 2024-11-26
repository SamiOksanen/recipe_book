import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/app_state.dart';
import 'package:recipe_book/screens/auth/login_page.dart';
import 'package:recipe_book/screens/recipe_book/recipe_book_home_page.dart';
import 'package:recipe_book/screens/auth/sign_up_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    if (!appState.isLoggedIn) {
      return LoginPage(
        onSignUp: () {
          Navigator.push(
            context,
            MaterialPageRoute<dynamic>(
              builder: (context) => SignUpPage(onSignUpComplete: () {
                Navigator.pop(context);
              }),
            ),
          );
        },
      );
    }

    return const RecipeBookHomePage(); // Main app UI
  }
}
