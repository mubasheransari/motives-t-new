import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Splash screen delay logic
    Timer(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>  LoginScreenDark()),
        (route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
          ),
          Center(
              child: Image.asset(
            'assets/logo.png',
            height: 200,
            width: 200,
          )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.40,
          ),
          ShaderMaskText(
              text: 'POWERED BY illustrationwizard'.toUpperCase(),
              textxfontsize: 19)
        ],
      ),
    );
  }
}
