import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/models/recipe.dart';
import 'package:recipe_book/app_state.dart';

class RecipeEditPage extends StatefulWidget {
  final Recipe? recipe; // Existing recipe to edit, or null for adding
  final void Function(Recipe recipe) postSave;
  const RecipeEditPage({Key? key, this.recipe, required this.postSave})
      : super(key: key);

  @override
  _RecipeEditPageState createState() => _RecipeEditPageState();
}

class _RecipeEditPageState extends State<RecipeEditPage> {
  final _formKey = GlobalKey<FormState>();
  late Text _pageTitle;
  late TextEditingController _titleController;
  late List<TextEditingController> _itemControllers;
  late List<TextEditingController> _stepControllers;

  @override
  void initState() {
    super.initState();
    _pageTitle = Text(widget.recipe != null
        ? 'Edit Recipe: ' + widget.recipe!.title
        : 'Add Recipe');
    _titleController = TextEditingController(text: widget.recipe?.title ?? '');
    _itemControllers = List<TextEditingController>.from(
        widget.recipe?.items.map((c) => TextEditingController(text: c)) ?? []);
    _stepControllers = List<TextEditingController>.from(
        widget.recipe?.steps.map((c) => TextEditingController(text: c)) ?? []);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

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
      final appState = Provider.of<AppState>(context, listen: false);
      final newRecipe = Recipe(
        title: _titleController.text.trim(),
        items: _itemControllers.map((c) => c.text.trim()).toList(),
        steps: _stepControllers.map((c) => c.text.trim()).toList(),
      );

      if (widget.recipe != null) {
        appState.updateRecipe(widget.recipe!, newRecipe);
      } else {
        appState.addRecipe(newRecipe);
      }
      widget.postSave(newRecipe);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _pageTitle,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          height: MediaQuery.of(context).size.height - 120,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
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
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: _saveRecipe,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, foregroundColor: Colors.white),
          ),
        )
      ]),
    );
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
