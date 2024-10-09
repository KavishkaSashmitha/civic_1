import 'package:civic_1/components/pulsating_live_button.dart';
import 'package:civic_1/screens/Incident_Detail_page.dart';
import 'package:civic_1/screens/settings_page.dart';
import 'package:civic_1/services/incident_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

class IncidentlistPage extends StatefulWidget {
  @override
  _IncidentlistPageState createState() => _IncidentlistPageState();
}

class _IncidentlistPageState extends State<IncidentlistPage> {
  int _currentIndex = 0;
  final IncidentService _incidentService = IncidentService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            Spacer(),
            Text(
              'Incidents',
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
  final IncidentService _incidentService = IncidentService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
      future: _incidentService.getIncidents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No active cases found.'));
        }

        // List of incidents
        List<DocumentSnapshot> incidents = snapshot.data!;

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: incidents.length,
            itemBuilder: (context, index) {
              // Extract incident data
              var incident = incidents[index].data() as Map<String, dynamic>;
              String title = incident['title'] ?? 'No Title';
              String organization =
                  incident['organization'] ?? 'No Organization';
              String description = incident['description'] ?? 'No Description';
              List<dynamic> imageUrls = incident['imageUrls'] ?? [];
              String imageUrl = imageUrls.isNotEmpty
                  ? imageUrls[0] // First image in the list
                  : 'https://via.placeholder.com/150'; // Placeholder if no image

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
                                  title,
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
                                  description,
                                  style: TextStyle(
                                    color: Colors.white70,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(height: 8),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0, left: 15),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_pin,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      organization,
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
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 10),
                          child: SizedBox(
                            width: 60,
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                          child: Text('Image failed to load'));
                                    },
                                  ),
                                ),
                                SizedBox(height: 8),
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
      },
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
