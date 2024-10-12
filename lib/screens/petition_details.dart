import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class PetitionDetailsScreen extends StatefulWidget {
  final DocumentSnapshot petition;

  PetitionDetailsScreen({required this.petition});

  @override
  _PetitionDetailsScreenState createState() => _PetitionDetailsScreenState();
}

class _PetitionDetailsScreenState extends State<PetitionDetailsScreen> {
  bool _isLoading = false; // State to manage loading status

  void _voteForPetition() async {
    setState(() {
      _isLoading = true; // Start the loading state
    });

    try {
      await FirebaseFirestore.instance
          .collection('petitions')
          .doc(widget.petition.id)
          .update({
        'signatures': widget.petition['signatures'] + 1,
      });

      // Update the state to reflect the new number of signatures
      setState(() {
        _isLoading = false; // End the loading state
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // End the loading state in case of an error
      });
      print('Error voting for petition: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.petition['title'],
          style: GoogleFonts.openSans(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.petition['title'],
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.petition['description'],
              style: TextStyle(color: Colors.grey[300], fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              'Duration: ${widget.petition['duration']}',
              style: TextStyle(color: Colors.grey[400]),
            ),
            SizedBox(height: 10),
            Text(
              'Signatures: ${widget.petition['signatures']}',
              style: TextStyle(color: Colors.grey[400]),
            ),
            Spacer(),
            Center(
              child: _isLoading
                  ? CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    )
                  : ElevatedButton(
                      onPressed: _voteForPetition,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      child: Text(
                        'Vote for this Petition',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
