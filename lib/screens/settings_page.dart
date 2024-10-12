import 'package:civic_1/screens/Add_petition.dart';
import 'package:civic_1/screens/Mypetitions.dart';
import 'package:civic_1/screens/my_incident_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:civic_1/screens/MyEventsTab.dart';
// Import the new file

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            indicatorColor: Colors.orange,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: 'My Incidents'),
              Tab(text: 'My Events'),
              Tab(text: 'My Profile'),
              Tab(text: 'Notifications'),
              Tab(text: 'My Petitions'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyIncidentsPage(),
            MyEventsTab(),
            MyProfileTab(),
            NotificationsTab(),
            MyPetitionsPage(), // Use the new MyPetitionsPage here
          ],
        ),
      ),
    );
  }
}

class MyIncidentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3D3434), // Background similar to incidents page
      child: Center(
        child: Text(
          'My Incidents',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MyProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3D3434), // Background similar to incidents page
      child: Center(
        child: Text(
          'My Profile',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class NotificationsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3D3434), // Background similar to incidents page
      child: Center(
        child: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// New MyPetitionsTab class to display user petitions
class MyPetitionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is where you can retrieve and display the petitions you've added
    return Container(
      color: const Color(0xFF3D3434), // Background similar to other pages
      child: Center(
        child: Text(
          'My Petitions',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
