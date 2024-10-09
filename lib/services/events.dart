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
}
