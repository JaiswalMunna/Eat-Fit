import 'package:eat_fit/consts/consts.dart';
import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
import 'components/greeting_text.dart';
import 'components/nutrients_indicator.dart';
import 'components/top_app_bar.dart';
import 'components/water_input.dart';
import 'components/weight_input.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopAppBar(
          onProfileTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyProfileScreen()),
            );
          },
          onCalendarTap: () {
            Navigator.pushNamed(context, '/calendar'); // Show Calendar
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Text Component
            const GreetingText(),
            const SizedBox(height: 20),

            // Nutrients Indicator Component
            const NutrientsIndicator(),
            const SizedBox(height: 20),

            // Water Intake Component
            const WaterConsumed(),
            const SizedBox(height: 20),
            // Weight Input Component
            const WeightSection(),
          ],
        ),
      ),
    );
  }
}
