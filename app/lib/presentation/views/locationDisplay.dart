import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInfo {
  final LatLng location;
  final String name;
  final List<String> passengers;

  LocationInfo({
    required this.location,
    required this.name,
    required this.passengers,
  });
}

class LocationDisplay extends StatelessWidget {
  final List<LocationInfo> locations;

  LocationDisplay({required this.locations});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: locations.isNotEmpty
                  ? locations.first.location
                  : LatLng(0, 0),
              zoom: 12.0,
            ),
            markers: locations.map((info) {
              return Marker(
                markerId: MarkerId(info.location.toString()),
                position: info.location,
                // Customize markers here if needed
              );
            }).toSet(),
          ),
        ),
        Expanded(
          flex: 3,
          child: ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final locationInfo = locations[index];
              return ListTile(
                title: Text(locationInfo.name),
                subtitle: Text(
                    'Passengers to Get Off: ${locationInfo.passengers.join(", ")}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
