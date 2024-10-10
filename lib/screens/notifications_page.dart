import 'package:civic_1/components/pulsating_live_button.dart';
import 'package:civic_1/screens/Incident_Detail_page.dart';
import 'package:civic_1/screens/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: Row(
          children: [
            Spacer(),
            Text(
              'Notifications',
              style: GoogleFonts.poppins(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              );
            },
          ),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ToggleSwitch(
              minWidth: 120.0,
              cornerRadius: 30.0,
              activeBgColors: [
                [Colors.white],
                [Colors.white],
              ],
              activeFgColor: Colors.black,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.black,
              initialLabelIndex: _currentIndex,
              totalSwitches: 2,
              labels: ['New', 'Mentions'],
              radiusStyle: true,
              onToggle: (index) {
                setState(() {
                  _currentIndex = index!;
                });
              },
            ),
          ),
          Expanded(
            child:
                _currentIndex == 0 ? ActiveCasesScreen() : ClosedCasesScreen(),
          ),
        ],
      ),
    );
  }
}

class ActiveCasesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: 4, // Number of cards to display
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IncidentReportScreen()),
                );
              },
              child: Card(
                color: const Color.fromARGB(255, 61, 52, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 13.0, bottom: 8.0, left: 15),
                            child: Text(
                              'Incident Alert about',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20,
                                height: 1.1,
                              ),
                            ),
                          ),
                          SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Spotted Bribery Incident at of Department of Immigration...',
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 8.0, left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigate to My Incidents
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 50, 179, 205), // Green color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                  ),
                                  child: const Text('Accept',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(255, 3, 3, 3))),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigate to My Incidents
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                        255, 50, 179, 205), // Green color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                  ),
                                  child: const Text('Decline',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(255, 3, 3, 3))),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ClosedCasesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'All Notifications',
        style: GoogleFonts.poppins(
          fontSize: 24,
          color: const Color.fromARGB(255, 252, 252, 252),
        ),
      ),
    );
  }
}
