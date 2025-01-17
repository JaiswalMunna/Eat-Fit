// import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';

// class ReportScreen extends StatefulWidget {
//   const ReportScreen({Key? key}) : super(key: key);

//   @override
//   State<ReportScreen> createState() => _ReportScreenState();
// }

// class _ReportScreenState extends State<ReportScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   String _selectedPeriod = "Week";

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(70),
//         child: TopAppBar(
//           onProfileTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => const MyProfileScreen()),
//             );
//           },
//           onCalendarTap: () {
//             // Add logic for calendar navigation
//           },
//           showCalendarIcon: false, // Hide the calendar icon in ReportScreen
//         ),
//       ),
//       body: Column(
//         children: [
//           TabBar(
//             controller: _tabController,
//             indicatorColor: Colors.green,
//             labelColor: Colors.green,
//             unselectedLabelColor: Colors.grey,
//             tabs: const [
//               Tab(text: "Weight"),
//               Tab(text: "Calories"),
//             ],
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildWeightReport(),
//                 _buildCaloriesReport(),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWeightReport() {
//     return Column(
//       children: [
//         _buildPeriodDropdown(),
//         _buildGraphPlaceholder(
//           "Weight Trends",
//           [
//             FlSpot(0, 80),
//             FlSpot(1, 82),
//             FlSpot(2, 83.5),
//             FlSpot(3, 81.5),
//           ],
//           "Date",
//           "Weight",
//         ),
//         _buildHistoryList("Weight", "kg"),
//       ],
//     );
//   }

//   Widget _buildCaloriesReport() {
//     return Column(
//       children: [
//         _buildPeriodDropdown(),
//         _buildGraphPlaceholder(
//           "Calories Trends",
//           [
//             FlSpot(0, 2000),
//             FlSpot(1, 2200),
//             FlSpot(2, 2500),
//             FlSpot(3, 2300),
//           ],
//           "Date",
//           "Calories",
//         ),
//         _buildHistoryList("Calories", "cal"),
//       ],
//     );
//   }

//   Widget _buildPeriodDropdown() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text("From Beginning", style: TextStyle(fontSize: 16)),
//           DropdownButton<String>(
//             value: _selectedPeriod,
//             items: const ["Week", "Month", "Year"].map((String period) {
//               return DropdownMenuItem<String>(
//                 value: period,
//                 child: Text(period),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 _selectedPeriod = value!;
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGraphPlaceholder(
//       String title, List<FlSpot> spots, String xLabel, String yLabel) {
//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: LineChart(
//           LineChartData(
//             lineBarsData: [
//               LineChartBarData(
//                 isCurved: true,
//                 spots: spots,
//                 color: Colors.green,
//                 barWidth: 4,
//               ),
//             ],
//             titlesData: FlTitlesData(
//               leftTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   reservedSize: 40,
//                   getTitlesWidget: (value, meta) {
//                     return Text(
//                       value.toStringAsFixed(0),
//                       style: const TextStyle(fontSize: 12),
//                     );
//                   },
//                 ),
//               ),
//               bottomTitles: AxisTitles(
//                 sideTitles: SideTitles(
//                   showTitles: true,
//                   reservedSize: 40,
//                   getTitlesWidget: (value, meta) {
//                     List<String> dates = ["Oct", "Nov", "Dec", "Jan"];
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         dates[value.toInt() % dates.length],
//                         style: const TextStyle(fontSize: 12),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             gridData: FlGridData(show: true),
//             borderData: FlBorderData(
//               show: true,
//               border: const Border(
//                 left: BorderSide(width: 1),
//                 bottom: BorderSide(width: 1),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHistoryList(String label, String unit) {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: 5,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text("Dec ${20 - index}, 2024"),
//             trailing: Text("${75 + index * 1.5} $unit"),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';
import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = "Week";
  List<Map<String, dynamic>> _weightData = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchWeightData();
  }

  Future<void> _fetchWeightData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("No logged-in user.");
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('weights')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        final List<dynamic> weights = data?['weights'] ?? [];

        // Keep the latest weight entry for each day
        final Map<String, Map<String, dynamic>> latestWeightsPerDay = {};
        for (var entry in weights) {
          final date = entry['date'];
          if (!latestWeightsPerDay.containsKey(date) ||
              latestWeightsPerDay[date]!['weight'] != entry['weight']) {
            latestWeightsPerDay[date] = entry;
          }
        }

        setState(() {
          _weightData = latestWeightsPerDay.values.toList();
          _weightData.sort((a, b) =>
              DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
          _loading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching weight data: $e")),
      );
      setState(() {
        _loading = false;
      });
    }
  }

  List<FlSpot> _generateWeightSpots() {
    return _weightData.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value['weight'].toDouble());
    }).toList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: TopAppBar(
          onProfileTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyProfileScreen()),
            );
          },
          onCalendarTap: () {
            // Add logic for calendar navigation
          },
          showCalendarIcon: false,
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Colors.green,
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "Weight"),
              Tab(text: "Calories"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildWeightReport(),
                const Center(child: Text("Calories Report Coming Soon")),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightReport() {
    return Column(
      children: [
        _buildPeriodDropdown(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: _generateWeightSpots(),
                    color: Colors.green,
                    barWidth: 4,
                  ),
                ],
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: const TextStyle(fontSize: 12),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value < 0 || value >= _weightData.length)
                          return Container();
                        final date = _weightData[value.toInt()]['date'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            DateFormat('MMM dd').format(DateTime.parse(date)),
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    left: BorderSide(width: 1),
                    bottom: BorderSide(width: 1),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _weightData.length,
            itemBuilder: (context, index) {
              final entry = _weightData[index];
              return ListTile(
                title: Text(DateFormat('MMM dd, yyyy')
                    .format(DateTime.parse(entry['date']))),
                trailing: Text("${entry['weight']} kg"),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodDropdown() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("From Beginning", style: TextStyle(fontSize: 16)),
          DropdownButton<String>(
            value: _selectedPeriod,
            items: const ["Week", "Month", "Year"].map((String period) {
              return DropdownMenuItem<String>(
                value: period,
                child: Text(period),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedPeriod = value!;
              });
            },
          ),
        ],
      ),
    );
  }
}
