import 'package:eat_fit/consts/consts.dart';
import 'package:eat_fit/views/auth%20screen/login_screen.dart';
import 'package:eat_fit/views/home_screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const HomeScreen();
            } else {
              return LoginScreen();
            }
          }),
    );
  }
}
