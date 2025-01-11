import 'package:eat_fit/consts/consts.dart';

import 'components/greeting_text.dart';
import 'components/nutrients_indicator.dart';
import 'components/top_app_bar.dart';
import 'components/water_input.dart';
import 'components/weight_input.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: TopAppBar(
          onProfileTap: () {
            Navigator.pushNamed(context, '/profile'); // Navigate to Profile
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
            const GreetingText(userName: "User"),
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
