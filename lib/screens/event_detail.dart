// lib/screens/event_detail.dart

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Make sure to add google_maps_flutter to your pubspec.yaml
import 'package:civic_1/model/event.dart';
import 'package:intl/intl.dart'; // Adjust the import according to your project structure

class EventDetailPage extends StatelessWidget {
  final Event event;

  EventDetailPage({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.eventName),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              event.description,
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Event Date: ${DateFormat('yyyy-MM-dd').format(event.eventDate)}',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),
          Container(
            height: 300, // Set height for the map
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(event.latitude, event.longitude),
                zoom: 14.0,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('eventLocation'),
                  position: LatLng(event.latitude, event.longitude),
                  infoWindow: InfoWindow(title: event.eventName),
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
