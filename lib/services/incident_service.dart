import 'dart:io';

import 'package:civic_1/exceptions/auth_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class IncidentService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(String imagePath) async {
    File imageFile = File(imagePath);
    String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    Reference reference = _storage.ref().child('incident_images/$fileName');

    await reference.putFile(imageFile);
    String imageUrl = await reference.getDownloadURL();
    return imageUrl;
  }

  Future<void> addIncident({
    required String title,
    required String organization,
    required String description,
    required String location,
    required List<String> imageUrls,
  }) async {
    String? userId = _auth.currentUser?.uid;

    await _firestore.collection('incidents').add({
      'title': title,
      'organization': organization,
      'description': description,
      'location': location,
      'imageUrls': imageUrls,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
      'timeline': [],
    });
  }

  Future<void> addIncidentTimeline({
    required String incidentId,
    required String eventDescription,
  }) async {
    String? userId = _auth.currentUser?.uid;

    try {
      // Add the timeline entry directly to a subcollection
      await _firestore
          .collection('incidents')
          .doc(incidentId)
          .collection('timeline')
          .add({
        'eventDescription': eventDescription,
        'timestamp': FieldValue.serverTimestamp(),
        'userId': userId,
      });
    } catch (e) {
      print('Error adding incident timeline: $e');
      throw e; // Optional: rethrow if you want to handle it in the UI
    }
  }

  Stream<DocumentSnapshot> getIncidentTimeline(String incidentId) {
    return _firestore.collection('incidents').doc(incidentId).snapshots();
  }

  // Fetch incidents including the 'title', 'organization', 'description', and 'imageUrls' fields
  Future<List<DocumentSnapshot>> getIncidents() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('incidents').get();
    return querySnapshot.docs;
  }
}
