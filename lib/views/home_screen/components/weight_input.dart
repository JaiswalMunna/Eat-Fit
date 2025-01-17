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
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Your Weight",
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     "$_currentWeight kg",
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.blueAccent,
//                     ),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   IconButton(
//                     onPressed: _registerWeight,
//                     icon: const Icon(Icons.add_circle,
//                         color: Color.fromARGB(255, 185, 186, 185)),
//                     iconSize: 36,
//                   ),
//                   const SizedBox(width: 10),
//                   Image.asset(
//                     'assets/images/weight.png', // Replace with your weight.png asset
//                     width: 40,
//                     height: 40,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class WeightSection extends StatefulWidget {
  const WeightSection({super.key});

  @override
  _WeightSectionState createState() => _WeightSectionState();
}

class _WeightSectionState extends State<WeightSection> {
  double _currentWeight = 70.0; // Example current weight value

  // /// Function to save the weight to Firestore
  Future<void> _saveWeightToFirestore(double weight) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("No logged-in user found.");
      }

      final date = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      // Reference the weights document for the current user
      final weightRef =
          FirebaseFirestore.instance.collection('weights').doc(user.uid);

      await weightRef.set({
        'userId': user.uid,
        'weights': FieldValue.arrayUnion([
          {'weight': weight, 'date': formattedDate}
        ]),
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Weight saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save weight: $e")),
      );
    }
  }

  // Future<void> _saveWeightToFirestore(double weight) async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) {
  //       throw Exception("User not logged in");
  //     }

  //     await FirebaseFirestore.instance.collection('weights').add({
  //       'userId': user.uid,
  //       'weight': weight,
  //       'date': Timestamp.now(), // Store the current timestamp
  //     });

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Weight saved successfully!")),
  //     );
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Failed to save weight: $e")),
  //     );
  //   }
  // }

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
                _saveWeightToFirestore(newWeight); // Save weight to Firestore
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
