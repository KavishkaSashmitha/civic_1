import 'package:flutter/material.dart';

class GroupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Group')),
      body: Center(
        child: Text(
          'This is the Community Page!',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
