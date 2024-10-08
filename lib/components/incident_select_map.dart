import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  final Function(LatLng) onLocationSelected;

  const MapScreen({required this.onLocationSelected, Key? key})
      : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _selectedLocation = LatLng(37.7749, -122.4194); // Default location
  TextEditingController _searchController = TextEditingController();
  final String _nominatimUrl = 'https://nominatim.openstreetmap.org/search';
  MapController _mapController = MapController(); // Add MapController

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  void _confirmLocation() {
    widget.onLocationSelected(_selectedLocation);
    Navigator.pop(context);
  }

  Future<void> _searchLocation(String query) async {
    final uri = Uri.parse(
        '$_nominatimUrl?q=$query&format=json&limit=1'); // Using Nominatim OpenStreetMap API
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      if (data.isNotEmpty) {
        final LatLng location = LatLng(
          double.parse(data[0]['lat']),
          double.parse(data[0]['lon']),
        );
        setState(() {
          _selectedLocation = location;
        });
        // Move the map to the searched location
        _mapController.move(location, 12); // Update map center and zoom
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _confirmLocation,
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController, // Assign the MapController
            options: MapOptions(
              onTap: (tapPosition, point) {
                _onMapTap(point);
              },
              initialCenter: _selectedLocation, // Initial center
              initialZoom: 12, // Initial zoom
              // Allow scrolling, zooming, rotating, etc.
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_pin,
                      size: 40.0,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 10,
            left: 10,
            right: 10,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search location...',
                          border: InputBorder.none,
                        ),
                        onSubmitted: _searchLocation,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _searchLocation(_searchController.text),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
