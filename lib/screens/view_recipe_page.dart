import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.dart';

class ViewRecipePage extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback onClose;
  final VoidCallback onRemove;
  final void Function(Recipe recipe) onEdit;

  const ViewRecipePage({
    Key? key,
    required this.recipe,
    required this.onClose,
    required this.onRemove,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onClose, // Navigate back to HomePage
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: MediaQuery.of(context).size.height - 120,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Title:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    recipe.title,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Items:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...recipe.items.map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '- $item',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Steps:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ...recipe.steps.map((step) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          '- $step',
                          style: const TextStyle(fontSize: 16),
                        ),
                      )),
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => onEdit(recipe),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete),
                  label: const Text('Remove'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
