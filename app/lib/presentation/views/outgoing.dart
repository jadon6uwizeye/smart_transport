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
  int totalPassengers = 0;
  int passengersWithStatusC = 0;
  int passengersWithOtherStatus = 0;

  void _fetch_locations() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    print(token);
    final response = await http.get(
      Uri.parse('http://192.168.43.39:8001/location/get_tickets/'),
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
        locations.forEach((destination, passengers) {
          passengers.forEach((passenger) {
            totalPassengers++;
            if (passenger['status'] == 'C') {
              passengersWithStatusC++;
            } else {
              passengersWithOtherStatus++;
            }
          });
        });
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
      body: Column(
        children: [
          locations != null
              // && passengers != null
              ? Expanded(
                  child: ListView.builder(
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
                      final location = locations.keys.toList()[index];
                      final passengerList = locations[location];

                      return Card(
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                                      .map<Widget>((passenger) => RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      " ${passenger['name']}      - ",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors
                                                        .black, // Always black for 'name'
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      passenger['status'] == 'C'
                                                          ? ' ✅  Arrived'
                                                          : '',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                    color: passenger[
                                                                'status'] ==
                                                            'C'
                                                        ? Colors.green
                                                        : Colors
                                                            .black, // Black for 'arrived' part
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ))
                                      .toList()

                                  // Display passenger name and if status is C display "Confirmed" else display "Not Confirmed"
                                  // .map<Widget>((passenger) => Text(
                                  //     "  ${passenger['name']} - ${passenger['status'] == 'C' ? 'Confirmed' : 'Not Confirmed'}"))
                                  // .toList(),
                                  )
                              : Text("No passengers to get off."),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text("No passengers to get off."),
                ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 18),
                children: <TextSpan>[
                  TextSpan(
                    text: "Total Passengers : ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "$totalPassengers\n",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: "Passengers who have arrived : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "$passengersWithStatusC\n",
                    style: TextStyle(color: Colors.green),
                  ),
                  TextSpan(
                    text: "Passengers Still Going : ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "$passengersWithOtherStatus",
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
