import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/recipe_book_app_state.dart';
import 'package:recipe_book/recipe_book_home.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  runApp(const RecipeBookApp());
}

class RecipeBookApp extends StatelessWidget {
  const RecipeBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ChangeNotifierProvider<RecipeBookAppState>(
      create: (BuildContext context) => RecipeBookAppState(),
      child: MaterialApp(
        title: 'Recipe Book',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
          textTheme: GoogleFonts.notoSansTextTheme(textTheme).copyWith(
            titleLarge: GoogleFonts.notoSans(
              textStyle: textTheme.titleLarge,
              fontWeight: FontWeight.w500,
            ),
            labelMedium: GoogleFonts.notoSans(
              textStyle: textTheme.labelMedium,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        home: const RecipeBookHomePage(),
      ),
    );
  }
}
