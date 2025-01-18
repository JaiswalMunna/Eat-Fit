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
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
//           onCalendarTap: () {},
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
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: _fetchWeightData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }

//         final weightData = snapshot.data ?? [];
//         final List<FlSpot> spots = [];
//         final List<String> dates = [];

//         for (int i = 0; i < weightData.length; i++) {
//           final item = weightData[i];
//           spots.add(FlSpot(i.toDouble(), item['weight'].toDouble()));
//           dates.add(item['date']); // Collect the date for bottom titles
//         }

//         return Column(
//           children: [
//             _buildPeriodDropdown(),
//             _buildGraphPlaceholder(
//               "Weight Trends",
//               spots,
//               dates, // Pass dates to the graph placeholder
//               "Weight",
//             ),
//             _buildHistoryList(weightData, "weight", "kg"),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildCaloriesReport() {
//     return StreamBuilder<List<Map<String, dynamic>>>(
//       stream: _fetchCalorieData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }

//         final calorieData = snapshot.data ?? [];
//         final List<FlSpot> spots = [];
//         final List<String> dates = [];

//         for (int i = 0; i < calorieData.length; i++) {
//           final item = calorieData[i];
//           spots.add(FlSpot(i.toDouble(), item['calories'].toDouble()));
//           dates.add(item['date']); // Collect the date for the x-axis
//         }

//         return Column(
//           children: [
//             _buildPeriodDropdown(),
//             _buildGraphPlaceholder(
//               "Calorie Trends",
//               spots,
//               dates, // Pass dates for the x-axis
//               "Calories",
//             ),
//             _buildHistoryList(calorieData, "calories", "cal"),
//           ],
//         );
//       },
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
//       String title, List<FlSpot> spots, List<String> dates, String yLabel) {
//     if (spots.isEmpty) {
//       return const Center(
//         child: Text("No data available", style: TextStyle(fontSize: 16)),
//       );
//     }

//     final double minY =
//         spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 5;
//     final double maxY =
//         spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 5;

//     return Expanded(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: LineChart(
//           LineChartData(
//             minY: minY > 0 ? minY : 0,
//             maxY: maxY,
//             lineBarsData: [
//               LineChartBarData(
//                 isCurved: true,
//                 spots: spots.reversed.toList(),
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
//                   reservedSize: 50,
//                   getTitlesWidget: (value, meta) {
//                     int index = value.toInt();
//                     if (index < 0 || index >= dates.length)
//                       return const SizedBox();
//                     return Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: RotatedBox(
//                         quarterTurns: 3,
//                         child: Text(
//                           dates[index],
//                           style: const TextStyle(fontSize: 10),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               rightTitles:
//                   AxisTitles(sideTitles: SideTitles(showTitles: false)),
//               topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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

//   Widget _buildHistoryList(
//       List<Map<String, dynamic>> data, String key, String unit) {
//     return Expanded(
//       child: ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           final item = data[index];
//           return ListTile(
//             title: Text(item['date']),
//             trailing: Text("${item[key]} $unit"),
//           );
//         },
//       ),
//     );
//   }

//   Stream<List<Map<String, dynamic>>> _fetchWeightData() async* {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) throw Exception("User is not logged in");

//     final DateTime now = DateTime.now();
//     DateTime filterDate;

//     switch (_selectedPeriod) {
//       case "Week":
//         filterDate = now.subtract(const Duration(days: 7));
//         break;
//       case "Month":
//         filterDate = DateTime(now.year, now.month - 1, now.day);
//         break;
//       case "Year":
//         filterDate = DateTime(now.year - 1, now.month, now.day);
//         break;
//       default:
//         filterDate = DateTime(2000); // Default to fetch all data
//     }

//     final query = await _firestore.collection('weights').doc(userId).get();

//     final List<dynamic> weights = query.data()?['weights'] ?? [];
//     yield weights
//         .where((entry) =>
//             DateTime.parse(entry['date']).isAfter(filterDate)) // Filter by date
//         .toList()
//         .cast<Map<String, dynamic>>();
//   }

//   Stream<List<Map<String, dynamic>>> _fetchCalorieData() async* {
//     final userId = FirebaseAuth.instance.currentUser?.uid;
//     if (userId == null) throw Exception("User is not logged in");

//     final DateTime now = DateTime.now();
//     DateTime filterDate;

//     // Determine the filter date based on the selected period
//     switch (_selectedPeriod) {
//       case "Week":
//         filterDate = now.subtract(const Duration(days: 7));
//         break;
//       case "Month":
//         filterDate = DateTime(now.year, now.month - 1, now.day);
//         break;
//       case "Year":
//         filterDate = DateTime(now.year - 1, now.month, now.day);
//         break;
//       default:
//         filterDate = DateTime(2000); // Default to fetch all data
//     }

//     try {
//       // Fetch the calorie data from Firestore in ascending order
//       final query = await _firestore
//           .collection('daily_totals')
//           .where('userId', isEqualTo: userId)
//           .where(
//             'date',
//             isGreaterThanOrEqualTo: filterDate.toIso8601String().split("T")[0],
//           )
//           .orderBy('date', descending: false) // Fetch from old to new
//           .get();

//       // Map the data to a list of maps containing 'date' and 'calories'
//       final calorieData = query.docs.map((doc) {
//         final data = doc.data();
//         return {
//           'date': data['date'] ?? '',
//           'calories': data['calories'] ?? 0,
//         };
//       }).toList();

//       yield calorieData;
//     } catch (e) {
//       print("Error fetching calorie data: $e");
//       yield [];
//     }
//   }
// }
import 'package:eat_fit/views/home_screen/profile/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eat_fit/views/home_screen/components/top_app_bar.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({Key? key}) : super(key: key);

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = "Week";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Future<List<Map<String, dynamic>>> _weightFuture;
  late Future<List<Map<String, dynamic>>> _calorieFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Initialize futures
    _weightFuture = _fetchWeightData();
    _calorieFuture = _fetchCalorieData();
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
          onCalendarTap: () {},
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
                _buildWeightReport(),
                _buildCaloriesReport(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightReport() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _weightFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final weightData = snapshot.data ?? [];
        final List<FlSpot> spots = [];
        final List<String> dates = [];

        for (int i = 0; i < weightData.length; i++) {
          final item = weightData[i];
          spots.add(FlSpot(i.toDouble(), item['weight'].toDouble()));
          dates.add(item['date']);
        }

        return Column(
          children: [
            _buildPeriodDropdown(),
            _buildGraphPlaceholder("Weight Trends", spots, dates, "Weight"),
            _buildHistoryList(weightData, "weight", "kg"),
          ],
        );
      },
    );
  }

  Widget _buildCaloriesReport() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _calorieFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final calorieData = snapshot.data ?? [];
        final List<FlSpot> spots = [];
        final List<String> dates = [];

        for (int i = 0; i < calorieData.length; i++) {
          final item = calorieData[i];
          spots.add(FlSpot(i.toDouble(), item['calories'].toDouble()));
          dates.add(item['date']);
        }

        return Column(
          children: [
            _buildPeriodDropdown(),
            _buildGraphPlaceholder(
              "Calorie Trends",
              spots,
              dates,
              "Calories",
            ),
            _buildHistoryList(calorieData, "calories", "cal"),
          ],
        );
      },
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
                _weightFuture = _fetchWeightData(); // Re-fetch data
                _calorieFuture = _fetchCalorieData(); // Re-fetch data
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGraphPlaceholder(
      String title, List<FlSpot> spots, List<String> dates, String yLabel) {
    if (spots.isEmpty) {
      return const Center(
        child: Text("No data available", style: TextStyle(fontSize: 16)),
      );
    }

    final double minY =
        spots.map((spot) => spot.y).reduce((a, b) => a < b ? a : b) - 5;
    final double maxY =
        spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 5;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: LineChart(
          LineChartData(
            minY: minY > 0 ? minY : 0,
            maxY: maxY,
            lineBarsData: [
              LineChartBarData(
                isCurved: true,
                spots: spots.reversed.toList(),
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
                  reservedSize: 50,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= dates.length)
                      return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: Text(
                          dates[index],
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    );
                  },
                ),
              ),
              rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
    );
  }

  Widget _buildHistoryList(
      List<Map<String, dynamic>> data, String key, String unit) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return ListTile(
            title: Text(item['date']),
            trailing: Text("${item[key]} $unit"),
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchWeightData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User is not logged in");

    final DateTime now = DateTime.now();
    DateTime filterDate;

    switch (_selectedPeriod) {
      case "Week":
        filterDate = now.subtract(const Duration(days: 7));
        break;
      case "Month":
        filterDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case "Year":
        filterDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        filterDate = DateTime(2000); // Default to fetch all data
    }

    final query = await _firestore.collection('weights').doc(userId).get();
    final List<dynamic> weights = query.data()?['weights'] ?? [];
    return weights
        .where((entry) =>
            DateTime.parse(entry['date']).isAfter(filterDate)) // Filter by date
        .toList()
        .cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> _fetchCalorieData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception("User is not logged in");

    final DateTime now = DateTime.now();
    DateTime filterDate;

    switch (_selectedPeriod) {
      case "Week":
        filterDate = now.subtract(const Duration(days: 7));
        break;
      case "Month":
        filterDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case "Year":
        filterDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        filterDate = DateTime(2000);
    }

    final query = await _firestore
        .collection('daily_totals')
        .where('userId', isEqualTo: userId)
        .where('date',
            isGreaterThanOrEqualTo: filterDate.toIso8601String().split("T")[0])
        .orderBy('date', descending: false)
        .get();

    return query.docs.map((doc) {
      final data = doc.data();
      return {
        'date': data['date'] ?? '',
        'calories': data['calories'] ?? 0,
      };
    }).toList();
  }
}
