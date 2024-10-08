import 'package:civic_1/services/incident_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUpdatePage extends StatefulWidget {
  final String incidentId;

  const AddUpdatePage({required this.incidentId, Key? key}) : super(key: key);

  @override
  _AddUpdatePageState createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final TextEditingController _updateController = TextEditingController();

  void _submitUpdate() async {
    if (_updateController.text.isNotEmpty) {
      try {
        await IncidentService().addIncidentTimeline(
          incidentId: widget.incidentId,
          eventDescription: _updateController.text,
        );

        Navigator.pop(context); // Return to the previous page
      } catch (e) {
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add update: $e')),
        );
      }
    } else {
      // Show a snackbar or alert for empty input
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update cannot be empty.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Update'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _submitUpdate,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _updateController,
          decoration: InputDecoration(
            labelText: 'Enter your update',
            border: OutlineInputBorder(),
          ),
          maxLines: null, // Allow multiple lines
        ),
      ),
    );
  }
}
