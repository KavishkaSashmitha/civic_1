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

<<<<<<< Updated upstream
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
=======
  // Update user
  Future<void> updateUser(String name, String email, String password) async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    try {
      if (password.isNotEmpty) {
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
        await user.reauthenticateWithCredential(credential);
      }

      if (email != user.email) {
        await user.updateEmail(email);
      }
      if (password.isNotEmpty) {
        await user.updatePassword(password);
      }

      await _firestore.collection('users').doc(user.uid).update({
        'name': name,
        'email': email,
      });

      print('User updated successfully');
    } on FirebaseAuthException catch (e) {
      print('Error updating user: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error updating user: $e');
      throw Exception('Failed to update user');
    }
  }

  // Get profile data
  Future<Map<String, String?>> getUserProfileData() async {
    User? user = _auth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in.');
    }

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;

        return {
          'name': data?['name'] ?? '',
          'email': data?['email'] ?? user.email,
          'gender': data?['gender'] ?? '',
          'phone': data?['phone'] ?? '',
          'location': data?['location'] ?? '',
          'userType': data?['userType'] ?? 'normal',
          'image_url':
              data?['image_url'] ?? '', // Fetch image URL from Firestore
        };
      } else {
        throw Exception('User profile not found.');
      }
    } catch (e) {
      print('Error fetching user profile data: $e');
      throw Exception('Failed to fetch user profile data');
    }
  }

  // Signout
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('Signed out');
    } on FirebaseAuthException catch (e) {
      print('Error signing out: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      print('Error signing out: $e');
    }
  }
>>>>>>> Stashed changes
}
