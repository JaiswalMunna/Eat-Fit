// import 'package:flutter/material.dart';
// import 'package:eat_fit/model/food_model.dart';
// import 'package:eat_fit/model/mock_data.dart';

// class AddMealScreen extends StatefulWidget {
//   final String mealType;
//   final Function(Food) onFoodAdded;

//   const AddMealScreen({
//     super.key,
//     required this.mealType,
//     required this.onFoodAdded,
//   });

//   @override
//   State<AddMealScreen> createState() => _AddMealScreenState();
// }

// class _AddMealScreenState extends State<AddMealScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Food> _filteredFoods = mockFoods; // Initially display all foods
//   List<Food> _selectedFoods = []; // List to store selected foods
//   int _grams = 100;

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_filterFoods);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_filterFoods);
//     _searchController.dispose();
//     super.dispose();
//   }

//   /// Filters the food list based on the search input
//   void _filterFoods() {
//     setState(() {
//       _filteredFoods = mockFoods
//           .where((food) => food.name
//               .toLowerCase()
//               .contains(_searchController.text.trim().toLowerCase()))
//           .toList();
//     });
//   }

//   /// Displays the food details in a dialog
//   void _showFoodDetails(BuildContext context, Food food) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(food.name),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("${food.calories} Calories"),
//               Text("${food.protein}g Protein"),
//               Text("${food.fats}g Fats"),
//               Text("${food.carbs}g Carbs"),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   const Text("Grams:"),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: TextField(
//                       keyboardType: TextInputType.number,
//                       onChanged: (value) {
//                         setState(() {
//                           _grams = int.tryParse(value) ?? 100;
//                         });
//                       },
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: "100",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _selectedFoods.add(Food(
//                     name: food.name,
//                     calories: (food.calories * _grams ~/ 100),
//                     protein: (food.protein * _grams ~/ 100),
//                     fats: (food.fats * _grams ~/ 100),
//                     carbs: (food.carbs * _grams ~/ 100),
//                     grams: _grams,
//                   ));
//                 });
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SelectedFoodScreen(
//                       selectedFoods: _selectedFoods,
//                       onAddMore: () => Navigator.pop(context),
//                       onSave: () {
//                         widget.onFoodAdded(
//                             _selectedFoods.first); // Example handling
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                 );
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Search Food",
//           style: TextStyle(color: Colors.black),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 labelText: "Search food",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _filteredFoods.length,
//               itemBuilder: (context, index) {
//                 final food = _filteredFoods[index];
//                 return ListTile(
//                   title: Text(food.name),
//                   subtitle: Text("${food.calories} cal / 100 g"),
//                   onTap: () => _showFoodDetails(context, food),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SelectedFoodScreen extends StatelessWidget {
//   final List<Food> selectedFoods;
//   final VoidCallback onAddMore;
//   final VoidCallback onSave;

//   const SelectedFoodScreen({
//     super.key,
//     required this.selectedFoods,
//     required this.onAddMore,
//     required this.onSave,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final totalCalories = selectedFoods.fold<int>(
//       0,
//       (sum, food) => sum + food.calories,
//     );

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Add Meal",
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add, color: Colors.black),
//             onPressed: onAddMore,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildNutritionInfo("Calories", "$totalCalories"),
//                 _buildNutritionInfo(
//                   "Proteins",
//                   "${selectedFoods.fold<int>(0, (sum, food) => sum + food.protein)}g",
//                 ),
//                 _buildNutritionInfo(
//                   "Fats",
//                   "${selectedFoods.fold<int>(0, (sum, food) => sum + food.fats)}g",
//                 ),
//                 _buildNutritionInfo(
//                   "Carbs",
//                   "${selectedFoods.fold<int>(0, (sum, food) => sum + food.carbs)}g",
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: selectedFoods.length,
//               itemBuilder: (context, index) {
//                 final food = selectedFoods[index];
//                 return ListTile(
//                   title: Text(food.name),
//                   subtitle: Text("${food.grams} g • ${food.calories} Cal"),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: onSave,
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//                 backgroundColor: const Color(0xFF35CC8C),
//               ),
//               child: const Text("Save"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNutritionInfo(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//         Text(label, style: const TextStyle(color: Colors.grey)),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:eat_fit/model/food_model.dart';
import 'package:eat_fit/model/mock_data.dart';

class AddMealScreen extends StatefulWidget {
  final String mealType;
  final Function(List<Food>) onFoodAdded;

  const AddMealScreen({
    super.key,
    required this.mealType,
    required this.onFoodAdded,
  });

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Food> _filteredFoods = mockFoods; // Initially display all foods
  List<Food> _selectedFoods = []; // List to store selected foods
  int _grams = 100;
  bool _showAddedProducts = false; // Toggle for added products display

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterFoods);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterFoods);
    _searchController.dispose();
    super.dispose();
  }

  /// Filters the food list based on the search input
  void _filterFoods() {
    setState(() {
      _filteredFoods = mockFoods
          .where((food) => food.name
              .toLowerCase()
              .contains(_searchController.text.trim().toLowerCase()))
          .toList();
    });
  }

  /// Calculates the total nutrition for the selected foods
  Map<String, int> _calculateTotals() {
    int totalCalories = 0;
    int totalProteins = 0;
    int totalFats = 0;
    int totalCarbs = 0;

    for (final food in _selectedFoods) {
      totalCalories += food.calories;
      totalProteins += food.protein;
      totalFats += food.fats;
      totalCarbs += food.carbs;
    }

    return {
      "calories": totalCalories,
      "proteins": totalProteins,
      "fats": totalFats,
      "carbs": totalCarbs,
    };
  }

  /// Displays the food details in a dialog
  void _showFoodDetails(BuildContext context, Food food) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(food.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${food.calories} Calories"),
              Text("${food.protein}g Protein"),
              Text("${food.fats}g Fats"),
              Text("${food.carbs}g Carbs"),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text("Grams:"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _grams = int.tryParse(value) ?? 100;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "100",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedFoods.add(Food(
                    name: food.name,
                    calories: (food.calories * _grams ~/ 100),
                    protein: (food.protein * _grams ~/ 100),
                    fats: (food.fats * _grams ~/ 100),
                    carbs: (food.carbs * _grams ~/ 100),
                    grams: _grams,
                  ));
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showItemOptions(Food food) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Edit Grams"),
              onTap: () {
                Navigator.pop(context);
                _showEditGramsDialog(food);
              },
            ),
            ListTile(
              title: const Text("Remove"),
              onTap: () {
                setState(() {
                  _selectedFoods.remove(food);
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditGramsDialog(Food food) {
    final TextEditingController gramsController =
        TextEditingController(text: food.grams.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Grams for ${food.name}"),
          content: TextField(
            controller: gramsController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Enter grams",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                //     setState(() {
                //       food.grams = int.tryParse(gramsController.text) ?? food.grams;
                //     });
                //     Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totals = _calculateTotals();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Add Meal",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.fastfood, color: Colors.black),
                if (_selectedFoods.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        "${_selectedFoods.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              setState(() {
                _showAddedProducts = !_showAddedProducts;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNutritionInfo("Calories", "${totals['calories']}"),
                    _buildNutritionInfo("Proteins", "${totals['proteins']}g"),
                    _buildNutritionInfo("Fats", "${totals['fats']}g"),
                    _buildNutritionInfo("Carbs", "${totals['carbs']}g"),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.grey),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: "Search food",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredFoods.length,
                  itemBuilder: (context, index) {
                    final food = _filteredFoods[index];
                    return ListTile(
                      title: Text(food.name),
                      subtitle: Text("${food.calories} cal / 100 g"),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.green),
                        onPressed: () => _showFoodDetails(context, food),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          if (_showAddedProducts)
            GestureDetector(
              onTap: () {
                setState(() {
                  _showAddedProducts = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: Colors.white,
                    height: 300,
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: _selectedFoods.length,
                            itemBuilder: (context, index) {
                              final food = _selectedFoods[index];
                              return ListTile(
                                title: Text(food.name),
                                subtitle: Text(
                                    "${food.grams} g • ${food.calories} Cal"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () => _showItemOptions(food),
                                ),
                              );
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _showAddedProducts = false;
                            });
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF35CC8C),
        onPressed: () {
          widget.onFoodAdded(_selectedFoods);
          Navigator.pop(context);
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget _buildNutritionInfo(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:eat_fit/model/food_model.dart';
// import 'package:eat_fit/model/mock_data.dart';

// class AddMealScreen extends StatefulWidget {
//   final String mealType;
//   final Function(List<Food>) onFoodAdded;

//   const AddMealScreen({
//     super.key,
//     required this.mealType,
//     required this.onFoodAdded,
//   });

//   @override
//   State<AddMealScreen> createState() => _AddMealScreenState();
// }

// class _AddMealScreenState extends State<AddMealScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Food> _filteredFoods = mockFoods; // Initially display all foods
//   List<Food> _selectedFoods = []; // List to store selected foods
//   int _grams = 100;

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_filterFoods);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_filterFoods);
//     _searchController.dispose();
//     super.dispose();
//   }

//   /// Filters the food list based on the search input
//   void _filterFoods() {
//     setState(() {
//       _filteredFoods = mockFoods
//           .where((food) => food.name
//               .toLowerCase()
//               .contains(_searchController.text.trim().toLowerCase()))
//           .toList();
//     });
//   }

//   /// Displays the food details in a dialog
//   void _showFoodDetails(BuildContext context, Food food) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(food.name),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("${food.calories} Calories"),
//               Text("${food.protein}g Protein"),
//               Text("${food.fats}g Fats"),
//               Text("${food.carbs}g Carbs"),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   const Text("Grams:"),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: TextField(
//                       keyboardType: TextInputType.number,
//                       onChanged: (value) {
//                         setState(() {
//                           _grams = int.tryParse(value) ?? 100;
//                         });
//                       },
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: "100",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _selectedFoods.add(Food(
//                     name: food.name,
//                     calories: (food.calories * _grams ~/ 100),
//                     protein: (food.protein * _grams ~/ 100),
//                     fats: (food.fats * _grams ~/ 100),
//                     carbs: (food.carbs * _grams ~/ 100),
//                     grams: _grams,
//                   ));
//                 });
//                 Navigator.pop(context);
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// Shows a dropdown with selected items and options to edit or remove
//   void _showSelectedItemsDropdown(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Selected Foods"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: _selectedFoods.isEmpty
//                 ? [const Text("No items added yet.")]
//                 : _selectedFoods.map((food) {
//                     return ListTile(
//                       title: Text(food.name),
//                       subtitle: Text("${food.grams} g • ${food.calories} Cal"),
//                       trailing: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.edit, color: Colors.blue),
//                             onPressed: () {
//                               Navigator.pop(context);
//                               _showFoodDetails(context, food);
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () {
//                               setState(() {
//                                 _selectedFoods.remove(food);
//                               });
//                               Navigator.pop(context);
//                               _showSelectedItemsDropdown(context);
//                             },
//                           ),
//                         ],
//                       ),
//                     );
//                   }).toList(),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Close"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   /// Calculates the total calories of selected items
//   int _calculateTotalCalories() {
//     return _selectedFoods.fold<int>(
//       0,
//       (sum, food) => sum + food.calories,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalCalories = _calculateTotalCalories();

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Search Food",
//           style: TextStyle(color: Colors.black),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.list, color: Colors.black),
//             onPressed: () {
//               _showSelectedItemsDropdown(context);
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   "Total Calories: $totalCalories",
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.list_alt, color: Colors.black),
//                   onPressed: () {
//                     _showSelectedItemsDropdown(context);
//                   },
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 labelText: "Search food",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _filteredFoods.length,
//               itemBuilder: (context, index) {
//                 final food = _filteredFoods[index];
//                 return ListTile(
//                   title: Text(food.name),
//                   subtitle: Text("${food.calories} cal / 100 g"),
//                   onTap: () => _showFoodDetails(context, food),
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 widget.onFoodAdded(_selectedFoods);
//                 Navigator.pop(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(50),
//                 backgroundColor: const Color(0xFF35CC8C),
//               ),
//               child: const Text("Save"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:eat_fit/model/food_model.dart';
// import 'package:eat_fit/model/mock_data.dart';

// class AddMealScreen extends StatefulWidget {
//   final String mealType;
//   final Function(Food) onFoodAdded; // Ensure this parameter exists

//   const AddMealScreen({
//     super.key,
//     required this.mealType,
//     required this.onFoodAdded,
//   });

//   @override
//   State<AddMealScreen> createState() => _AddMealScreenState();
// }

// class _AddMealScreenState extends State<AddMealScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Food> _filteredFoods = mockFoods;
//   List<Food> _selectedFoods = [];
//   int _grams = 100;

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_filterFoods);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_filterFoods);
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _filterFoods() {
//     setState(() {
//       _filteredFoods = mockFoods
//           .where((food) => food.name
//               .toLowerCase()
//               .contains(_searchController.text.trim().toLowerCase()))
//           .toList();
//     });
//   }

//   void _showFoodDetails(BuildContext context, Food food) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(food.name),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("${food.calories} Calories"),
//               Text("${food.protein}g Protein"),
//               Text("${food.fats}g Fats"),
//               Text("${food.carbs}g Carbs"),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   const Text("Grams:"),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: TextField(
//                       keyboardType: TextInputType.number,
//                       onChanged: (value) {
//                         setState(() {
//                           _grams = int.tryParse(value) ?? 100;
//                         });
//                       },
//                       decoration: const InputDecoration(
//                         border: OutlineInputBorder(),
//                         hintText: "100",
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   final selectedFood = Food(
//                     name: food.name,
//                     calories: (food.calories * _grams ~/ 100),
//                     protein: (food.protein * _grams ~/ 100),
//                     fats: (food.fats * _grams ~/ 100),
//                     carbs: (food.carbs * _grams ~/ 100),
//                     grams: _grams,
//                   );
//                   _selectedFoods.add(selectedFood);
//                 });
//                 Navigator.pop(context);
//               },
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _saveSelectedFoods() {
//     for (final food in _selectedFoods) {
//       widget.onFoodAdded(food);
//     }
//     Navigator.pop(context); // Return to the previous screen
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(
//           widget.mealType,
//           style: const TextStyle(color: Colors.black),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 labelText: "Search food",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.search),
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _filteredFoods.length,
//               itemBuilder: (context, index) {
//                 final food = _filteredFoods[index];
//                 return ListTile(
//                   title: Text(food.name),
//                   subtitle: Text("${food.calories} cal / 100 g"),
//                   onTap: () => _showFoodDetails(context, food),
//                 );
//               },
//             ),
//           ),
//           if (_selectedFoods.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ElevatedButton(
//                 onPressed: _saveSelectedFoods,
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size.fromHeight(50),
//                   backgroundColor: const Color(0xFF35CC8C),
//                 ),
//                 child: const Text("Save"),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
