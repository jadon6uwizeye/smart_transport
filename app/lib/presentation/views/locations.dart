import 'package:app/presentation/views/message_notifications.dart';
import 'package:app/presentation/views/outgoing.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationMap extends StatefulWidget {
  final List<LatLng> locations;

  LocationMap({required this.locations});

  @override
  _LocationMapState createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  GoogleMapController? _controller;
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    // Make the initial API call
    _getDestinations();

    // Setup a timer to call the API every 4 seconds
    // _timer = Timer.periodic(Duration(seconds: 4), (timer) {
    //   _callAPIForDestinations();
    // });
  }

  @override
  void dispose() {
    // Cancel the timer to avoid memory leaks
    _timer.cancel();
    super.dispose();
  }

  // Function to call the initial API endpoint
  Future<void> _getDestinations() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);
    final response = await http.get(
      Uri.parse('http://192.168.43.39:8001/location/get_destinations/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // pass token from local storage
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var decoded_resp = json.decode(response.body);
      // Parse the response and get destinationIds
      List destinationIds =
          decoded_resp.map((destination) => destination['id']).toList();

      print(destinationIds);
      // Call the API for each destinationId
      for (int destinationId in destinationIds) {
        await _callAPIForDestination(destinationId);
        // delay for 4 seconds
        await Future.delayed(Duration(seconds: 4));
      }
    } else {
      // Handle error
      print('Failed to fetch destinations: ${response.statusCode}');
    }
  }

  // Function to call the API for a specific destinationId
  Future<void> _callAPIForDestination(int destinationId) async {
    final response = await http
        .get(Uri.parse('http://192.168.43.39:8001/location/$destinationId/'));

    if (response.statusCode == 200) {
      // Handle the response as needed
      // For example, update the map markers
      // You might want to add logic here based on your API response
    } else {
      // Handle error
      print(
          'Failed to fetch destination $destinationId: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: widget.locations.isNotEmpty
              ? widget.locations.first // Initial camera position
              : LatLng(0, 0), // Default if no locations provided
          zoom: 12.0, // Zoom level
        ),
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
        markers: widget.locations.map((location) {
          return Marker(
            markerId: MarkerId(location.toString()), // Unique marker ID
            position: location,
          );
        }).toSet(),
      ),
      // add another navigation button to navigate to another screen
      persistentFooterButtons: [
        FloatingActionButton(
          child: const Icon(Icons.navigation),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PassengersToGetOffList(),
            ),
          ),
        ),
        // navigate to MessageWidget
        FloatingActionButton(
          child: const Icon(Icons.message),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessagingWidget(),
            ),
          ),
        ),
      ],
    );
  }
}
