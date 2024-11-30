import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/news_provider.dart';
import 'providers/theme_provider.dart'; // Import the ThemeProvider
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NewsProvider(),
      child: ChangeNotifierProvider(
        create: (_) => ThemeProvider(), // Add ThemeProvider here
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access ThemeProvider

    return MaterialApp(
      title: 'News App',
      home: HomeScreen(),
      theme: themeProvider.themeMode == ThemeMode.dark ? ThemeData.dark() : ThemeData.light(), // Use theme from ThemeProvider
    );
  }
}
