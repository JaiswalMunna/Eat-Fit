import 'package:flutter/material.dart';

class NutrientsIndicator extends StatelessWidget {
  const NutrientsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Nutrients Indicator",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
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
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _nutrientItem("Proteins", 150, 225, Colors.red),
                  _nutrientItem("Fats", 30, 118, Colors.yellow),
                  _nutrientItem("Carbs", 319, 340, Colors.brown),
                ],
              ),
              const SizedBox(height: 20),
              _calorieBar(2456, 3400),
            ],
          ),
        ),
      ],
    );
  }

  Widget _nutrientItem(String name, int consumed, int target, Color color) {
    double progress = consumed / target;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(name, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        SizedBox(
          width: 80, // Fixed width for the progress bar
          child: LinearProgressIndicator(
            value: progress,
            color: color,
            backgroundColor: Colors.grey.shade300,
            minHeight: 5,
          ),
        ),
        const SizedBox(height: 5),
        Text("$consumed / $target",
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _calorieBar(int consumed, int target) {
    double progress = consumed / target;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Calories", style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: progress,
          color: Colors.green,
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 5),
        Text("$consumed / $target"),
      ],
    );
  }
}
