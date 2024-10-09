import 'package:civic_1/components/incident_location_map.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:civic_1/screens/incidentlist_page.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class IncidentReportScreen extends StatelessWidget {
  final String incidentId;

  IncidentReportScreen({required this.incidentId});

  Future<Map<String, dynamic>?> _getIncidentDetails() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('incidents')
        .doc(incidentId)
        .get();

    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null; // Incident not found
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

      return "${place.street ?? ''}, ${place.locality ?? ''}, ${place.country ?? ''}"; // Format the place name as desired
    } catch (e) {
      return "Unknown Location"; // Return this if reverse geocoding fails
    }
  }

  Future<List<Map<String, dynamic>>> _fetchIncidentTimeline() async {
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

  // Function to get the time difference as a human-readable string
  String _timeAgo(Timestamp timestamp) {
    DateTime now = DateTime.now();
    DateTime incidentTime = timestamp.toDate();
    Duration difference = now.difference(incidentTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IncidentlistPage()),
            );
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getIncidentDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Incident not found.'));
          }

          var incidentData = snapshot.data;
          String? location = incidentData?['location'];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        incidentData?['imageUrls'] != null &&
                                (incidentData!['imageUrls'] as List).isNotEmpty
                            ? incidentData['imageUrls'][0]
                            : 'https://via.placeholder.com/200', // Placeholder if no image
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Title and Status Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: FutureBuilder<String>(
                              future: _getPlaceName(location ?? ''),
                              builder: (context, locationSnapshot) {
                                if (locationSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text('Fetching location...');
                                }
                                return Text(
                                  locationSnapshot.data ?? 'Unknown Location',
                                  style: TextStyle(
                                    color: Colors.yellow[600],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              if (location != null) {
                                List<String> latLng = location.split(',');
                                if (latLng.length == 2) {
                                  double latitude = double.parse(latLng[0]);
                                  double longitude = double.parse(latLng[1]);

                                  LatLng incidentLatLng =
                                      LatLng(latitude, longitude);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IncidentLocationMap(
                                        incidentLocation: incidentLatLng,
                                        address: location,
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            behavior: HitTestBehavior.opaque,
                            child: CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.grey[800],
                              child: Icon(Icons.map, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5), // Add some space between the texts
                      Text(
                        incidentData?['organization'] ??
                            'Department of Immigration', // Display organization as fallback
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        incidentData?['title'] ?? 'Report of Bribery Incident',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: 5), // Space between title and description
                      Text(
                        incidentData?['description'] ??
                            'No description available', // Add this line to display the description
                        style: TextStyle(
                          color: Colors
                              .white70, // Use a lighter color for the description
                          fontSize: 16, // Adjust the font size as needed
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.circle, color: Colors.red, size: 12),
                          SizedBox(width: 5),
                          Text(
                            'Live',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Timeline Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchIncidentTimeline(),
                    builder: (context, timelineSnapshot) {
                      if (!timelineSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      List<Map<String, dynamic>> timeline =
                          timelineSnapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: timeline.map((entry) {
                          String time =
                              _timeAgo(entry['timestamp'] as Timestamp);
                          String detail = entry['eventDescription'] ??
                              'No event description available';

                          return _buildTimelineEntry(context, time, detail);
                        }).toList(),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle FAB press
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.send, color: Colors.black),
      ),
    );
  }

  Widget _buildTimelineEntry(BuildContext context, String time, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Column(
            children: [
              Icon(Icons.circle, size: 10, color: Colors.grey),
              Container(
                height: 40,
                width: 2,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  detail,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
