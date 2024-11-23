import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/recipe_book_app_state.dart';

class AddRecipePage extends StatefulWidget {
  final VoidCallback postSave;
  const AddRecipePage({Key? key, required this.postSave}) : super(key: key);

  @override
  _AddRecipePageState createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final List<TextEditingController> _itemControllers = [];
  final List<TextEditingController> _stepControllers = [];

  void _addItem() {
    setState(() {
      _itemControllers.add(TextEditingController());
    });
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeItem(int index) {
    setState(() {
      _itemControllers.removeAt(index);
    });
  }

  void _removeStep(int index) {
    setState(() {
      _stepControllers.removeAt(index);
    });
  }

  void _saveRecipe() {
    if (_formKey.currentState?.validate() ?? false) {
      final title = _titleController.text.trim();
      final items = _itemControllers.map((c) => c.text.trim()).toList();
      final steps = _stepControllers.map((c) => c.text.trim()).toList();

      final newRecipe = Recipe(title: title, items: items, steps: steps);

      Provider.of<RecipeBookAppState>(context, listen: false)
          .addRecipe(newRecipe);
      widget.postSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Recipe'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Title is required';
                          }
                          if (value.length > 100) {
                            return 'Title must be less than 100 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      _buildListSection(
                        'Items',
                        _itemControllers,
                        _addItem,
                        _removeItem,
                      ),
                      const SizedBox(height: 16.0),
                      _buildListSection(
                        'Steps',
                        _stepControllers,
                        _addStep,
                        _removeStep,
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _saveRecipe,
                icon: const Icon(Icons.save),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white),
              ),
            ])));
  }

  Widget _buildListSection(
    String label,
    List<TextEditingController> controllers,
    VoidCallback onAdd,
    void Function(int) onRemove,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: onAdd,
            ),
          ],
        ),
        ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex -= 1;
              final item = controllers.removeAt(oldIndex);
              controllers.insert(newIndex, item);
            });
          },
          children: controllers.asMap().entries.map((entry) {
            final index = entry.key;
            final controller = entry.value;

            return ListTile(
              key: ValueKey(controller),
              title: TextFormField(
                controller: controller,
                decoration: InputDecoration(labelText: '$label ${index + 1}'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '$label ${index + 1} is required';
                  }
                  return null;
                },
              ),
              trailing: IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () => onRemove(index),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
