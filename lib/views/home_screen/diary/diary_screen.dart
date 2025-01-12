import 'package:eat_fit/views/home_screen/components/meal_input.dart';
import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';
import 'package:eat_fit/views/home_screen/components/water_input.dart';
import 'package:eat_fit/views/home_screen/components/weight_input.dart';
import 'package:flutter/material.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopAppBar(
          onProfileTap: () {
            // Navigate to Profile
          },
          onCalendarTap: () {
            // Show Calendar
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // // Water Intake Section
            // const Text(
            //   "Water Intake",
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
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
              onAddMeal: () {
                Navigator.pushNamed(context, '/add_meal',
                    arguments: "Breakfast");
              },
            ),

            const SizedBox(height: 10),
            MealInput(
              mealType: "Lunch",
              onAddMeal: () {
                Navigator.pushNamed(context, '/add_meal', arguments: "Lunch");
              },
            ),
            const SizedBox(height: 10),
            MealInput(
              mealType: "Dinner",
              onAddMeal: () {
                Navigator.pushNamed(context, '/add_meal', arguments: "Dinner");
              },
            ),
            const SizedBox(height: 20),

            // Weight Input Section
            // const Text(
            //   "Weight",
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 10),

            const WeightSection(),
          ],
        ),
      ),
    );
  }
}
