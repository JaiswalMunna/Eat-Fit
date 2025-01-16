// import 'package:eat_fit/views/home_screen/components/meal_input.dart';
// import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';
// import 'package:eat_fit/views/home_screen/components/water_input.dart';
// import 'package:eat_fit/views/home_screen/components/weight_input.dart';
// import 'package:eat_fit/views/home_screen/diary/add_meal_screen.dart';
// import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
// import 'package:flutter/material.dart';

// class DiaryScreen extends StatelessWidget {
//   const DiaryScreen({super.key});
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
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             const WaterConsumed(),
//             const SizedBox(height: 20),

//             // Meal Input Sections
//             const Text(
//               "Meals",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             MealInput(
//               mealType: "Breakfast",
//               onAddMeal: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AddMealScreen()),
//                 );
//               },
//             ),
//             const SizedBox(height: 10),
//             MealInput(
//               mealType: "Lunch",
//               onAddMeal: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AddMealScreen()),
//                 );
//               },
//             ),
//             const SizedBox(height: 10),
//             MealInput(
//               mealType: "Dinner",
//               onAddMeal: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => const AddMealScreen()),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),

//             // Weight Section
//             const WeightSection(),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:eat_fit/views/home_screen/components/meal/meal_input.dart';
import 'package:flutter/material.dart';
import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';
import 'package:eat_fit/views/home_screen/components/water_input.dart';
import 'package:eat_fit/views/home_screen/components/weight_input.dart';
import 'package:eat_fit/views/home_screen/diary/add_meal_screen.dart';
import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
import 'package:eat_fit/model/food_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
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

          for (var meal in meals) {
            final mealType = meal['mealType'] as String;
            final foods = (meal['foods'] as List<dynamic>)
                .map((foodMap) => Food.fromMap(foodMap as Map<String, dynamic>))
                .toList();
            mealFoods[mealType]?.addAll(foods);
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
