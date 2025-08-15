import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motives_tneww/theme_change/theme_bloc.dart';

class ProfileScreenNew extends StatelessWidget {
  // final String name;
  // final String email;
  // final String phone;
  // final String address;

  // ProfileScreenNew({key? key});

  @override
  Widget build(BuildContext context) {
          final isDark = context.watch<ThemeBloc>().state.themeMode == ThemeMode.dark;
    return Scaffold(
 //     backgroundColor: Color(0xFF121212), // Dark background
      appBar: AppBar(
        title: ShaderMaskText(
          text: "Profile Details",
          textxfontsize: 20,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Card(
            color:isDark ? Color(0xFF1E1E1E):Colors.white, // Dark card
            elevation: 8,
            shadowColor: Colors.purple.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShaderMaskText(
                        text: "Test User",
                        textxfontsize: 22,
                      ),
                                        Container(
                    height: 80,
                    width: 80,
                    decoration:BoxDecoration(
                      gradient: LinearGradient(          colors: [Colors.cyan, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,),
                     // color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(40)
                    ),
                    child: Center(child: IconButton(onPressed: (){}, icon: Icon(Icons.person_add)))),
                    ],
                  ),
                  SizedBox(height: 20),
                  _profileDetail("🆔 Employee ID ", "11223",context),
                   SizedBox(height: 12),
                    _profileDetail("📧 Email", "testuser@gmail.com",context),
                  SizedBox(height: 12),
                  _profileDetail("📱 Phone", "+14743829743",context),
                  SizedBox(height: 12),
                  _profileDetail("🏠 Address", "Address: A/22, S.I.T.E, MAURIPUR ROAD, KARACHI.",context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileDetail(String title, String value,BuildContext context) {
        final isDark = context.watch<ThemeBloc>().state.themeMode == ThemeMode.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 17,
            color: isDark ? Colors.white:Color(0xFF1E1E1E),
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
         color: isDark ? Colors.white:Color(0xFF1E1E1E),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}

class ShaderMaskText extends StatelessWidget {
  final String text;
  final double textxfontsize;

  ShaderMaskText({super.key, required this.text, required this.textxfontsize});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.cyan, Colors.purpleAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
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

// Example random USA profile data generator
// ProfileScreen randomUSProfile() {
//   final List<String> names = [
//     "John Smith",
//     "Emma Johnson",
//     "Michael Brown",
//     "Olivia Davis",
//     "William Miller"
//   ];
//   final List<String> addresses = [
//     "123 Main St, New York, NY 10001",
//     "456 Oak Ave, Los Angeles, CA 90001",
//     "789 Pine Rd, Chicago, IL 60601",
//     "321 Maple Dr, Houston, TX 77001",
//     "654 Elm Blvd, Miami, FL 33101"
//   ];

//   final random = Random();
//   return ProfileScreen(
//     name: names[random.nextInt(names.length)],
//     email: "user${random.nextInt(100)}@example.com",
//     phone: "+1-${random.nextInt(900) + 100}-${random.nextInt(900) + 100}-${random.nextInt(9000) + 1000}",
//     address: addresses[random.nextInt(addresses.length)],
//   );
// }
