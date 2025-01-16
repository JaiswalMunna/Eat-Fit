// import 'package:eat_fit/views/home_screen/components/meal/meal_input.dart';
// import 'package:flutter/material.dart';
// import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';
// import 'package:eat_fit/views/home_screen/components/water_input.dart';
// import 'package:eat_fit/views/home_screen/components/weight_input.dart';
// import 'package:eat_fit/views/home_screen/diary/add_meal_screen.dart';
// import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
// import 'package:eat_fit/model/food_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

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

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(height: 10),
//                 const WaterConsumed(),
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

//                 // MealInput(
//                 //   mealType: "Breakfast",
//                 //   foods: mealFoods["Breakfast"]!,
//                 //   onAddMeal: () {
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //         builder: (context) => AddMealScreen(
//                 //           mealType: "Breakfast",
//                 //           onFoodAdded: (foods) {
//                 //             // Foods will now be automatically updated through Firestore
//                 //           },
//                 //         ),
//                 //       ),
//                 //     );
//                 //   },
//                 // ),
//                 // const SizedBox(height: 10),
//                 // MealInput(
//                 //   mealType: "Lunch",
//                 //   foods: mealFoods["Lunch"]!,
//                 //   onAddMeal: () {
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //         builder: (context) => AddMealScreen(
//                 //           mealType: "Lunch",
//                 //           onFoodAdded: (foods) {
//                 //             // Foods will now be automatically updated through Firestore
//                 //           },
//                 //         ),
//                 //       ),
//                 //     );
//                 //   },
//                 // ),
//                 // const SizedBox(height: 10),

//                 // MealInput(
//                 //   mealType: "Dinner",
//                 //   foods: mealFoods["Dinner"]!,
//                 //   onAddMeal: () {
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //         builder: (context) => AddMealScreen(
//                 //           mealType: "Dinner",
//                 //           onFoodAdded: (foods) {
//                 //             // Foods will now be automatically updated through Firestore
//                 //           },
//                 //         ),
//                 //       ),
//                 //     );
//                 //   },
//                 // ),
//                 // const SizedBox(height: 20),

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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_fit/views/home_screen/components/meal/meal_input.dart';
import 'package:flutter/material.dart';
import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';
import 'package:eat_fit/views/home_screen/components/water_input.dart';
import 'package:eat_fit/views/home_screen/components/weight_input.dart';
import 'package:eat_fit/views/home_screen/diary/add_meal_screen.dart';
import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
import 'package:eat_fit/model/food_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        .map((snapshot) => snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  'data': doc.data(),
                })
            .toList());
  }

  /// Updates the food list for a specific meal in Firestore
  Future<void> _updateMealFoods(String mealId, List<Food> updatedFoods) async {
    try {
      await _firestore.collection('meals').doc(mealId).update({
        'foods': updatedFoods.map((food) => food.toMap()).toList(),
      });
    } catch (error) {
      debugPrint("Failed to update meal foods: $error");
    }
  }

  /// Deletes a specific meal document from Firestore
  Future<void> _deleteMeal(String mealId) async {
    try {
      await _firestore.collection('meals').doc(mealId).delete();
    } catch (error) {
      debugPrint("Failed to delete meal: $error");
    }
  }

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

          // Group meals by type
          final Map<String, List<Food>> mealFoods = {
            "Breakfast": [],
            "Lunch": [],
            "Dinner": [],
          };

          final Map<String, String> mealIds = {
            "Breakfast": "",
            "Lunch": "",
            "Dinner": "",
          };

          for (var meal in meals) {
            final mealType = meal['data']['mealType'] as String;
            final foods = (meal['data']['foods'] as List<dynamic>)
                .map((foodMap) => Food.fromMap(foodMap as Map<String, dynamic>))
                .toList();

            mealFoods[mealType]?.addAll(foods);
            mealIds[mealType] = meal['id'] as String;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const WaterConsumed(),
                const SizedBox(height: 20),

                // Meal Input Sections
                const Text(
                  "Meals",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                // Breakfast Section
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
                            _updateMealFoods(mealIds["Breakfast"]!, foods);
                          },
                        ),
                      ),
                    );
                  },
                  onDeleteFood: (food) async {
                    mealFoods["Breakfast"]!.remove(food);
                    await _updateMealFoods(
                        mealIds["Breakfast"]!, mealFoods["Breakfast"]!);
                  },
                  onEditFood: (food, newGrams) async {
                    final index = mealFoods["Breakfast"]!.indexOf(food);
                    if (index != -1) {
                      mealFoods["Breakfast"]![index] = Food(
                        name: food.name,
                        calories: (food.calories * newGrams ~/ food.grams),
                        protein: (food.protein * newGrams ~/ food.grams),
                        fats: (food.fats * newGrams ~/ food.grams),
                        carbs: (food.carbs * newGrams ~/ food.grams),
                        grams: newGrams,
                      );
                      await _updateMealFoods(
                          mealIds["Breakfast"]!, mealFoods["Breakfast"]!);
                    }
                  },
                ),
                const SizedBox(height: 10),

                // Lunch Section
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
                            _updateMealFoods(mealIds["Lunch"]!, foods);
                          },
                        ),
                      ),
                    );
                  },
                  onDeleteFood: (food) async {
                    mealFoods["Lunch"]!.remove(food);
                    await _updateMealFoods(
                        mealIds["Lunch"]!, mealFoods["Lunch"]!);
                  },
                  onEditFood: (food, newGrams) async {
                    final index = mealFoods["Lunch"]!.indexOf(food);
                    if (index != -1) {
                      mealFoods["Lunch"]![index] = Food(
                        name: food.name,
                        calories: (food.calories * newGrams ~/ food.grams),
                        protein: (food.protein * newGrams ~/ food.grams),
                        fats: (food.fats * newGrams ~/ food.grams),
                        carbs: (food.carbs * newGrams ~/ food.grams),
                        grams: newGrams,
                      );
                      await _updateMealFoods(
                          mealIds["Lunch"]!, mealFoods["Lunch"]!);
                    }
                  },
                ),
                const SizedBox(height: 10),

                // Dinner Section
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
                            _updateMealFoods(mealIds["Dinner"]!, foods);
                          },
                        ),
                      ),
                    );
                  },
                  onDeleteFood: (food) async {
                    mealFoods["Dinner"]!.remove(food);
                    await _updateMealFoods(
                        mealIds["Dinner"]!, mealFoods["Dinner"]!);
                  },
                  onEditFood: (food, newGrams) async {
                    final index = mealFoods["Dinner"]!.indexOf(food);
                    if (index != -1) {
                      mealFoods["Dinner"]![index] = Food(
                        name: food.name,
                        calories: (food.calories * newGrams ~/ food.grams),
                        protein: (food.protein * newGrams ~/ food.grams),
                        fats: (food.fats * newGrams ~/ food.grams),
                        carbs: (food.carbs * newGrams ~/ food.grams),
                        grams: newGrams,
                      );
                      await _updateMealFoods(
                          mealIds["Dinner"]!, mealFoods["Dinner"]!);
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
