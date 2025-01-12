import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMealScreen extends StatefulWidget {
  final String mealType; // "Breakfast", "Lunch", or "Dinner"

  const AddMealScreen({super.key, required this.mealType});

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final TextEditingController _foodSearchController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = []; // Mock search results

  void _searchFood() {
    // Example static results, replace with FatSecret or custom API call
    setState(() {
      _searchResults = [
        {
          'name': 'Apple',
          'calories': 52,
          'protein': 0.3,
          'fat': 0.2,
          'carbs': 14
        },
        {
          'name': 'Banana',
          'calories': 96,
          'protein': 1.3,
          'fat': 0.3,
          'carbs': 27
        },
      ];
    });
  }

  void _addMeal(Map<String, dynamic> food) {
    final double weight = double.tryParse(_weightController.text) ?? 0.0;

    if (weight == 0.0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid weight.")),
      );
      return;
    }

    // Calculate nutritional values based on the weight
    final double calories = (food['calories'] * weight) / 100;
    final double protein = (food['protein'] * weight) / 100;
    final double fat = (food['fat'] * weight) / 100;
    final double carbs = (food['carbs'] * weight) / 100;

    // Mock saving meal to database
    print('Meal Added: ${widget.mealType}');
    print('Food: ${food['name']}, Weight: $weight g');
    print(
        'Calories: $calories, Protein: $protein g, Fat: $fat g, Carbs: $carbs g');

    Navigator.pop(context, {
      'mealType': widget.mealType,
      'foodName': food['name'],
      'weight': weight,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Meal to ${widget.mealType}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Food Input
            TextField(
              controller: _foodSearchController,
              decoration: InputDecoration(
                labelText: 'Search Food',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchFood,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Display Search Results
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final food = _searchResults[index];
                  return ListTile(
                    title: Text(food['name']),
                    subtitle: Text(
                        'Calories: ${food['calories']} | Protein: ${food['protein']}g | Fat: ${food['fat']}g | Carbs: ${food['carbs']}g'),
                    onTap: () {
                      // Show weight input and confirm add
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title:
                              Text('Add ${food['name']} to ${widget.mealType}'),
                          content: TextField(
                            controller: _weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Enter weight (grams)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Close dialog
                                _addMeal(food);
                              },
                              child: const Text('Add'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
