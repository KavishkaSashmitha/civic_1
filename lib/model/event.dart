class Event {
  String? id; // Unique identifier for the event from Firestore
  final String userId; // Field for the logged-in user ID
  final String organizationName;
  final String eventName;
  final String description;
  final DateTime eventDate;
  final double latitude;
  final double longitude;

  Event({
    this.id, // Optional field for Firestore ID
    required this.userId, // Include the userId in the constructor
    required this.organizationName,
    required this.eventName,
    required this.description,
    required this.eventDate,
    required this.latitude,
    required this.longitude,
  });

  // Updated factory method to safely handle potential null values and assign ID
  factory Event.fromMap(Map<String, dynamic> data, {String? id}) {
    return Event(
      id: id, // Assign the Firestore document ID if provided
      userId: data['userId'] ??
          'Unknown User', // Default to 'Unknown User' if userId is null
      organizationName: data['organizationName'] ?? 'No Organization Name',
      eventName: data['eventName'] ?? 'No Event Name',
      description: data['description'] ?? 'No Description',
      eventDate: data['eventDate'] != null
          ? DateTime.parse(data['eventDate'])
          : DateTime.now(), // Use the current date if eventDate is null
      latitude: data['location'] != null && data['location']['latitude'] != null
          ? (data['location']['latitude'] as num).toDouble()
          : 0.0, // Default to 0.0 if latitude is null
      longitude:
          data['location'] != null && data['location']['longitude'] != null
              ? (data['location']['longitude'] as num).toDouble()
              : 0.0, // Default to 0.0 if longitude is null
    );
  }

  // Updated toMap method to include userId and support conversion to Firestore format
  Map<String, dynamic> toMap() {
    return {
      'userId': userId, // Add userId to the map
      'organizationName': organizationName,
      'eventName': eventName,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
    };
  }
}
