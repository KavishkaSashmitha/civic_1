import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyIncidentsPage extends StatefulWidget {
  @override
  _MyIncidentsPageState createState() => _MyIncidentsPageState();
}

class _MyIncidentsPageState extends State<MyIncidentsPage> {
  List<String> updates = []; // List to store incident updates

  void _addUpdate() {
    setState(() {
      // Sample text for the update, you can modify this as needed
      updates.add(
          'Sample update text for incident ${updates.length + 1}. This is a longer update text to demonstrate text fading in case it exceeds the available space.');
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2, // Adjust this to the number of incidents you have
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  color: const Color(0xFF3D3434), // Dark background for card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Padding for the card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title and description
                        ListTile(
                          contentPadding:
                              const EdgeInsets.all(0), // No additional padding
                          title: Text(
                            'Report of Bribery Incident',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Spotted Bribery Incident at Department of Immigration. Witness Reported...',
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      'Department of Immigration',
                                      style: GoogleFonts.poppins(
                                        color: Colors.orange,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow
                                          .ellipsis, // Fade out if overflow
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: Colors.white70),
                        // Updates Timeline
                        const SizedBox(height: 8),
                        Text(
                          'Updates:',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: updates.length,
                          itemBuilder: (context, updateIndex) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Text(
                                updates[updateIndex],
                                style: GoogleFonts.poppins(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow
                                    .ellipsis, // Fade out if overflow
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        // Buttons for status and delete
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Status functionality
                                  },
                                  child: Text(
                                    'STATUS',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Delete functionality
                                  },
                                  child: Text(
                                    'DELETE',
                                    style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Add Update button
                        Align(
                          alignment:
                              Alignment.centerRight, // Align to the right
                          child: TextButton.icon(
                            onPressed: _addUpdate,
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            label: Text(
                              'ADD UPDATE',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
