import 'package:civic_1/screens/Add_incident_update_page.dart';
import 'package:civic_1/services/incident_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyIncidentsPage extends StatefulWidget {
  @override
  _MyIncidentsPageState createState() => _MyIncidentsPageState();
}

class _MyIncidentsPageState extends State<MyIncidentsPage> {
  final IncidentService _incidentService = IncidentService();
  List<DocumentSnapshot> _incidents = []; // Store fetched incidents

  @override
  void initState() {
    super.initState();
    _fetchIncidents(); // Fetch incidents when the page loads
  }

  Future<void> _fetchIncidents() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('incidents').get();
    setState(() {
      _incidents = querySnapshot.docs;
    });
  }

  // Fetch the timeline from the subcollection
  Future<List<Map<String, dynamic>>> _fetchIncidentTimeline(
      String incidentId) async {
    QuerySnapshot timelineSnapshot = await FirebaseFirestore.instance
        .collection('incidents')
        .doc(incidentId)
        .collection('timeline')
        .orderBy('timestamp', descending: false)
        .get();

    return timelineSnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  // Function to reverse geocode latitude and longitude to a place name
  Future<String> _getPlaceName(String location) async {
    try {
      List<String> latLng = location.split(',');
      double latitude = double.parse(latLng[0]);
      double longitude = double.parse(latLng[1]);

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks.first;

      return "${place.street}, ${place.locality}, ${place.country}"; // Format the place name as desired
    } catch (e) {
      return "Unknown Location"; // Return this if reverse geocoding fails
    }
  }

  void _navigateToAddUpdate(String incidentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddUpdatePage(incidentId: incidentId),
      ),
    ).then((_) {
      // Refresh the incidents list after returning
      _fetchIncidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _incidents.length,
            itemBuilder: (context, index) {
              var incidentData =
                  _incidents[index].data() as Map<String, dynamic>?;

              if (incidentData == null) return SizedBox(); // Skip if null

              String incidentId = _incidents[index].id;

              String? location =
                  incidentData['location']; // Extract location here

              return FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchIncidentTimeline(incidentId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(); // Show a loading indicator while fetching data
                  }

                  List<Map<String, dynamic>> timeline = snapshot.data ?? [];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Card(
                      color:
                          const Color(0xFF3D3434), // Dark background for card
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and description
                            ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: Text(
                                incidentData['title'] ??
                                    'Untitled Incident', // Handle null title
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    incidentData['description'] ??
                                        'No description available', // Handle null description
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 13,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_pin,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: location != null
                                            ? FutureBuilder<String>(
                                                future: _getPlaceName(location),
                                                builder: (context,
                                                    locationSnapshot) {
                                                  if (!locationSnapshot
                                                      .hasData) {
                                                    return const Text(
                                                        'Fetching location...');
                                                  }
                                                  return Text(
                                                    locationSnapshot.data ??
                                                        'Unknown Location', // Display the place name
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.orange,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  );
                                                },
                                              )
                                            : Text(
                                                'Location not specified', // Handle null location
                                                style: GoogleFonts.poppins(
                                                  color: Colors.orange,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(color: Colors.white70),
                            // Updates Timeline
                            const SizedBox(height: 8),
                            Text(
                              'Updates:',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: timeline.length,
                              itemBuilder: (context, updateIndex) {
                                var eventDescription = timeline[updateIndex]
                                        ['eventDescription'] ??
                                    'No event description';
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Text(
                                    eventDescription,
                                    style: GoogleFonts.poppins(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            // Add Update button
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () =>
                                    _navigateToAddUpdate(incidentId),
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'ADD UPDATE',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
