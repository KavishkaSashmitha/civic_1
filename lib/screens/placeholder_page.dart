import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Action')),
      body: Center(
        child: Text(
          'This is the Placeholder Page for the FAB!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
