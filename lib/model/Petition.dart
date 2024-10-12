import 'package:cloud_firestore/cloud_firestore.dart';

class Petition {
  String? id;
  String title;
  String description;
  String duration;
  int signatures;
  String userId;

  Petition({
    this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.signatures,
    required this.userId,
  });

  // Factory method to create a Petition object from Firestore data
  factory Petition.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Petition(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      duration: data['duration'] ?? '',
      signatures: data['signatures'] ?? 0,
      userId: data['userId'] ?? '',
    );
  }

  // Method to convert Petition object to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'duration': duration,
      'signatures': signatures,
      'userId': userId,
    };
  }
}
