import 'package:app/presentation/outgoing.dart';
import 'package:app/presentation/views/locationDisplay.dart';
import 'package:app/presentation/views/locations.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// void main() {
//   runApp(MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // change main color
//       theme: ThemeData(
//         primaryColor: Color.fromARGB(255, 4, 37, 99),
//       ),
//       home: LocationMap(
//         locations: [
//           LatLng(-1.953909, 30.096267), // Example location 1
//           LatLng(-1.959611, 30.109054), // Example location 2
//         ],
//       )));
// }

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Location and Passengers Display'),
          backgroundColor: Color.fromARGB(255, 3, 10, 20),
          // change the app bar height
          toolbarHeight: 70,
        ),
        // body: Center(
        //   child: LocationDisplay(
        //     locations: [
        //       LocationInfo(
        //         location: LatLng(-1.951344, 30.089222),
        //         name: 'Kagugu',
        //         passengers: ['UWIZEYE Jean de Die', 'Kamali Jean'],
        //       ),
        //       LocationInfo(
        //         location: LatLng(-1.952092, 30.096263),
        //         name: 'Kinamba',
        //         passengers: ['King Ngabo', 'Kamali Jean'],
        //       ),
        //       LocationInfo(
        //         location: LatLng(-1.953092, 30.090263),
        //         name: 'Kinamba',
        //         passengers: ['King Ngabo', 'Kamali Jean'],
        //       ),
        //       LocationInfo(
        //         location: LatLng(-1.953002, 30.096263),
        //         name: 'Kinamba',
        //         passengers: ['King Ngabo', 'Kamali Jean'],
        //       )
        //       // Add more locations as needed
        //     ],
        //   ),
        // ),

        body: PassengersToGetOffList(
          locations: [
            "Kagugu",
            "Kinamba",
            "Kacyiru",
            "Kanombe",
            "Kimironko",
          ],
          passengers: {
            "Kagugu": [
              "UWIZEYE Jean de Dieu",
              "Kamali Jean",
              "King Ngabo",
              "John Doe",
              "Jane Doe",
              "John",
              "Jane",
              "Rwibutso"
            ],
            "Kinamba": [
              "King Ngabo",
              "James K",
              "King Ngabo",
              "Rwibutso Jean",
              "King Ngabo",
              "Yves Jean",
              "King Ngabo",
              "Kamali Jean",
              "Kim Ngabo",
              "Kamali Jean",
              "King Ngabo",
              "Kamali Jean",
              "King Ngabo",
              "Kanam Jean",
              "King Ngabo",
              "Kamali Jean",
              "XYZ Ngabo",
              "Name Jean",
              "King Name",
              "Kamali Names",
            ],
            "Kacyiru": ["King Ngabo", "Kamali Jean"],
            "Kanombe": ["King Ngabo", "Kamali Jean"],
            "Kimironko": ["King Ngabo", "Kamali Jean"],
          },
        ),
      ),
    );
  }
}
