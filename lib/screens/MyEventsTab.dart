import 'package:civic_1/screens/EditEventPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:civic_1/model/event.dart'; // Assuming you have your Event model here
import 'package:civic_1/services/community_service.dart'; // Import your FirebaseService
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

class MyEventsTab extends StatefulWidget {
  @override
  _MyEventsTabState createState() => _MyEventsTabState();
}

class _MyEventsTabState extends State<MyEventsTab> {
  final FirebaseService _firebaseService =
      FirebaseService(); // Instance of FirebaseService
  late Future<List<Event>> _eventsFuture;
  final String userId =
      FirebaseAuth.instance.currentUser?.uid ?? ''; // Get current user ID

  @override
  void initState() {
    super.initState();
    _eventsFuture = _firebaseService
        .getUserEvents(userId); // Fetch events for logged-in user
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D3434),
      body: FutureBuilder<List<Event>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading events'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events found'));
          }

          final List<Event> events = snapshot.data!;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Card(
                color: Colors.grey[850],
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.eventName,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Organization: ${event.organizationName}',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                      Text(
                        'Date: ${event.eventDate.toLocal().toString()}',
                        style: GoogleFonts.poppins(color: Colors.white70),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {
                              _navigateToEditEvent(context, event);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              _deleteEvent(event.id!);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Method to delete the event using FirebaseService
  void _deleteEvent(String eventId) async {
    try {
      await _firebaseService.deleteEvent(eventId);
      // After deletion, refresh the event list
      setState(() {
        _eventsFuture = _firebaseService.getUserEvents(
            userId); // Update to fetch only the logged-in user's events
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete event')),
      );
    }
  }

  // Method to navigate to the event edit screen
  void _navigateToEditEvent(BuildContext context, Event event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditEventPage(event: event)),
    );

    // If the edit was successful, refresh the events list
    if (result == true) {
      setState(() {
        _eventsFuture = _firebaseService.getUserEvents(userId);
      });
    }
  }
}
