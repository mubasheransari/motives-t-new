import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:motives_tneww/screens/home.dart';
import 'package:motives_tneww/screens/splash.dart';
import 'package:motives_tneww/theme_change/theme_bloc.dart';
import 'package:motives_tneww/theme_change/theme_state.dart';

void main() {
    WidgetsFlutterBinding.ensureInitialized();
  runApp(
    BlocProvider(
      create: (_) => ThemeBloc(),
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
);

    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'BLoC Theme Switcher',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state.themeMode,
          home:MainScreen(),
        );
      },
    );
  }
}
