// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';
// import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
// import 'package:eat_fit/views/home_screen/components/water_input.dart';
// import 'package:eat_fit/views/home_screen/components/weight_input.dart';
// import 'package:eat_fit/views/home_screen/diary/add_meal_screen.dart';
// import 'package:eat_fit/views/home_screen/components/meal/meal_input.dart';
// import 'package:eat_fit/views/home_screen/components/nutrients_indicator.dart';
// import 'package:eat_fit/model/food_model.dart';

// class DiaryScreen extends StatefulWidget {
//   const DiaryScreen({super.key});

//   @override
//   State<DiaryScreen> createState() => _DiaryScreenState();
// }

// class _DiaryScreenState extends State<DiaryScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Fetch meals as a stream
//   Stream<List<Map<String, dynamic>>> _fetchMealsStream() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;

//     if (userId == null) {
//       throw Exception("User is not logged in.");
//     }

//     return _firestore
//         .collection('meals')
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList());
//   }

//   /// Calculate total nutrients
//   Map<String, int> _calculateTotals(Map<String, List<Food>> mealFoods) {
//     int totalCalories = 0;
//     int totalProteins = 0;
//     int totalFats = 0;
//     int totalCarbs = 0;

//     mealFoods.forEach((_, foods) {
//       for (final food in foods) {
//         totalCalories += food.calories;
//         totalProteins += food.protein;
//         totalFats += food.fats;
//         totalCarbs += food.carbs;
//       }
//     });

//     return {
//       'calories': totalCalories,
//       'proteins': totalProteins,
//       'fats': totalFats,
//       'carbs': totalCarbs,
//     };
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: TopAppBar(
//           onProfileTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const MyProfileScreen()),
//             );
//           },
//           onCalendarTap: () {
//             // Handle Calendar Tap
//           },
//         ),
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _fetchMealsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }

//           final meals = snapshot.data ?? [];

//           // Group meals by type
//           final Map<String, List<Food>> mealFoods = {
//             "Breakfast": [],
//             "Lunch": [],
//             "Dinner": [],
//           };

//           for (var meal in meals) {
//             final mealType = meal['mealType'] as String;
//             final foods = (meal['foods'] as List<dynamic>)
//                 .map((foodMap) => Food.fromMap(foodMap as Map<String, dynamic>))
//                 .toList();
//             mealFoods[mealType]?.addAll(foods);
//           }

//           final totals = _calculateTotals(mealFoods);

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//                 const WaterConsumed(),
//                 const SizedBox(height: 20),

//                 // Total Nutrients Section
//                 NutrientsIndicator(
//                   totalCalories: totals['calories']!,
//                   totalProteins: totals['proteins']!,
//                   totalFats: totals['fats']!,
//                   totalCarbs: totals['carbs']!,
//                 ),

//                 const SizedBox(height: 20),

//                 // Meal Input Sections
//                 const Text(
//                   "Meals",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 MealInput(
//                   mealType: "Breakfast",
//                   foods: mealFoods["Breakfast"]!,
//                   onAddMeal: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AddMealScreen(
//                           mealType: "Breakfast",
//                           onFoodAdded: (foods) {
//                             // Foods will now be automatically updated through Firestore
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   onDeleteFood: (food) {
//                     setState(() {
//                       mealFoods["Breakfast"]!.remove(food);
//                     });
//                   },
//                   onEditFood: (food, newGrams) {
//                     setState(() {
//                       final index = mealFoods["Breakfast"]!.indexOf(food);
//                       mealFoods["Breakfast"]![index] = Food(
//                         name: food.name,
//                         calories: (food.calories * newGrams ~/ food.grams),
//                         protein: food.protein,
//                         fats: food.fats,
//                         carbs: food.carbs,
//                         grams: newGrams,
//                       );
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 MealInput(
//                   mealType: "Lunch",
//                   foods: mealFoods["Lunch"]!,
//                   onAddMeal: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AddMealScreen(
//                           mealType: "Lunch",
//                           onFoodAdded: (foods) {
//                             // Foods will now be automatically updated through Firestore
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   onDeleteFood: (food) {
//                     setState(() {
//                       mealFoods["Lunch"]!.remove(food);
//                     });
//                   },
//                   onEditFood: (food, newGrams) {
//                     setState(() {
//                       final index = mealFoods["Lunch"]!.indexOf(food);
//                       mealFoods["Lunch"]![index] = Food(
//                         name: food.name,
//                         calories: (food.calories * newGrams ~/ food.grams),
//                         protein: food.protein,
//                         fats: food.fats,
//                         carbs: food.carbs,
//                         grams: newGrams,
//                       );
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 MealInput(
//                   mealType: "Dinner",
//                   foods: mealFoods["Dinner"]!,
//                   onAddMeal: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AddMealScreen(
//                           mealType: "Dinner",
//                           onFoodAdded: (foods) {
//                             // Foods will now be automatically updated through Firestore
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   onDeleteFood: (food) {
//                     setState(() {
//                       mealFoods["Dinner"]!.remove(food);
//                     });
//                   },
//                   onEditFood: (food, newGrams) {
//                     setState(() {
//                       final index = mealFoods["Dinner"]!.indexOf(food);
//                       mealFoods["Dinner"]![index] = Food(
//                         name: food.name,
//                         calories: (food.calories * newGrams ~/ food.grams),
//                         protein: food.protein,
//                         fats: food.fats,
//                         carbs: food.carbs,
//                         grams: newGrams,
//                       );
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 // Weight Section
//                 const WeightSection(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// // // --------------------------------------------------
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';
// import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
// import 'package:eat_fit/views/home_screen/components/water_input.dart';
// import 'package:eat_fit/views/home_screen/components/weight_input.dart';
// import 'package:eat_fit/views/home_screen/diary/add_meal_screen.dart';
// import 'package:eat_fit/views/home_screen/components/meal/meal_input.dart';
// import 'package:eat_fit/views/home_screen/components/nutrients_indicator.dart';
// import 'package:eat_fit/model/food_model.dart';

// class DiaryScreen extends StatefulWidget {
//   const DiaryScreen({super.key});

//   @override
//   State<DiaryScreen> createState() => _DiaryScreenState();
// }

// class _DiaryScreenState extends State<DiaryScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Fetch meals as a stream
//   Stream<List<Map<String, dynamic>>> _fetchMealsStream() {
//     final userId = FirebaseAuth.instance.currentUser?.uid;

//     if (userId == null) {
//       throw Exception("User is not logged in.");
//     }

//     return _firestore
//         .collection('meals')
//         .where('userId', isEqualTo: userId)
//         .orderBy('timestamp', descending: true)
//         .snapshots()
//         .map((snapshot) => snapshot.docs
//             .map((doc) => doc.data() as Map<String, dynamic>)
//             .toList());
//   }

//   /// Calculate total nutrients
//   Map<String, int> _calculateTotals(Map<String, List<Food>> mealFoods) {
//     int totalCalories = 0;
//     int totalProteins = 0;
//     int totalFats = 0;
//     int totalCarbs = 0;

//     mealFoods.forEach((_, foods) {
//       for (final food in foods) {
//         totalCalories += food.calories;
//         totalProteins += food.protein;
//         totalFats += food.fats;
//         totalCarbs += food.carbs;
//       }
//     });

//     return {
//       'calories': totalCalories,
//       'proteins': totalProteins,
//       'fats': totalFats,
//       'carbs': totalCarbs,
//     };
//   }

//   /// Build a row displaying the total nutrition information
//   Widget _buildNutritionInfoRow(Map<String, int> totals) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildNutritionInfo("Calories", "${totals['calories']}"),
//           _buildNutritionInfo("Proteins", "${totals['proteins']}g"),
//           _buildNutritionInfo("Fats", "${totals['fats']}g"),
//           _buildNutritionInfo("Carbs", "${totals['carbs']}g"),
//         ],
//       ),
//     );
//   }

//   /// Build individual nutrient info item
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

//   /// Edit a food item
//   Future<void> _editFood(
//       String mealType, String mealId, Food oldFood, int newGrams) async {
//     try {
//       final updatedFood = Food(
//         name: oldFood.name,
//         calories: (oldFood.calories * newGrams ~/ oldFood.grams),
//         protein: (oldFood.protein * newGrams ~/ oldFood.grams),
//         fats: (oldFood.fats * newGrams ~/ oldFood.grams),
//         carbs: (oldFood.carbs * newGrams ~/ oldFood.grams),
//         grams: newGrams,
//       );

//       await _firestore.collection('meals').doc(mealId).update({
//         'foods': FieldValue.arrayRemove([oldFood.toMap()]),
//       });

//       await _firestore.collection('meals').doc(mealId).update({
//         'foods': FieldValue.arrayUnion([updatedFood.toMap()]),
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed to edit food: $e")),
//       );
//     }
//   }

//   /// Delete a food item
//   Future<void> _deleteFood(String mealId, Food food) async {
//     try {
//       await _firestore.collection('meals').doc(mealId).update({
//         'foods': FieldValue.arrayRemove([food.toMap()]),
//       });
//     } catch (e) {
//       throw Exception("Failed to delete food: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(60),
//         child: TopAppBar(
//           onProfileTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const MyProfileScreen()),
//             );
//           },
//           onCalendarTap: () {
//             // Handle Calendar Tap
//           },
//         ),
//       ),
//       body: StreamBuilder<List<Map<String, dynamic>>>(
//         stream: _fetchMealsStream(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text("Error: ${snapshot.error}"));
//           }

//           final meals = snapshot.data ?? [];

//           // Group meals by type
//           final Map<String, List<Food>> mealFoods = {
//             "Breakfast": [],
//             "Lunch": [],
//             "Dinner": [],
//           };

//           for (var meal in meals) {
//             final mealType = meal['mealType'] as String;
//             final foods = (meal['foods'] as List<dynamic>)
//                 .map((foodMap) => Food.fromMap(foodMap as Map<String, dynamic>))
//                 .toList();
//             mealFoods[mealType]?.addAll(foods);
//           }

//           final totals = _calculateTotals(mealFoods);

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//                 const WaterConsumed(),
//                 const SizedBox(height: 20),
// // Total Nutrition Info Row
//                 const Text(
//                   "Today's Nutrition Summary",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 _buildNutritionInfoRow(totals),
//                 const SizedBox(height: 20),

//                 // // Total Nutrients Section
//                 // NutrientsIndicator(
//                 //   totalCalories: totals['calories']!,
//                 //   totalProteins: totals['proteins']!,
//                 //   totalFats: totals['fats']!,
//                 //   totalCarbs: totals['carbs']!,
//                 // ),

//                 const SizedBox(height: 20),

//                 // Meal Input Sections
//                 const Text(
//                   "Meals",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 10),
//                 MealInput(
//                   mealType: "Breakfast",
//                   foods: mealFoods["Breakfast"]!,
//                   onAddMeal: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AddMealScreen(
//                           mealType: "Breakfast",
//                           onFoodAdded: (foods) {
//                             // Foods will now be automatically updated through Firestore
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   onDeleteFood: (food) async {
//                     final mealId = meals.firstWhere(
//                       (meal) => meal['mealType'] == "Breakfast",
//                       orElse: () => {},
//                     )['id'];

//                     if (mealId != null) {
//                       try {
//                         await _deleteFood(mealId, food);
//                       } catch (e) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text("Failed to delete food: $e")),
//                         );
//                       }
//                     }
//                   },
//                   onEditFood: (food, newGrams) {
//                     setState(() {
//                       final index = mealFoods["Breakfast"]!.indexOf(food);
//                       mealFoods["Breakfast"]![index] = Food(
//                         name: food.name,
//                         calories: (food.calories * newGrams ~/ food.grams),
//                         protein: food.protein,
//                         fats: food.fats,
//                         carbs: food.carbs,
//                         grams: newGrams,
//                       );
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 MealInput(
//                   mealType: "Lunch",
//                   foods: mealFoods["Lunch"]!,
//                   onAddMeal: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AddMealScreen(
//                           mealType: "Lunch",
//                           onFoodAdded: (foods) {
//                             // Foods will now be automatically updated through Firestore
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   onDeleteFood: (food) {
//                     setState(() {
//                       mealFoods["Lunch"]!.remove(food);
//                     });
//                   },
//                   onEditFood: (food, newGrams) {
//                     setState(() {
//                       final index = mealFoods["Lunch"]!.indexOf(food);
//                       mealFoods["Lunch"]![index] = Food(
//                         name: food.name,
//                         calories: (food.calories * newGrams ~/ food.grams),
//                         protein: food.protein,
//                         fats: food.fats,
//                         carbs: food.carbs,
//                         grams: newGrams,
//                       );
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 10),
//                 MealInput(
//                   mealType: "Dinner",
//                   foods: mealFoods["Dinner"]!,
//                   onAddMeal: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => AddMealScreen(
//                           mealType: "Dinner",
//                           onFoodAdded: (foods) {
//                             // Foods will now be automatically updated through Firestore
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                   onDeleteFood: (food) {
//                     setState(() {
//                       mealFoods["Dinner"]!.remove(food);
//                     });
//                   },
//                   onEditFood: (food, newGrams) {
//                     setState(() {
//                       final index = mealFoods["Dinner"]!.indexOf(food);
//                       mealFoods["Dinner"]![index] = Food(
//                         name: food.name,
//                         calories: (food.calories * newGrams ~/ food.grams),
//                         protein: food.protein,
//                         fats: food.fats,
//                         carbs: food.carbs,
//                         grams: newGrams,
//                       );
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 20),
//                 // Weight Section
//                 const WeightSection(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';
import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
import 'package:eat_fit/views/home_screen/components/water_input.dart';
import 'package:eat_fit/views/home_screen/components/weight_input.dart';
import 'package:eat_fit/views/home_screen/diary/add_meal_screen.dart';
import 'package:eat_fit/views/home_screen/components/meal/meal_input.dart';
import 'package:eat_fit/model/food_model.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch meals as a stream
  Stream<List<Map<String, dynamic>>> _fetchMealsStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      throw Exception("User is not logged in.");
    }

    return _firestore
        .collection('meals')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              return {
                ...data,
                'id': doc.id, // Add the Firestore document ID
              };
            }).toList());
  }

  /// Calculate total nutrients
  Map<String, int> _calculateTotals(Map<String, List<Food>> mealFoods) {
    int totalCalories = 0;
    int totalProteins = 0;
    int totalFats = 0;
    int totalCarbs = 0;

    mealFoods.forEach((_, foods) {
      for (final food in foods) {
        totalCalories += food.calories;
        totalProteins += food.protein;
        totalFats += food.fats;
        totalCarbs += food.carbs;
      }
    });

    return {
      'calories': totalCalories,
      'proteins': totalProteins,
      'fats': totalFats,
      'carbs': totalCarbs,
    };
  }

  /// Build a row displaying the total nutrition information
  Widget _buildNutritionInfoRow(Map<String, int> totals) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
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
    );
  }

  /// Build individual nutrient info item
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

  /// Edit a food item
  Future<void> _editFood(String mealId, Food oldFood, int newGrams) async {
    try {
      final updatedFood = Food(
        name: oldFood.name,
        calories: (oldFood.calories * newGrams ~/ oldFood.grams),
        protein: (oldFood.protein * newGrams ~/ oldFood.grams),
        fats: (oldFood.fats * newGrams ~/ oldFood.grams),
        carbs: (oldFood.carbs * newGrams ~/ oldFood.grams),
        grams: newGrams,
      );

      await _firestore.collection('meals').doc(mealId).update({
        'foods': FieldValue.arrayRemove([oldFood.toMap()]),
      });

      await _firestore.collection('meals').doc(mealId).update({
        'foods': FieldValue.arrayUnion([updatedFood.toMap()]),
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to edit food: $e")),
      );
    }
  }

  /// Delete a food item
  Future<void> _deleteFood(String mealId, Food food) async {
    try {
      // Remove the food from Firestore
      await _firestore.collection('meals').doc(mealId).update({
        'foods': FieldValue.arrayRemove([food.toMap()]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Food item deleted successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete food: $e")),
      );
    }
  }

  // Future<void> _deleteFood(String mealId, Food food) async {
  //   try {
  //     print("Deleting food: ${food.toMap()} from mealId: $mealId");

  //     await _firestore.collection('meals').doc(mealId).update({
  //       'foods': FieldValue.arrayRemove([food.toMap()]),
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Food item deleted successfully!")),
  //     );
  //   } catch (e) {
  //     print("Failed to delete food: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to delete food: $e")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopAppBar(
          onProfileTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyProfileScreen()),
            );
          },
          onCalendarTap: () {
            // Handle Calendar Tap
          },
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _fetchMealsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final meals = snapshot.data ?? [];

          // Group meals by type and store meal IDs
          final Map<String, List<Food>> mealFoods = {
            "Breakfast": [],
            "Lunch": [],
            "Dinner": [],
          };
          final Map<String, String> mealIds = {};

          for (var meal in meals) {
            final mealType = meal['mealType'] as String;
            final foods = (meal['foods'] as List<dynamic>)
                .map((foodMap) => Food.fromMap(foodMap as Map<String, dynamic>))
                .toList();
            mealFoods[mealType]?.addAll(foods);
            mealIds[mealType] = meal['id']; // Store the meal ID
          }

          final totals = _calculateTotals(mealFoods);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const WaterConsumed(),
                const SizedBox(height: 20),

                // Total Nutrition Info Row
                const Text(
                  "Today's Nutrition Summary",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                _buildNutritionInfoRow(totals),
                const SizedBox(height: 20),

                // Meal Input Sections
                const Text(
                  "Meals",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                MealInput(
                  mealType: "Breakfast",
                  foods: mealFoods["Breakfast"]!,
                  onAddMeal: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMealScreen(
                          mealType: "Breakfast",
                          onFoodAdded: (foods) {
                            // Foods will now be automatically updated through Firestore
                          },
                        ),
                      ),
                    );
                  },
                  onDeleteFood: (food) async {
                    // Fetch the meal document with the matching mealType
                    final meal = meals.firstWhere(
                      (meal) =>
                          meal['mealType'] == "Breakfast" &&
                          (meal['foods'] as List)
                              .any((f) => Food.fromMap(f).name == food.name),
                    );

                    // Extract the meal ID
                    final mealId = meal['id'];

                    // Call the delete function
                    await _deleteFood(mealId, food);
                  },
                  // onDeleteFood: (food) async {
                  //   final mealId = mealIds["Breakfast"];
                  //   if (mealId != null) {
                  //     await _deleteFood(mealId, food);
                  //   }
                  // },
                  onEditFood: (food, newGrams) async {
                    final mealId = mealIds["Breakfast"];
                    if (mealId != null) {
                      await _editFood(mealId, food, newGrams);
                    }
                  },
                ),
                const SizedBox(height: 10),
                MealInput(
                  mealType: "Lunch",
                  foods: mealFoods["Lunch"]!,
                  onAddMeal: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMealScreen(
                          mealType: "Lunch",
                          onFoodAdded: (foods) {
                            // Foods will now be automatically updated through Firestore
                          },
                        ),
                      ),
                    );
                  },
                  onDeleteFood: (food) async {
                    // Fetch the meal document with the matching mealType
                    final meal = meals.firstWhere(
                      (meal) =>
                          meal['mealType'] == "Lunch" &&
                          (meal['foods'] as List)
                              .any((f) => Food.fromMap(f).name == food.name),
                    );

                    // Extract the meal ID
                    final mealId = meal['id'];

                    // Call the delete function
                    await _deleteFood(mealId, food);
                  },
                  // onDeleteFood: (food) async {
                  //   final mealId = mealIds["Lunch"];
                  //   if (mealId != null) {
                  //     await _deleteFood(mealId, food);
                  //   }
                  // },
                  onEditFood: (food, newGrams) async {
                    final mealId = mealIds["Lunch"];
                    if (mealId != null) {
                      await _editFood(mealId, food, newGrams);
                    }
                  },
                ),
                const SizedBox(height: 10),
                MealInput(
                  mealType: "Dinner",
                  foods: mealFoods["Dinner"]!,
                  onAddMeal: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddMealScreen(
                          mealType: "Dinner",
                          onFoodAdded: (foods) {
                            // Foods will now be automatically updated through Firestore
                          },
                        ),
                      ),
                    );
                  },
                  onDeleteFood: (food) async {
                    // Fetch the meal document with the matching mealType
                    final meal = meals.firstWhere(
                      (meal) =>
                          meal['mealType'] == "Dinner" &&
                          (meal['foods'] as List)
                              .any((f) => Food.fromMap(f).name == food.name),
                    );

                    // Extract the meal ID
                    final mealId = meal['id'];

                    // Call the delete function
                    await _deleteFood(mealId, food);
                  },
                  onEditFood: (food, newGrams) async {
                    final mealId = mealIds["Dinner"];
                    if (mealId != null) {
                      await _editFood(mealId, food, newGrams);
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Weight Section
                const WeightSection(),
              ],
            ),
          );
        },
      ),
    );
  }
}
