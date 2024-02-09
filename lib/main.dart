import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto1_tienda/screens/home_screen.dart';
import 'package:proyecto1_tienda/providers/user_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF17203A),
        ),
      ),
      home: const HomeScreen(),
    );
  }
} 