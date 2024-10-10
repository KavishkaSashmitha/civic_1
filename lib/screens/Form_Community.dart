import 'dart:io';
import 'package:civic_1/screens/LocationPickerScreen.dart';
import 'package:civic_1/services/community_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:civic_1/model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class Form_Community extends StatefulWidget {
  @override
  _Form_CommunityState createState() => _Form_CommunityState();
}

class _Form_CommunityState extends State<Form_Community> {
  DateTime? _selectedDate;
  LatLng? _selectedLocation;
  File? _image;

  final TextEditingController _orgNameController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _orgNameController.dispose();
    _eventNameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime tomorrow = now.add(Duration(days: 1));
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? tomorrow,
      firstDate: tomorrow,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectLocation(BuildContext context) async {
    final LatLng? pickedLocation = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => LocationPickerScreen()),
    );

    if (pickedLocation != null) {
      setState(() {
        _selectedLocation = pickedLocation;
        _locationController.text =
            'Lat: ${pickedLocation.latitude.toStringAsFixed(4)}, Lng: ${pickedLocation.longitude.toStringAsFixed(4)}';
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1E1E1E)],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(
                  controller: _orgNameController,
                  labelText: 'Organization Name',
                  icon: Icons.business,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _eventNameController,
                  labelText: 'Event Name',
                  icon: Icons.event,
                ),
                SizedBox(height: 16),
                _buildDatePickerField(context),
                SizedBox(height: 16),
                _buildTextField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  maxLines: 4,
                  icon: Icons.description,
                ),
                SizedBox(height: 16),
                _buildLocationPickerField(context),
                SizedBox(height: 24),
                _buildImagePicker(),
                SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    child: Text('Submit', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Color(0xFFEAFEF1),
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
          prefixIcon: Icon(icon, color: Color(0xFFEAFEF1)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ),
        style: TextStyle(color: Colors.white),
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Icon(Icons.calendar_today, color: Color(0xFFEAFEF1)),
              SizedBox(width: 16),
              Text(
                _selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                    : 'Select Event Date',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationPickerField(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectLocation(context),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            children: [
              Icon(Icons.location_on, color: Color(0xFFEAFEF1)),
              SizedBox(width: 16),
              Expanded(
                child: Text(
                  _selectedLocation != null
                      ? 'Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(4)}'
                      : 'Select Location',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: _image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: Image.file(_image!, fit: BoxFit.cover),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate,
                        color: Color(0xFFEAFEF1), size: 48),
                    SizedBox(height: 8),
                    Text('Add Event Image',
                        style: TextStyle(color: Color(0xFFB0B0B0))),
                  ],
                ),
              ),
      ),
    );
  }

  void _handleSubmit() async {
    if (_orgNameController.text.isEmpty ||
        _eventNameController.text.isEmpty ||
        _selectedDate == null ||
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User not logged in. Please log in first.')),
      );
      return;
    }

    final event = Event(
      userId: user.uid,
      organizationName: _orgNameController.text,
      eventName: _eventNameController.text,
      description: _descriptionController.text,
      eventDate: _selectedDate!,
      latitude: _selectedLocation!.latitude,
      longitude: _selectedLocation!.longitude,
    );

    final firebaseService = FirebaseService();
    try {
      await firebaseService.addEvent(event, image: _image);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event added successfully!')),
      );
      // Clear form or navigate back
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding event: $error')),
      );
    }
  }
}
