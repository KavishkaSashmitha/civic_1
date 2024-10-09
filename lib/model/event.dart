// lib/models/event.dart

class Event {
  final String organizationName;
  final String eventName;
  final String description;
  final DateTime eventDate;
  final double latitude;
  final double longitude;

  Event({
    required this.organizationName,
    required this.eventName,
    required this.description,
    required this.eventDate,
    required this.latitude,
    required this.longitude,
  });

  factory Event.fromMap(Map<String, dynamic> data) {
    return Event(
      organizationName: data['organizationName'],
      eventName: data['eventName'],
      description: data['description'],
      eventDate: DateTime.parse(data['eventDate']),
      latitude: data['location']['latitude'],
      longitude: data['location']['longitude'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizationName': organizationName,
      'eventName': eventName,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'location': {'latitude': latitude, 'longitude': longitude},
    };
  }
}
