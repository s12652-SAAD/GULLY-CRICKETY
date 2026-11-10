import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GullyCricketApp());
}

class GullyCricketApp extends StatelessWidget {
  const GullyCricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF0B1724);
    const green = Color(0xFFB8F34A);
    return MaterialApp(
      title: 'Gully Cricket',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: navy,
        colorScheme: ColorScheme.fromSeed(
          seedColor: green,
          brightness: Brightness.dark,
          surface: const Color(0xFF142333),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          centerTitle: false,
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF142333),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
