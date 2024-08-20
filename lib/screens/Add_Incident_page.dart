import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddIncidentScreen extends StatefulWidget {
  const AddIncidentScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddIncidentScreenState createState() => _AddIncidentScreenState();
}

class _AddIncidentScreenState extends State<AddIncidentScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Incident',
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _titleController,
                labelText: 'Title',
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _addressController,
                labelText: 'Address / Organization',
              ),
              SizedBox(height: 16.0),
              _buildAddImagesButton(),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _descriptionController,
                labelText: 'Description',
                maxLines: 3,
              ),
              SizedBox(height: 16.0),
              _buildTextField(
                controller: _locationController,
                labelText: 'Location',
              ),
              SizedBox(height: 30.0),
              Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color(0xFFEAFEF1),
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    int maxLines = 1,
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 16.0),
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(115, 138, 123, 123),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: padding,
          ),
          style: TextStyle(color: Colors.white),
          maxLines: maxLines,
        ),
      ),
    );
  }

  Widget _buildAddImagesButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Action for Add Images button
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          padding: EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Text(
          'ADD IMAGES',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_titleController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _locationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    // Handle form submission logic here
  }
}
