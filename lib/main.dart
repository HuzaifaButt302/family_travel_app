import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/family_provider.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize provider with database data
  final familyProvider = FamilyProvider();
  await familyProvider.initializeData();

  runApp(
    ChangeNotifierProvider.value(
      value: familyProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Family Travel Vault - Document Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Modern UI ke liye zaroori hai
      ),
      home: const SplashScreen(),
    );
  }
}
