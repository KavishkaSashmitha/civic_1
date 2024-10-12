import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditPetitionPage extends StatefulWidget {
  final String petitionId;
  final Map<String, dynamic> petition;

  EditPetitionPage({required this.petitionId, required this.petition});

  @override
  _EditPetitionPageState createState() => _EditPetitionPageState();
}

class _EditPetitionPageState extends State<EditPetitionPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.petition['title']);
    _descriptionController =
        TextEditingController(text: widget.petition['description']);
    _status = widget.petition['status'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Edit Petition',
            style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body: Container(
        color: const Color(0xFF3D3434),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              style: GoogleFonts.poppins(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: GoogleFonts.poppins(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _descriptionController,
              style: GoogleFonts.poppins(color: Colors.white),
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: GoogleFonts.poppins(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _status,
              dropdownColor: Colors.grey[850],
              style: GoogleFonts.poppins(color: Colors.white),
              onChanged: (String? newValue) {
                setState(() {
                  _status = newValue!;
                });
              },
              items: <String>['Ongoing', 'Closed']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _updatePetition,
                child: Text('Update Petition'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  textStyle: GoogleFonts.poppins(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updatePetition() async {
    try {
      await FirebaseFirestore.instance
          .collection('petitions')
          .doc(widget.petitionId)
          .update({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'status': _status,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Petition updated successfully')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      print('Error updating petition: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update petition')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
