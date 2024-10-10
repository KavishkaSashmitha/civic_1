import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String? id;
  final String userId;
  final String organizationName;
  final String eventName;
  final String description;
  final DateTime eventDate;
  final double latitude;
  final double longitude;
  final String? imageUrl;

  Event({
    this.id,
    required this.userId,
    required this.organizationName,
    required this.eventName,
    required this.description,
    required this.eventDate,
    required this.latitude,
    required this.longitude,
    this.imageUrl,
  });

  factory Event.fromMap(Map<String, dynamic> data, {String? id}) {
    return Event(
      id: id,
      userId: data['userId'] ?? 'Unknown User',
      organizationName: data['organizationName'] ?? 'No Organization Name',
      eventName: data['eventName'] ?? 'No Event Name',
      description: data['description'] ?? 'No Description',
      eventDate: _parseEventDate(data['eventDate']),
      latitude: _parseLatitude(data['location']),
      longitude: _parseLongitude(data['location']),
      imageUrl: data['imageUrl'],
    );
  }

  static DateTime _parseEventDate(dynamic eventDate) {
    if (eventDate is Timestamp) {
      return eventDate.toDate();
    } else if (eventDate is String) {
      return DateTime.parse(eventDate);
    } else {
      return DateTime.now(); // Default value if parsing fails
    }
  }

  static double _parseLatitude(dynamic location) {
    if (location is GeoPoint) {
      return location.latitude;
    } else if (location is Map) {
      return (location['latitude'] as num).toDouble();
    } else {
      return 0.0; // Default value if parsing fails
    }
  }

  static double _parseLongitude(dynamic location) {
    if (location is GeoPoint) {
      return location.longitude;
    } else if (location is Map) {
      return (location['longitude'] as num).toDouble();
    } else {
      return 0.0; // Default value if parsing fails
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'organizationName': organizationName,
      'eventName': eventName,
      'description': description,
      'eventDate': Timestamp.fromDate(eventDate),
      'location': GeoPoint(latitude, longitude),
      'imageUrl': imageUrl,
    };
  }
}
