import 'package:civic_1/exceptions/auth_exception.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerNewUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? userId = userCredential.user?.uid;

      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'password': password,
        'userType': 'normal',
        'gender': '',
        'phone': '',
        'location': '',
      });
    } on FirebaseAuthException catch (e) {
      print('Error creating user: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error creating user: $e');
    }
  }

  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      print('Error signing in: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  // Method to get the logged-in user's details from Firestore
  Future<UserData?> getLoggedUser() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (userDoc.exists) {
          return UserData(
            name: userDoc.data()?['name'] ?? '',
            email: userDoc.data()?['email'] ?? '',
            events: userDoc.data()?['events'] ?? [],
          );
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }
}

class UserData {
  final String name;
  final String email;
  final List<dynamic> events;

  UserData({
    required this.name,
    required this.email,
    required this.events,
  });
}
