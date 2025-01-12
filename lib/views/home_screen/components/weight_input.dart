// import 'package:flutter/material.dart';

// class WeightSection extends StatefulWidget {
//   const WeightSection({super.key});

//   @override
//   _WeightSectionState createState() => _WeightSectionState();
// }

// class _WeightSectionState extends State<WeightSection> {
//   double _currentWeight = 70.0; // Example current weight value

//   void _registerWeight() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         double newWeight = _currentWeight;
//         return AlertDialog(
//           title: const Text("Register Weight"),
//           content: TextFormField(
//             initialValue: newWeight.toString(),
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               labelText: "Enter your weight (kg)",
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             onChanged: (value) {
//               newWeight = double.tryParse(value) ?? newWeight;
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog without saving
//               },
//               child: const Text("Cancel"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _currentWeight = newWeight;
//                 });
//                 Navigator.of(context).pop(); // Save and close dialog
//               },
//               child: const Text("Save"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Weight",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Colors.white,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.shade300,
//                 blurRadius: 10,
//                 offset: const Offset(0, 5),
//               ),
//             ],
//           ),
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Your Weight",
//                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "$_currentWeight kg",
//                       style: const TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.blueAccent,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     IconButton(
//                       onPressed: _registerWeight,
//                       icon: const Icon(Icons.add_circle,
//                           color: Color.fromARGB(255, 185, 186, 185)),
//                       iconSize: 36,
//                     ),
//                     const SizedBox(width: 10),
//                     Image.asset(
//                       'assets/images/weight.png', // Replace with your weight.png asset
//                       width: 20,
//                       height: 20,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

class WeightSection extends StatefulWidget {
  const WeightSection({super.key});

  @override
  _WeightSectionState createState() => _WeightSectionState();
}

class _WeightSectionState extends State<WeightSection> {
  double _currentWeight = 70.0; // Example current weight value

  void _registerWeight() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double newWeight = _currentWeight;
        return AlertDialog(
          title: const Text("Register Weight"),
          content: TextFormField(
            initialValue: newWeight.toString(),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Enter your weight (kg)",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              newWeight = double.tryParse(value) ?? newWeight;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog without saving
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _currentWeight = newWeight;
                });
                Navigator.of(context).pop(); // Save and close dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Weight",
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Your Weight",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$_currentWeight kg",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: _registerWeight,
                    icon: const Icon(Icons.add_circle,
                        color: Color.fromARGB(255, 185, 186, 185)),
                    iconSize: 36,
                  ),
                  const SizedBox(width: 10),
                  Image.asset(
                    'assets/images/weight.png', // Replace with your weight.png asset
                    width: 40,
                    height: 40,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
