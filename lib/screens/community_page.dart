import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:intl/intl.dart';
import 'package:civic_1/screens/Form_Community.dart';
import 'package:civic_1/screens/event_detail.dart';
import 'package:civic_1/services/community_service.dart';
import 'package:civic_1/model/event.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:civic_1/screens/settings_page.dart';

class GroupPage extends StatefulWidget {
  @override
  _GroupPageState createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  int _currentIndex = 0;
  List<Event> _events = [];
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    try {
      List<Event> events = await _firebaseService.getEvents();
      setState(() {
        _events = events;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading events: $e')),
      );
    }
  }

  List<Event> get _filteredEvents {
    final now = DateTime.now();
    return _events.where((event) {
      return _currentIndex == 0
          ? event.eventDate.isAfter(now)
          : event.eventDate.isBefore(now);
    }).toList();
  }

  void _openMap(double latitude, double longitude) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the map')),
      );
    }
  }

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
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
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
                    [Colors.red],
                    [Colors.red]
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
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
            SizedBox(height: 20),
            Expanded(
              child: _filteredEvents.isEmpty
                  ? Center(
                      child: Text(
                        'No events to display',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = _filteredEvents[index];
                        return Card(
                          color: Colors.grey[850],
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.event, color: Colors.white),
                            title: Text(
                              event.eventName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${event.organizationName}\n${DateFormat('yyyy-MM-dd').format(event.eventDate)}',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.map, color: Colors.red),
                                  onPressed: () =>
                                      _openMap(event.latitude, event.longitude),
                                ),
                                Icon(Icons.arrow_forward_ios,
                                    color: Colors.white),
                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EventDetailPage(event: event),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Form_Community()),
          );
          _loadEvents();
        },
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      backgroundColor: Colors.black,
    );
  }
}
