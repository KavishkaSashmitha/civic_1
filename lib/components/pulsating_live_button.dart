import 'package:civic_1/screens/Add_Incident_page.dart';
import 'package:flutter/material.dart';

class PulsatingLiveButton extends StatefulWidget {
  @override
  _PulsatingLiveButtonState createState() => _PulsatingLiveButtonState();
}

class _PulsatingLiveButtonState extends State<PulsatingLiveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddIncidentScreen()),
          );
        },
        backgroundColor: Colors.red,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.6),
                blurRadius: 20.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              'LIVE',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddIncidentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Incident'),
      ),
      body: Center(
        child: Text('This is the Add Incident page'),
      ),
    );
  }
}
