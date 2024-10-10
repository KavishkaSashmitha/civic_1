import 'dart:io';

import 'package:civic_1/exceptions/auth_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CustomerService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addService({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      await _firestore.collection('services').add({
        'name': name,
        'email': email,
        'message': message,
      });
      print('added successfully');
    } catch (e) {
      print('Error adding bin: $e');
      throw Exception('Failed to add bin');
    }
  }
}
