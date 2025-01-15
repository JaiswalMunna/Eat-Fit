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

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final Map<String, List<Food>> _mealFoods = {
    "Breakfast": [],
    "Lunch": [],
    "Dinner": [],
  };

  void _addFood(String mealType, Food food) {
    setState(() {
      _mealFoods[mealType]?.add(food);
    });
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
      body: SingleChildScrollView(
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
              foods: _mealFoods["Breakfast"]!,
              onAddMeal: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMealScreen(
                      mealType: "Breakfast",
                      onFoodAdded: (food) => _addFood("Breakfast", food),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            MealInput(
              mealType: "Lunch",
              foods: _mealFoods["Lunch"]!,
              onAddMeal: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMealScreen(
                      mealType: "Lunch",
                      onFoodAdded: (food) => _addFood("Lunch", food),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            MealInput(
              mealType: "Dinner",
              foods: _mealFoods["Dinner"]!,
              onAddMeal: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMealScreen(
                      mealType: "Dinner",
                      onFoodAdded: (food) => _addFood("Dinner", food),
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
      ),
    );
  }
}

// import 'package:eat_fit/model/food_model.dart';
// import 'package:eat_fit/views/home_screen/components/meal/meal_input.dart';
// import 'package:flutter/material.dart';
// import 'package:eat_fit/views/home_screen/diary/add_meal_screen.dart';
// import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';

// class DiaryScreen extends StatefulWidget {
//   const DiaryScreen({super.key});

//   @override
//   State<DiaryScreen> createState() => _DiaryScreenState();
// }

// class _DiaryScreenState extends State<DiaryScreen> {
//   // Map to store meals and their associated foods
//   final Map<String, List<Food>> _mealFoods = {
//     "Breakfast": [],
//     "Lunch": [],
//     "Dinner": [],
//   };

//   // Method to handle adding food to a specific meal
//   void _addFoodToMeal(String mealType, Food food) {
//     setState(() {
//       _mealFoods[mealType]?.add(food);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           "Diary",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 18,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.person, color: Colors.black),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const MyProfileScreen()),
//             );
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 10),
//             const Text(
//               "Meals",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),

//             // Breakfast Meal Input
//             MealInput(
//               mealType: "Breakfast",
//               foods: _mealFoods["Breakfast"]!,
//               onAddMeal: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddMealScreen(
//                       mealType: "Breakfast",
//                       onFoodAdded: (food) => _addFoodToMeal("Breakfast", food),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 10),

//             // Lunch Meal Input
//             MealInput(
//               mealType: "Lunch",
//               foods: _mealFoods["Lunch"]!,
//               onAddMeal: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddMealScreen(
//                       mealType: "Lunch",
//                       onFoodAdded: (food) => _addFoodToMeal("Lunch", food),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 10),

//             // Dinner Meal Input
//             MealInput(
//               mealType: "Dinner",
//               foods: _mealFoods["Dinner"]!,
//               onAddMeal: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AddMealScreen(
//                       mealType: "Dinner",
//                       onFoodAdded: (food) => _addFoodToMeal("Dinner", food),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
