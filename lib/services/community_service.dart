// lib/services/community_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:civic_1/model/event.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addEvent(Event event) async {
    try {
      await _firestore.collection('events').add(event.toMap());
      print('Event added successfully!');
    } catch (e) {
      print('Error adding event: $e');
      throw e;
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('events').get();
      return querySnapshot.docs
          .map((doc) => Event.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting events: $e');
      throw e;
    }
  }
}
