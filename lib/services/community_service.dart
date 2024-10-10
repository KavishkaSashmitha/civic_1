import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:civic_1/model/event.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File image) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child('event_images/$fileName');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw e;
    }
  }

  Future<void> addEvent(Event event, {File? image}) async {
    try {
      String? imageUrl;
      if (image != null) {
        imageUrl = await uploadImage(image);
      }

      final eventData = event.toMap();
      if (imageUrl != null) {
        eventData['imageUrl'] = imageUrl;
      }

      await _firestore.collection('events').add(eventData);
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

  Future<List<Event>> getUserEvents(String userId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('events')
          .where('userId', isEqualTo: userId) // Filter by userId
          .get();
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
      // Check if the eventId is valid
      if (eventId.isEmpty) {
        throw 'Event ID cannot be empty';
      }

      // Update the Firestore document
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
