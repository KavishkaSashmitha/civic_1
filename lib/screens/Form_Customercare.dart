import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:intl/intl.dart';
import '../services/customer_service.dart';

class Form_Customercare extends StatefulWidget {
  @override
  _Form_CustomercareState createState() => _Form_CustomercareState();
}

class _Form_CustomercareState extends State<Form_Customercare> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  final CustomerService _customerService = CustomerService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    // Add incident
    await _customerService.addService(
      name: _nameController.text,
      email: _emailController.text,
      message: _messageController.text,
    );

    // Clear fields after submission
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service added successfully.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Care'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(6.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nameController,
                labelText: 'Full Name',
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
              ),
              SizedBox(height: 10),
              _buildTextField(
                controller: _messageController,
                labelText: 'Message',
                maxLines: 8,
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 16.0),
              ),
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
}
