// lib/screens/edit_event_screen.dart

import 'package:flutter/material.dart';
import 'package:civic_1/model/event.dart';
import 'package:civic_1/services/community_service.dart'; // Import your Firebase service if needed

class EditEventScreen extends StatefulWidget {
  final Event event;

  EditEventScreen({required this.event});

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late TextEditingController _eventNameController;
  late TextEditingController _organizationNameController;
  late TextEditingController _descriptionController;
  late DateTime _eventDate;

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController(text: widget.event.eventName);
    _organizationNameController =
        TextEditingController(text: widget.event.organizationName);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _eventDate = widget.event.eventDate;
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _organizationNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            TextField(
              controller: _organizationNameController,
              decoration: InputDecoration(labelText: 'Organization Name'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectDate,
              child: Text('Select Event Date'),
            ),
            SizedBox(height: 20),
            Text('Selected Date: ${_eventDate.toLocal()}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEvent,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _eventDate) {
      setState(() {
        _eventDate = pickedDate;
      });
    }
  }

  void _saveEvent() {
    final updatedEvent = Event(
      userId: widget.event.userId,
      organizationName: _organizationNameController.text,
      eventName: _eventNameController.text,
      description: _descriptionController.text,
      eventDate: _eventDate,
      latitude: widget.event.latitude,
      longitude: widget.event.longitude,
    );

    _firebaseService.editEvent(widget.event.id!, updatedEvent).then((_) {
      Navigator.pop(context);
    }).catchError((error) {
      // Handle the error accordingly
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating event: $error')),
      );
    });
  }
}
