import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterSwitch(
                  width: 250,
                  height: 60,
                  valueFontSize: 16,
                  toggleSize: 60,
                  value: isSwitched,
                  borderRadius: 30.0,
                  padding: 5.0,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  activeToggleColor: Colors.white,
                  inactiveToggleColor: Colors.transparent,
                  activeSwitchBorder: Border.all(
                    color: Colors.red, // The border for the active switch
                    width: 2.0,
                  ),
                  inactiveSwitchBorder: Border.all(
                    color: Colors.grey, // The border for the inactive switch
                    width: 2.0,
                  ),
                  activeText: "UPCOMING",
                  inactiveText: "PAST EVENTS",
                  activeTextColor: Colors.red,
                  inactiveTextColor: Colors.grey,
                  activeTextFontWeight: FontWeight.bold,
                  inactiveTextFontWeight: FontWeight.bold,
                  showOnOff: true,
                  onToggle: (val) {
                    setState(() {
                      isSwitched = val;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isSwitched
                    ? 'This is the Community Page!'
                    : 'This is the Group Page!',
                style: TextStyle(color: Colors.white, fontSize: 20),
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
