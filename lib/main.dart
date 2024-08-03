import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(CivicAlertApp());
}

class CivicAlertApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Civic Alert',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
    
  }
}
