import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:civic_1/screens/EditPetitionPage.dart'; // Make sure to create this file

class MyPetitionsPage extends StatefulWidget {
  @override
  _MyPetitionsPageState createState() => _MyPetitionsPageState();
}

class _MyPetitionsPageState extends State<MyPetitionsPage> {
  late Stream<QuerySnapshot> _petitionsStream;

  @override
  void initState() {
    super.initState();
    _initializePetitionsStream();
  }

  void _initializePetitionsStream() {
    // Fetch all petitions from the Firestore collection
    _petitionsStream = FirebaseFirestore.instance
        .collection('petitions')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF3D3434),
        child: StreamBuilder<QuerySnapshot>(
          stream: _petitionsStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Something went wrong',
                      style: GoogleFonts.poppins(color: Colors.white)));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No Petitions Found',
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
                  color: Colors.grey[850],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: ListTile(
                    title: Text(
                      data['title'],
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Status: ${data['status']}',
                            style: GoogleFonts.poppins(color: Colors.white70)),
                        Text('Signatures: ${data['signatures'] ?? 0}',
                            style: GoogleFonts.poppins(color: Colors.white70)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white),
                          onPressed: () => _editPetition(document.id, data),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.white),
                          onPressed: () => _deletePetition(document.id),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  void _editPetition(String id, Map<String, dynamic> petition) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              EditPetitionPage(petitionId: id, petition: petition)),
    );

    if (result == true) {
      // Refresh the petitions list if the edit was successful
      setState(() {
        _initializePetitionsStream();
      });
    }
  }

  void _deletePetition(String id) async {
    try {
      await FirebaseFirestore.instance.collection('petitions').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Petition deleted successfully')),
      );
    } catch (e) {
      print('Error deleting petition: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete petition')),
      );
    }
  }
}
