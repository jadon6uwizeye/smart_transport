import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PassengersToGetOffList extends StatefulWidget {
  PassengersToGetOffList();

  @override
  State<PassengersToGetOffList> createState() => _PassengersToGetOffListState();
}

class _PassengersToGetOffListState extends State<PassengersToGetOffList> {
  var locations;
  // List of location names
  var passengers;

  void _fetch_locations() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);
    final response = await http.get(
      Uri.parse('http://localhost:8001/location/get_tickets/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        // pass token from local storage
        'Authorization': 'Bearer $token',
      },
    );

    var json_response = json.decode(response.body);

    if (response.statusCode == 200) {
      print("here");
      setState(() {
        locations = json_response;
      });
      print("check");
    } else {
      print('Failed to load locations');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch locations and passengers from API
    _fetch_locations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 241, 243),
      appBar: AppBar(
        title: Text('Passengers to Get Off'),
        backgroundColor: Color.fromARGB(255, 3, 10, 20),
        // change the app bar height
        toolbarHeight: 70,
      ),
      body: locations != null
          // && passengers != null
          ? ListView.builder(
              itemCount: locations.length,
              itemBuilder: (context, index) {
                final location = locations.keys.toList()[index];
                final passengerList = locations[location];

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: ListTile(
                    title: Text(
                      location,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: passengerList.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: passengerList
                                .map<Widget>((passenger) =>
                                    Text("  ${passenger['name']}"))
                                .toList(),
                          )
                        : Text("No passengers to get off."),
                  ),
                );
              },
            )
          : Center(
              child: Text("No passengers to get off."),
            ),
    );
  }
}
