import 'package:civic_1/components/pulsating_live_button.dart';
import 'package:civic_1/screens/Incident_Detail_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class IncidentlistPage extends StatefulWidget {
  @override
  _IncidentlistPageState createState() => _IncidentlistPageState();
}

class _IncidentlistPageState extends State<IncidentlistPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Incidents',
            style: GoogleFonts.poppins(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.black,
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
              labels: ['Active Cases', 'Closed Cases'],
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
      floatingActionButton: PulsatingLiveButton(),
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
                              'Report of Bribery Incident',
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
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Department of Immigration',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, bottom: 10, right: 10),
                      child: SizedBox(
                        width: 60, // Set a fixed width for the image column
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://th.bing.com/th/id/OIP.iEiyLn0VVjVe8qknIDtwbQHaFO?w=1899&h=1340&rs=1&pid=ImgDetMain',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                      child: Text('Image failed to load'));
                                },
                              ),
                            ),
                            SizedBox(
                                height:
                                    8), // Space between image and "Live" text
                            Text(
                              'Live',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
        'Closed Cases',
        style: GoogleFonts.poppins(
          fontSize: 24,
          color: const Color.fromARGB(255, 252, 252, 252),
        ),
      ),
    );
  }
}
