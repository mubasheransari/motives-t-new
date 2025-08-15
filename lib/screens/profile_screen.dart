import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motives_tneww/theme_change/theme_bloc.dart';
import 'package:motives_tneww/theme_change/theme_event.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  File? _profileImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery, // You can also offer camera option
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: GradientText("PROFILE", fontSize: 24),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Transform.scale(
            scale: 0.8,
            child: Switch(
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
        padding: const EdgeInsets.all(16),
        child: Card(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 8,
          shadowColor: isDark ? Colors.purple.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Picture
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.cyan.withOpacity(0.3),
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : const AssetImage('assets/images/default_profile.png')
                              as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.purpleAccent,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.edit, size: 18, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                GradientText("My Information", fontSize: 22),
                const SizedBox(height: 20),

                _customTextField(
                  controller: nameController,
                  hint: "Full Name",
                  icon: Icons.person_outline,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),

                _customTextField(
                  controller: employeeIdController,
                  hint: "Employee ID",
                  icon: Icons.badge_outlined,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),

                _customTextField(
                  controller: phoneController,
                  hint: "Phone Number",
                  icon: Icons.phone_outlined,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),

                _customTextField(
                  controller: addressController,
                  hint: "Address",
                  icon: Icons.location_on_outlined,
                  isDark: isDark,
                ),
                const SizedBox(height: 24),

                GradientButton(
                  text: "Save Profile",
                  onTap: () {
                    // Save profile logic here
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
        prefixIcon: Icon(icon, color: Colors.cyan),
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// 🔹 Gradient Text Widget
class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  const GradientText(this.text, {super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.cyan, Colors.purpleAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// 🔹 Gradient Button Widget
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const GradientButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.cyan, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}


/*class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: GradientText("PROFILE", fontSize: 24),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Transform.scale(
            scale: 0.8,
            child: Switch(
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
        padding: const EdgeInsets.all(16),
        child: Card(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          elevation: 8,
          shadowColor: isDark ? Colors.purple.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                GradientText("My Information", fontSize: 22),
                const SizedBox(height: 20),

                _customTextField(
                  controller: nameController,
                  hint: "Full Name",
                  icon: Icons.person_outline,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),

                _customTextField(
                  controller: employeeIdController,
                  hint: "Employee ID",
                  icon: Icons.badge_outlined,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),

                _customTextField(
                  controller: phoneController,
                  hint: "Phone Number",
                  icon: Icons.phone_outlined,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),

                _customTextField(
                  controller: addressController,
                  hint: "Address",
                  icon: Icons.location_on_outlined,
                  isDark: isDark,
                ),
                const SizedBox(height: 24),

                GradientButton(
                  text: "Save Profile",
                  onTap: () {
                    // Save profile logic here
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _customTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: isDark ? Colors.white54 : Colors.grey),
        prefixIcon: Icon(icon, color: Colors.cyan),
        filled: true,
        fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// 🔹 Gradient Text Widget
class GradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  const GradientText(this.text, {super.key, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.cyan, Colors.purpleAccent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// 🔹 Gradient Button Widget
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const GradientButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.cyan, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
*/


/*class ProfileScreenNew extends StatelessWidget {
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

*/