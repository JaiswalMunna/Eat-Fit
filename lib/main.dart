// import 'package:eat_fit/consts/consts.dart';
// import 'package:eat_fit/views/home_screen/diary/diary_screen.dart';
// import 'package:eat_fit/views/home_screen/home_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:eat_fit/views/splash_screen/first_splash_screen.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
//         fontFamily: regular,
//       ),
//       // home: FirstSplashScreen(),
//       home: FirstSplashScreen(),
//       // home: DiaryScreen(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:eat_fit/views/splash_screen/first_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Load environment variables
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eat Fit',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent),
        fontFamily: 'Inter',
      ),
      home: FirstSplashScreen(),
    );
  }
}
