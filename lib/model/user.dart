class User {
  final String name;
  final String email;
  final List<Event> events; // Assume you have an Event model.

  User({required this.name, required this.email, required this.events});
}

class Event {
  final String title;
  final DateTime date;

  Event({required this.title, required this.date});
}
