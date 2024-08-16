import 'package:civic_1/screens/Form_Community.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  int _currentIndex = 0;

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
              maxLines: 1,
            ),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ToggleSwitch(
                  minWidth: 120.0,
                  cornerRadius: 20.0,
                  activeBgColors: [
                    [Colors.white],
                    [Colors.white]
                  ],
                  activeFgColor: Colors.red,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.black,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Form_Community()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // Aligns to the right corner
      backgroundColor: Colors.black,
    );
  }
}
