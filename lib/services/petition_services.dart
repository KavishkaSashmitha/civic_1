import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:civic_1/model/petition.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method to fetch all petitions from Firestore
  Future<List<Petition>> getAllPetitions() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('petitions').get();
      return snapshot.docs.map((doc) => Petition.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching petitions: $e');
    }
  }

  // Method to fetch petitions for a specific user
  Future<List<Petition>> getUserPetitions(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('petitions')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs.map((doc) => Petition.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Error fetching user petitions: $e');
    }
  }

  // Method to add a new petition to Firestore
  Future<void> addPetition(Petition petition) async {
    try {
      await _firestore.collection('petitions').add(petition.toMap());
    } catch (e) {
      throw Exception('Error adding petition: $e');
    }
  }

  // Method to update an existing petition in Firestore
  Future<void> updatePetition(Petition petition) async {
    try {
      await _firestore
          .collection('petitions')
          .doc(petition.id)
          .update(petition.toMap());
    } catch (e) {
      throw Exception('Error updating petition: $e');
    }
  }

  // Method to delete a petition from Firestore
  Future<void> deletePetition(String petitionId) async {
    try {
      await _firestore.collection('petitions').doc(petitionId).delete();
    } catch (e) {
      throw Exception('Error deleting petition: $e');
    }
  }

  // Method to get a specific petition by its ID
  Future<Petition?> getPetitionById(String petitionId) async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection('petitions').doc(petitionId).get();
      if (docSnapshot.exists) {
        return Petition.fromFirestore(docSnapshot);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching petition: $e');
    }
  }
}
