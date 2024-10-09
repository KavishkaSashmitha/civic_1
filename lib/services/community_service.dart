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
      return querySnapshot.docs.map((doc) {
        final event = Event.fromMap(doc.data() as Map<String, dynamic>);
        event.id = doc.id; // Assign the document ID to the event
        return event;
      }).toList();
    } catch (e) {
      print('Error getting events: $e');
      throw e;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
      print('Event deleted successfully!');
    } catch (e) {
      print('Error deleting event: $e');
      throw e;
    }
  }

  Future<void> editEvent(String eventId, Event updatedEvent) async {
    try {
      await _firestore
          .collection('events')
          .doc(eventId)
          .update(updatedEvent.toMap());
      print('Event updated successfully!');
    } catch (e) {
      print('Error updating event: $e');
      throw e;
    }
  }
}
