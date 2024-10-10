<<<<<<< Updated upstream
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
=======
// lib/models/event.dart

class User {
  final String userName;
  final String userEmail;
  final String message;

  User({
    required this.userName,
    required this.userEmail,
    required this.message,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      userName: data['userName'],
      userEmail: data['userEmail'],
      message: data['Message'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'userEmail': userEmail,
      'message': message,
    };
  }
>>>>>>> Stashed changes
}
