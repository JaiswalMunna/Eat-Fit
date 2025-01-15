// import 'package:flutter/material.dart';
// import 'diary_screen.dart';

// class AddMealScreen extends StatefulWidget {
//   const AddMealScreen({super.key});

//   @override
//   State<AddMealScreen> createState() => _AddMealScreenState();
// }

// class _AddMealScreenState extends State<AddMealScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   final List<Map<String, dynamic>> _foods = [
//     {
//       "name": "Boiled Egg",
//       "calories": 160,
//       "protein": 13,
//       "fats": 10,
//       "carbs": 1
//     },
//     {
//       "name": "Fried Eggs",
//       "calories": 191,
//       "protein": 20,
//       "fats": 15,
//       "carbs": 15
//     }
//   ];
//   final List<Map<String, dynamic>> _selectedFoods = [];
//   Map<String, dynamic>? _selectedFood;
//   int _grams = 100;

//   void _showFoodDetails(BuildContext context, Map<String, dynamic> food) {
//     setState(() {
//       _selectedFood = food;
//     });

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text(food["name"]),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text("${food["calories"]} Calories"),
//               Text("${food["protein"]}g Proteins"),
//               Text("${food["fats"]}g Fats"),
//               Text("${food["carbs"]}g Carbs"),
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
//                   _selectedFoods.add({
//                     ...food,
//                     "grams": _grams,
//                     "totalCalories": (food["calories"] * _grams / 100).round(),
//                   });
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

//   void _showSavePopup() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           title: const Center(
//             child: Column(
//               children: [
//                 Icon(Icons.celebration, size: 50, color: Colors.orange),
//                 SizedBox(height: 10),
//                 Text(
//                   "🎉 Congratulations!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           content: const Text("Your meal has been saved."),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => const DiaryScreen()),
//                   (route) => false,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF35CC8C)),
//               child: const Text("Go back to dashboard"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AddMealScreen()),
//                 );
//               },
//               child: const Text("Add more"),
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
//         title: _selectedFoods.isEmpty
//             ? const TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search for food",
//                   border: InputBorder.none,
//                 ),
//               )
//             : const Text("Add Meal", style: TextStyle(color: Colors.black)),
//         centerTitle: true,
//         actions: _selectedFoods.isEmpty
//             ? null
//             : [
//                 IconButton(
//                   icon: const Icon(Icons.add, color: Colors.black),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const AddMealScreen()),
//                     );
//                   },
//                 )
//               ],
//         leading: IconButton(
//           icon: const Icon(Icons.close, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: _selectedFoods.isEmpty
//           ? ListView(
//               children: _foods
//                   .map((food) => ListTile(
//                         title: Text(food["name"]),
//                         subtitle: Text("${food["calories"]} cal / 100 g"),
//                         onTap: () => _showFoodDetails(context, food),
//                       ))
//                   .toList(),
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _selectedFoods.length,
//                     itemBuilder: (context, index) {
//                       final food = _selectedFoods[index];
//                       return ListTile(
//                         title: Text(food["name"]),
//                         subtitle: Text(
//                             "${food["grams"]} g + ${food["totalCalories"]} Cal"),
//                         trailing: IconButton(
//                           icon: const Icon(Icons.more_vert),
//                           onPressed: () {},
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ElevatedButton(
//                     onPressed: _showSavePopup,
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size.fromHeight(50),
//                       backgroundColor: const Color(0xFF35CC8C),
//                     ),
//                     child: const Text("Save"),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:eat_fit/model/food_model.dart';
// import 'package:eat_fit/model/mock_data.dart';
// import 'diary_screen.dart';

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

//   void _showSavePopup() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           title: const Center(
//             child: Column(
//               children: [
//                 Icon(Icons.celebration, size: 50, color: Colors.orange),
//                 SizedBox(height: 10),
//                 Text(
//                   "🎉 Congratulations!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           ),
//           content: const Text("Your meal has been saved."),
//           actions: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushAndRemoveUntil(
//                   context,
//                   MaterialPageRoute(builder: (context) => const DiaryScreen()),
//                   (route) => false,
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF35CC8C)),
//               child: const Text("Go back to dashboard"),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => AddMealScreen(
//                             mealType: widget.mealType,
//                             onFoodAdded: widget.onFoodAdded,
//                           )),
//                 );
//               },
//               child: const Text("Add more"),
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
//           icon: const Icon(Icons.close, color: Colors.black),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: _selectedFoods.isEmpty
//           ? Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: TextField(
//                     controller: _searchController,
//                     decoration: const InputDecoration(
//                       labelText: "Search food",
//                       border: OutlineInputBorder(),
//                       prefixIcon: Icon(Icons.search),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _filteredFoods.length,
//                     itemBuilder: (context, index) {
//                       final food = _filteredFoods[index];
//                       return ListTile(
//                         title: Text(food.name),
//                         subtitle: Text("${food.calories} cal / 100 g"),
//                         onTap: () => _showFoodDetails(context, food),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             )
//           : Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: _selectedFoods.length,
//                     itemBuilder: (context, index) {
//                       final food = _selectedFoods[index];
//                       return ListTile(
//                         title: Text(food.name),
//                         subtitle:
//                             Text("${food.grams} g (${food.calories} cal)"),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ElevatedButton(
//                     onPressed: _showSavePopup,
//                     style: ElevatedButton.styleFrom(
//                       minimumSize: const Size.fromHeight(50),
//                       backgroundColor: const Color(0xFF35CC8C),
//                     ),
//                     child: const Text("Save"),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:eat_fit/model/food_model.dart';
import 'package:eat_fit/model/mock_data.dart';

class AddMealScreen extends StatefulWidget {
  final String mealType;
  final Function(Food) onFoodAdded;

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
  int _grams = 100;

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
                widget.onFoodAdded(Food(
                  name: food.name,
                  calories: (food.calories * _grams ~/ 100),
                  protein: (food.protein * _grams ~/ 100),
                  fats: (food.fats * _grams ~/ 100),
                  carbs: (food.carbs * _grams ~/ 100),
                  grams: _grams,
                ));
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Search Food",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
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
                  onTap: () => _showFoodDetails(context, food),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
