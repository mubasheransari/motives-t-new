import 'package:flutter/material.dart';
import 'package:motives_tneww/screens/dashboard.dart';
import 'package:motives_tneww/screens/profile_screen.dart';
import 'package:motives_tneww/screens/task.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(),
    TaskScreen(),
    ProfileScreenNew()
  ];

  Widget _buildGradientIcon(IconData iconData) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [Colors.cyan, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      child: Icon(
        iconData,
        color: Colors.white, // Needed for ShaderMask to work
      ),
    );
  }

  // Widget _buildGradientText(String text) {
  //   return ShaderMaskText(text: text, textxfontsize: 12);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // Black background
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // so background shows fully
        items: [
          BottomNavigationBarItem(
            icon: _buildGradientIcon(Icons.dashboard_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: _buildGradientIcon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: _buildGradientIcon(Icons.person_outline),
            label: "Profile",
          ),
        ],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        selectedItemColor: Colors.white, // overridden by gradient
        unselectedItemColor: Colors.white, // overridden by gradient
      ),
    );
  }
}


// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = const [
//     DashboardScreen(),
//     TaskScreen(),
//     ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex], // Shows the selected screen
//       bottomNavigationBar: BottomNavigationBar(
             
//         currentIndex: _selectedIndex,
//         onTap: (index) {
//           setState(() {
//             _selectedIndex = index;
//           });
//         },
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard_outlined),
//             label: "Home",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.task_alt_outlined),
//             label: "Tasks",
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             label: "Profile",
//           ),
//         ],
//       ),
//     );
//   }
// }
