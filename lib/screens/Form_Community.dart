import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Form_Community extends StatefulWidget {
  @override
  _Form_CommunityState createState() => _Form_CommunityState();
}

class _Form_CommunityState extends State<Form_Community> {
  DateTime? _selectedDate;
  LatLng? _selectedLocation;

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
            'Lat: ${pickedLocation.latitude}, Lng: ${pickedLocation.longitude}';
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
      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _orgNameController,
                labelText: 'Organization Name',
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _eventNameController,
                labelText: 'Event Name',
              ),
              SizedBox(height: 10),
              _buildDatePickerField(context),
              SizedBox(height: 10),
              _buildTextField(
                controller: _descriptionController,
                labelText: 'Description',
                maxLines: 8,
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
              ),
              SizedBox(height: 10),
              _buildLocationPickerField(context),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Color(0xFFEAFEF1),
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
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3D3D3D),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color(0xFFC0C0C0)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: padding,
        ),
        style: TextStyle(color: Colors.white),
        maxLines: maxLines,
      ),
    );
  }

  Widget _buildDatePickerField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3D3D3D),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        decoration: InputDecoration(
          labelText: 'Event Date',
          labelStyle: TextStyle(color: Color(0xFFC0C0C0)),
          prefixIcon: Icon(Icons.date_range, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.datetime,
        onTap: () => _selectDate(context),
        readOnly: true,
        controller: TextEditingController(
          text: _selectedDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
              : '',
        ),
      ),
    );
  }

  Widget _buildLocationPickerField(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF3D3D3D),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: _locationController,
        decoration: InputDecoration(
          labelText: 'Location',
          labelStyle: TextStyle(color: Color(0xFFC0C0C0)),
          prefixIcon: Icon(Icons.map, color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
        ),
        style: TextStyle(color: Colors.white),
        readOnly: true,
        onTap: () => _selectLocation(context),
      ),
    );
  }

  void _handleSubmit() {
    if (_orgNameController.text.isEmpty ||
        _eventNameController.text.isEmpty ||
        _selectedDate == null ||
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }
    // Handle form submission logic here
  }
}

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _pickedLocation;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
        backgroundColor: Colors.black,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target:
              LatLng(37.7749, -122.4194), // Default location (San Francisco)
          zoom: 14,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        onTap: (location) {
          setState(() {
            _pickedLocation = location;
          });
        },
        markers: _pickedLocation != null
            ? {
                Marker(
                  markerId: MarkerId('selected-location'),
                  position: _pickedLocation!,
                ),
              }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_pickedLocation != null) {
            Navigator.of(context).pop(_pickedLocation);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select a location.')),
            );
          }
        },
        child: Icon(Icons.check),
        backgroundColor: Color(0xFFEAFEF1),
      ),
      backgroundColor: Colors.black,
    );
  }
}
