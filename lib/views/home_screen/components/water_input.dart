import 'package:flutter/material.dart';

class WaterConsumed extends StatefulWidget {
  const WaterConsumed({super.key});

  @override
  _WaterConsumedState createState() => _WaterConsumedState();
}

class _WaterConsumedState extends State<WaterConsumed> {
  double _waterConsumed = 1.9; // Current water consumption in liters
  double _targetWater = 2.5; // Target water consumption in liters

  @override
  Widget build(BuildContext context) {
    double progress = _waterConsumed / _targetWater;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Water Consumed",
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
                  _editableField(
                    label: "Water Drank",
                    value: _waterConsumed,
                    onChanged: (value) {
                      setState(() {
                        _waterConsumed =
                            double.tryParse(value) ?? _waterConsumed;
                      });
                    },
                  ),
                  _editableField(
                    label: "Target",
                    value: _targetWater,
                    onChanged: (value) {
                      setState(() {
                        _targetWater = double.tryParse(value) ?? _targetWater;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 100,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                  ),
                  Container(
                    height: 100 * progress.clamp(0.0, 1.0), // Progress height
                    width: 50,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.blue],
                        stops: [0.0, 1.0],
                      ),
                      borderRadius:
                      BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                "Progress: ${(_waterConsumed / _targetWater * 100).clamp(0, 100).toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _editableField({
    required String label,
    required double value,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 5),
        SizedBox(
          width: 80,
          child: TextFormField(
            initialValue: value.toStringAsFixed(1),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
