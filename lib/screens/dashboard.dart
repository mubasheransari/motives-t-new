import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motives_tneww/screens/profile_screen.dart';
import 'package:motives_tneww/screens/timecard_screen.dart';
import 'package:motives_tneww/theme_change/theme_bloc.dart';
import 'package:motives_tneww/theme_change/theme_event.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isAvailable = false;
    List<FlSpot> graphPoints = [
    FlSpot(0, 2.5),
    FlSpot(1, 3.0),
    FlSpot(2, 3.8),
    FlSpot(3, 4.2),
    FlSpot(4, 3.9),
    FlSpot(5, 4.5),
    FlSpot(6, 4.1),
  ];

  @override
  Widget build(BuildContext context) {
  final isDark = context.watch<ThemeBloc>().state.themeMode == ThemeMode.dark;
    return Scaffold(
    //  backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: ShaderMaskText(
            text: "Hello , TestUser",
            textxfontsize: 22,
          ),
        ),
      //  backgroundColor: Color(0xFF121212),
        elevation: 0,
        actions: [
         // ShaderMaskText(text:isDark ?  "Change to Light":"Change to Dark", textxfontsize: 13),
          Transform.scale(
            scale: 0.6,
            child: Switch(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: isDark,
              activeColor: Colors.purple,
              onChanged: (value) {
                context.read<ThemeBloc>().add(ToggleThemeEvent(value));
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats containers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildStatCard(
                        title: "Total Routes",
                        value: "120",
                        color1: Colors.purple,
                        color2: Colors.blue,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        title: "Completed",
                        value: "95",
                        color1: Colors.green,
                        color2: Colors.teal,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatCard(
                        title: "Pending",
                        value: "15",
                        color1: Colors.orange,
                        color2: Colors.deepOrange,
                      ),
                      const SizedBox(width: 12),
                      _buildStatCard(
                        title: "Successful",
                        value: "90",
                        color1: Colors.cyan,
                        color2: Colors.blueAccent,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: ShaderMaskText(
              text: "Sales Graph",
              textxfontsize: 22,
                        ),
            ),
              const SizedBox(height: 10),
               Center(
                 child: Container(
                  child: SizedBox(
                    height: 160,
                    width: MediaQuery.of(context).size.width *0.90,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(show: false),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: graphPoints,
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                               ),
               ),
              const SizedBox(height: 20),

            // Icon grid menu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: (){
                          showTimeCardPopup(context);
                        },
                        child: _buildMenuButton(Icons.access_time, "Time\nCard")),
                       InkWell(
                        onTap:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreenNew()));
                        },
                        child: _buildMenuButton(Icons.person, "Profile\nDetails")),
                      // _buildMenuButton(
                      //   Icons.alt_route,
                      //   "Today's\nRoute",
                      // ),
                      // _buildMenuButton(
                      //   Icons.shopping_cart,
                      //   "Punch\nOrder",
                      // ),
                      _buildMenuButton(
                        Icons.cloud_download,
                        "Sync\nIn",
                      ),
                       _buildMenuButton(Icons.cloud_upload, "Sync\nOut"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMenuButton(Icons.cloud_upload, "Sync\nOut"),
                      _buildMenuButton(Icons.reviews, "Shop\nOwner\nReview"),
                      _buildMenuButton(Icons.add, "Add\nShops"),
                      _buildMenuButton(Icons.calendar_month, "Leave\nRequest"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color1,
    required Color color2,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color1.withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(2, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label) {
      final isDark = context.watch<ThemeBloc>().state.themeMode == ThemeMode.dark;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.purple, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(2, 4),
              )
            ],
          ),
          child: Icon(icon, size: 24, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black,),
        ),
      ],
    );
  }
}

class ShaderMaskText extends StatelessWidget {
  final String text;
  final double textxfontsize;

  const ShaderMaskText({
    super.key,
    required this.text,
    required this.textxfontsize,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.purple, Colors.blue],
      ).createShader(bounds),
      child: Text(
        text,
        style: TextStyle(
          fontSize: textxfontsize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}


// bool isAvailable = false;

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen> {
//   bool isAvailable = false;

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       backgroundColor: Color(0xFF121212),
//       appBar: AppBar(
        
//         automaticallyImplyLeading: false,
//         centerTitle: false,
//         title: Align(
//           alignment: Alignment.centerLeft,
//           child: ShaderMaskText(
//             text: "Hello , TestUser",
//             textxfontsize: 22,
//           ),
//         ),
//         backgroundColor: Color(0xFF121212),
//         elevation: 0,
//         actions: [
//           ShaderMaskText(text: "Dark", textxfontsize: 16),
//           Transform.scale(
//             scale: 0.7,
//             child: Switch(
//               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//               value: isAvailable,
//               activeColor: Colors.purple,
//               onChanged: (value) {
//                 setState(() {
//                   isAvailable = value;
//                 });
//               },
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Stats containers
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     _buildStatCard(
//                       title: "Total Routes",
//                       value: "120",
//                       color1: Colors.purple,
//                       color2: Colors.blue,
//                       isDark: isDarkMode,
//                     ),
//                     const SizedBox(width: 12),
//                     _buildStatCard(
//                       title: "Completed",
//                       value: "95",
//                       color1: Colors.green,
//                       color2: Colors.teal,
//                       isDark: isDarkMode,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     _buildStatCard(
//                       title: "Pending",
//                       value: "15",
//                       color1: Colors.orange,
//                       color2: Colors.deepOrange,
//                       isDark: isDarkMode,
//                     ),
//                     const SizedBox(width: 12),
//                     _buildStatCard(
//                       title: "Successful",
//                       value: "90",
//                       color1: Colors.cyan,
//                       color2: Colors.blueAccent,
//                       isDark: isDarkMode,
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Dark mode toggle row

//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard({
//     required String title,
//     required String value,
//     required Color color1,
//     required Color color2,
//     required bool isDark,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [color1, color2],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: color1.withOpacity(0.4),
//               blurRadius: 6,
//               offset: const Offset(2, 4),
//             )
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: isDark ? Colors.white : Colors.white,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: isDark ? Colors.white70 : Colors.white70,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ShaderMaskText extends StatelessWidget {
//   final String text;
//   final double textxfontsize;

//   const ShaderMaskText({
//     super.key,
//     required this.text,
//     required this.textxfontsize,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ShaderMask(
//       shaderCallback: (bounds) => const LinearGradient(
//         colors: [Colors.purple, Colors.blue],
//       ).createShader(bounds),
//       child: Text(
//         text,
//         style: TextStyle(
//           fontSize: textxfontsize,
//           fontWeight: FontWeight.bold,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }
