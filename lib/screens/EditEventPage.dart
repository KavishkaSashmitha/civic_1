import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:civic_1/model/event.dart';
import 'package:civic_1/services/community_service.dart';

class EditEventPage extends StatefulWidget {
  final Event event;

  const EditEventPage({Key? key, required this.event}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _organizationNameController;
  late TextEditingController _eventNameController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _organizationNameController =
        TextEditingController(text: widget.event.organizationName);
    _eventNameController = TextEditingController(text: widget.event.eventName);
    _descriptionController =
        TextEditingController(text: widget.event.description);
    _selectedDate = widget.event.eventDate;
  }

  @override
  void dispose() {
    _organizationNameController.dispose();
    _eventNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        Event updatedEvent = Event(
          id: widget.event.id,
          userId: widget.event.userId,
          organizationName: _organizationNameController.text,
          eventName: _eventNameController.text,
          description: _descriptionController.text,
          eventDate: _selectedDate,
          latitude: widget.event.latitude,
          longitude: widget.event.longitude,
        );

        await _firebaseService.editEvent(widget.event.id!, updatedEvent);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Event updated successfully')),
        );
        Navigator.pop(
            context, true); // Return true to indicate successful update
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update event: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                child: TextFormField(
                  controller: _organizationNameController,
                  decoration:
                      const InputDecoration(labelText: 'Organization Name'),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter an organization name'
                      : null,
                ),
              ),
              const SizedBox(height: 15),
              _buildCard(
                child: TextFormField(
                  controller: _eventNameController,
                  decoration: const InputDecoration(labelText: 'Event Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an event name' : null,
                ),
              ),
              const SizedBox(height: 15),
              _buildCard(
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
              ),
              const SizedBox(height: 15),
              _buildCard(
                child: ListTile(
                  title: const Text('Event Date',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(
                    '${_selectedDate.toLocal().toString().split(' ')[0]}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  trailing:
                      const Icon(Icons.calendar_today, color: Colors.black54),
                  onTap: () => _selectDate(context),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D3434),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    elevation: 5,
                  ),
                  child: Text('Update Event',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: child,
      ),
    );
  }
}
