import 'package:eat_fit/consts/consts.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SecondSplashScreen extends StatefulWidget {
  const SecondSplashScreen({super.key});

  @override
  State<SecondSplashScreen> createState() => _SecondSplashScreenState();
}

class _SecondSplashScreenState extends State<SecondSplashScreen> {
  void changeScreen() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.to(() => const SecondSplashScreen());
    });
  }

  @override
  void initState() {
    super.initState();
    changeScreen();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen height for responsive design
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // White background
        elevation: 0, // Remove shadow for a cleaner look
        actions: [
          TextButton(
            onPressed: () {
              // Define action for Skip button
            },
            child: const Text(
              "Skip",
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white, // Set background color to white
          child: Column(
            children: [
              // Image with height 1/3 of the screen and no overflow
              SizedBox(
                height: screenHeight / 3,
                child: Image.asset(
                  'assets/images/onboard.png',
                  fit: BoxFit.contain, // Adjust image to fit without overflow
                ),
              ),
              // Additional content can go here
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
