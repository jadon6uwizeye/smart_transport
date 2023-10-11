import 'package:app/presentation/views/login.dart';
import 'package:app/presentation/views/outgoing.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 4, 37, 99),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Color.fromARGB(255, 4, 37, 99),
        ),
        focusColor: Color.fromARGB(255, 4, 37, 99),
      ),
      home: SplashScreen(),
      // Scaffold(
      //   appBar: AppBar(
      //     title: Text('Ticket Tracking app'),
      //     backgroundColor: Color.fromARGB(255, 3, 10, 20),
      //     // change the app bar height
      //     toolbarHeight: 70,
      //   ),
      //   // body: Center(
      //   //   child: LocationDisplay(
      //   //     locations: [
      //   //       LocationInfo(
      //   //         location: LatLng(-1.951344, 30.089222),
      //   //         name: 'Kagugu',
      //   //         passengers: ['UWIZEYE Jean de Die', 'Kamali Jean'],
      //   //       ),
      //   //       LocationInfo(
      //   //         location: LatLng(-1.952092, 30.096263),
      //   //         name: 'Kinamba',
      //   //         passengers: ['King Ngabo', 'Kamali Jean'],
      //   //       ),
      //   //       LocationInfo(
      //   //         location: LatLng(-1.953092, 30.090263),
      //   //         name: 'Kinamba',
      //   //         passengers: ['King Ngabo', 'Kamali Jean'],
      //   //       ),
      //   //       LocationInfo(
      //   //         location: LatLng(-1.953002, 30.096263),
      //   //         name: 'Kinamba',
      //   //         passengers: ['King Ngabo', 'Kamali Jean'],
      //   //       )
      //   //       // Add more locations as needed
      //   //     ],
      //   //   ),
      //   // ),

      //   body: LoginScreen(),
      // ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate some initialization work (e.g., fetching data, loading resources)
    Future.delayed(Duration(seconds: 3), () {
      // Navigate to the main screen or the desired screen after the splash screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(
          255, 4, 37, 99), // Background color of the splash screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Ticket Tracking App', // Replace with your app's name
              style: TextStyle(
                fontSize: 32,
                color: Colors.white, // Text color
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white), // Loading indicator color
            ),
          ],
        ),
      ),
    );
  }
}
