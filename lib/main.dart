import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/community_page.dart';
import 'screens/notifications_page.dart';
import 'screens/profile_page.dart';
import 'screens/placeholder_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFF1D1F24),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens to switch between
  final List<Widget> _screens = [
    HomePage(),
    PlaceholderPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GroupPage()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      backgroundColor: Color(0xFF000000),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Color(0xFF1D1F24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              color: _selectedIndex == 0 ? Colors.white : Colors.grey,
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.group),
              color: Colors.grey,
              onPressed: () => _onItemTapped(1),
            ),
            SizedBox(width: 40), // Space for the floating action button
            IconButton(
              icon: Icon(Icons.notifications),
              color: _selectedIndex == 2 ? Colors.white : Colors.grey,
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(Icons.person),
              color: _selectedIndex == 3 ? Colors.white : Colors.grey,
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(1),
        backgroundColor: Color(0xFFFF3131),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
