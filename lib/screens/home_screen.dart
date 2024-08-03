import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    HomeTab(),
    GroupTab(),
    PlaceholderScreen(),
    NotificationsTab(),
    ProfileTab(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // Handle middle button tap
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
        notchMargin: 8.0, // Adjust the notch margin if needed
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
              color: _selectedIndex == 1 ? Colors.white : Colors.grey,
              onPressed: () => _onItemTapped(1),
            ),
            SizedBox(width: 40), // Space for the floating action button
            IconButton(
              icon: Icon(Icons.notifications),
              color: _selectedIndex == 3 ? Colors.white : Colors.grey,
              onPressed: () => _onItemTapped(3),
            ),
            IconButton(
              icon: Icon(Icons.person),
              color: _selectedIndex == 4 ? Colors.white : Colors.grey,
              onPressed: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onItemTapped(2),
        backgroundColor: Color(0xFFFF3131),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}

// Define the different screens
class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Home Screen',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class GroupTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Group Screen',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Notifications Screen',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Profile Screen',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

// Placeholder for the floating action button action
class PlaceholderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Placeholder Screen for FAB',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
