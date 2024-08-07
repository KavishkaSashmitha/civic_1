import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              'EVENTS',
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1, // Use maxLines to limit the number of lines
            ),
          ),
        ),
        backgroundColor:
            Colors.black, // Correct property for AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20), // Add space from the top
            Center(
              child: Padding(
                padding: const EdgeInsets.all(
                    8.0), // Add padding around the ToggleSwitch
                child: ToggleSwitch(
                  minWidth: 120.0,
                  cornerRadius: 20.0,
                  activeBgColors: [
                    [Colors.white], // Change active background color
                    [Colors.white] // Change active background color
                  ],
                  activeFgColor: Colors.red, // Change text color when active
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor:
                      Colors.black, // Change text color when inactive
                  initialLabelIndex: _currentIndex,
                  totalSwitches: 2,
                  labels: ['UPCOMING', 'PAST EVENTS'],
                  radiusStyle: true,
                  onToggle: (index) {
                    setState(() {
                      _currentIndex = index!;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

void main() => runApp(MaterialApp(
      home: GroupPage(),
    ));
