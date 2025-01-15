// import 'package:eat_fit/model/food_model.dart';
// import 'package:flutter/material.dart';

// class MealInput extends StatelessWidget {
//   final String mealType;
//   final List<Food> foods;
//   final VoidCallback onAddMeal;

//   const MealInput({
//     super.key,
//     required this.mealType,
//     required this.foods,
//     required this.onAddMeal,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final totalCalories =
//         foods.fold<int>(0, (sum, food) => sum + food.calories);

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   mealType,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   "$totalCalories cal",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             if (foods.isEmpty)
//               const Text(
//                 "Input your food",
//                 style: TextStyle(color: Colors.grey),
//               )
//             else
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: foods
//                     .map((food) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4.0),
//                           child: Text(
//                             "${food.name} - ${food.grams}g (${food.calories} cal)",
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ))
//                     .toList(),
//               ),
//             const SizedBox(height: 10),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: onAddMeal,
//                 child: const Text(
//                   "Add Food",
//                   style: TextStyle(color: Colors.blue),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:eat_fit/model/food_model.dart';
import 'package:flutter/material.dart';

class MealInput extends StatelessWidget {
  final String mealType;
  final List<Food> foods; // Updated to match DiaryScreen
  final VoidCallback onAddMeal;

  const MealInput({
    super.key,
    required this.mealType,
    required this.foods,
    required this.onAddMeal,
  });

  @override
  Widget build(BuildContext context) {
    final totalCalories =
        foods.fold<int>(0, (sum, food) => sum + food.calories);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal Type and Calories Display
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mealType,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$totalCalories cal",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Foods List or Placeholder Text
            if (foods.isEmpty)
              const Text(
                "Input your food",
                style: TextStyle(color: Colors.grey),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: foods
                    .map((food) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text(
                            "${food.name} - ${food.calories} cal",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 10),

            // Add Food Button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAddMeal,
                child: const Text(
                  "Add Food",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// meal_input.dart
// import 'package:eat_fit/model/mock_data.dart';
// import 'package:flutter/material.dart';

// class MealInput extends StatelessWidget {
//   final String mealType;
//   final List<Food> foodList;
//   final VoidCallback onAddMeal;

//   const MealInput({
//     super.key,
//     required this.mealType,
//     required this.foodList,
//     required this.onAddMeal,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final totalCalories =
//         foodList.fold<int>(0, (sum, food) => sum + food.calories);

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   mealType,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Text(
//                   "$totalCalories cal",
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             if (foodList.isEmpty)
//               const Text(
//                 "Input your food",
//                 style: TextStyle(color: Colors.grey, fontSize: 14),
//               )
//             else
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: foodList
//                     .map((food) => Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4.0),
//                           child: Text(
//                             "${food.name} - ${food.calories} cal",
//                             style: const TextStyle(fontSize: 14),
//                           ),
//                         ))
//                     .toList(),
//               ),
//             const SizedBox(height: 10),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: onAddMeal,
//                 child: const Text(
//                   "Add Food",
//                   style: TextStyle(color: Colors.blue),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
