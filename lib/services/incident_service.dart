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
}
