import 'package:flutter/material.dart';

class MealInput extends StatelessWidget {
  final String mealType;
  final VoidCallback onAddMeal;

  const MealInput({
    super.key,
    required this.mealType,
    required this.onAddMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 10),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(mealType,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              const Text("Input your meal",
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
          Row(
            children: [
              const Text("--- Cal", style: TextStyle(color: Colors.grey)),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.green),
                onPressed: onAddMeal,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
