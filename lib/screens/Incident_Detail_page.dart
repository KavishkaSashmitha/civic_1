import 'package:civic_1/screens/incidentlist_page.dart';
import 'package:flutter/material.dart';

class IncidentReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => IncidentlistPage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Container(
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://th.bing.com/th/id/OIP.iEiyLn0VVjVe8qknIDtwbQHaFO?w=1899&h=1340&rs=1&pid=ImgDetMain',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Title and Status Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '1456/A Batharamula rd,...',
                        style: TextStyle(
                          color: Colors.yellow[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 10),
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.grey[800],
                        child: Icon(Icons.map, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Report of Bribery Incident',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(Icons.circle, color: Colors.red, size: 12),
                      SizedBox(width: 5),
                      Text(
                        'Live',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Timeline Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildTimelineEntry(
                    context,
                    '10 hours ago',
                    'Spotted Bribery Incident at Department of Immigration',
                  ),
                  _buildTimelineEntry(
                    context,
                    '8 hours ago',
                    'Witness Reported Incident to Police Station of Batharamula',
                  ),
                  _buildTimelineEntry(
                    context,
                    '10 minutes ago',
                    'There has been no follow-up action from the police regarding the reported bribery incident',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle FAB press
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.send, color: Colors.black),
      ),
    );
  }

  Widget _buildTimelineEntry(BuildContext context, String time, String detail) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Column(
            children: [
              Icon(Icons.circle, size: 10, color: Colors.grey),
              Container(
                height: 40,
                width: 2,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  detail,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
