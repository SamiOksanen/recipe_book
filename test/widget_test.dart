import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book/main.dart';

void main() {
  testWidgets('A smoke test - lol', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RecipeBookApp());

    // Verify that our counter starts at 0.
    expect(find.text('No recipies yet.'), findsOneWidget);
    expect(find.text('Save'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('No recipies yet.'), findsNothing);
    expect(find.text('Save'), findsOneWidget);
  });
}
