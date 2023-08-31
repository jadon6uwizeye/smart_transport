import 'dart:async';
import 'dart:developer';

import 'package:app/utils/locaition_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:location/location.dart';

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false, home: GoogleMapView()));
}

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  PolylinePoints polylinePoints = PolylinePoints();
  bool isStart = false;
  bool isPaused = false;
  bool isReset = true;
  bool isLoading = false;
  Set<Marker> markerSet = {};
  Map<PolylineId, Polyline> polylines = {}; //polylines to show direction

  getDirections({required LatLng start, required LatLng end}) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyDymNHCAZQfbNeM6WiPDNJMxcpNAYXmSmE",
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(end.latitude, end.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    addPolyLine(polylineCoordinates);
  }

  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.deepPurpleAccent,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  ///Current Location
  LatLng? currentLocation;
  LatLng? startLocation;
  LatLng? endLocation;

  ///Time Slots
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();

  Location location = Location();

  double totalDistance = 0.0;
  double totalTime = 0.0;

  @override
  void initState() {
    determinePosition().then((value) {
      currentLocation = LatLng(value.latitude!, value.longitude!);
      setState(() {});
    });

    listenLocation();
    super.initState();
  }

  listenLocation() async {
    try {
      await location.enableBackgroundMode(enable: true);
      location.onLocationChanged.listen((event) {
        log(("Changing Location in Real Time"));
        if (isStart == true) {
          endLocation = LatLng(event.latitude!, event.longitude!);
          if (startLocation != null) {
            calculateDistance(
                start: startLocation!,
                end: LatLng(event.latitude!, event.longitude!));
          }
          setState(() {});
        }
      });
    } catch (e) {
      log(e.toString());
      try {
        await location.enableBackgroundMode(enable: true);
        location.onLocationChanged.listen((event) {
          log(("Changing Location in Real Time"));
          if (isStart == true) {
            endLocation = LatLng(event.latitude!, event.longitude!);
            if (startLocation != null) {
              calculateDistance(
                  start: startLocation!,
                  end: LatLng(event.latitude!, event.longitude!));
            }
            setState(() {});
          }
        });
      } catch (e) {
        log(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoadingOverlay(
        isLoading: isLoading,
        progressIndicator: CircularProgressIndicator(),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Ticket Tracking"),
          ),
          body: currentLocation == null
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Stack(
                  children: [
                    GoogleMap(
                      polylines: Set<Polyline>.of(polylines.values),
                      mapType: MapType.normal,
                      markers: markerSet,
                      initialCameraPosition:
                          CameraPosition(target: currentLocation!, zoom: 14),
                      myLocationEnabled: true,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                    Positioned.fill(
                        bottom: 50,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 400,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isStart == true &&
                                    isPaused == false &&
                                    isReset == false)
                                  Text("Trip On Going",
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 20, 20, 20),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isStart == false)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FloatingActionButton.extended(
                                          label: const Text("Start"),
                                          onPressed: () {
                                            polylines.clear();
                                            markerSet.clear();
                                            isPaused = false;
                                            isStart = true;
                                            isReset = false;
                                            isLoading = true;
                                            startTime = DateTime.now();
                                            setState(() {});
                                            determinePosition().then((value) {
                                              startLocation = LatLng(
                                                  value.latitude!,
                                                  value.longitude!);
                                              markerSet.add(Marker(
                                                  markerId: MarkerId(value
                                                      .longitude
                                                      .toString()),
                                                  position: LatLng(
                                                      value.latitude!,
                                                      value.longitude!)));
                                              isLoading = false;
                                              setState(() {});
                                            });
                                          },
                                          icon:
                                              const Icon(Icons.directions_walk),
                                        ),
                                      ),
                                    if (isStart == true)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FloatingActionButton.extended(
                                          label: const Text("Stop"),
                                          onPressed: () {
                                            isLoading = true;
                                            isReset = false;
                                            isStart = false;
                                            endTime = DateTime.now();
                                            setState(() {});
                                            determinePosition()
                                                .then((value) async {
                                              endLocation = LatLng(
                                                  value.latitude!,
                                                  value.longitude!);
                                              markerSet.add(Marker(
                                                  markerId: MarkerId(value
                                                      .longitude
                                                      .toString()),
                                                  position: LatLng(
                                                      value.latitude!,
                                                      value.longitude!)));
                                              // getDirections(
                                              //     start: LatLng(
                                              //       value.latitude!,
                                              //       value.longitude!,
                                              //     ),
                                              //     end: LatLng(33.6907, 73.0057));

                                              calculateTime(
                                                  start: startTime,
                                                  end: endTime);
                                              isLoading = false;

                                              isPaused = true;
                                              setState(() {});

                                              // navigate to the next screen
                                            });
                                          },
                                          icon: const Icon(Icons.back_hand),
                                        ),
                                      ),
                                    if (isReset == false)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FloatingActionButton.extended(
                                          label: const Text("Reset"),
                                          onPressed: () {
                                            isPaused = false;
                                            isStart = false;
                                            isReset = true;
                                            polylines.clear();
                                            markerSet.clear();
                                            setState(() {});
                                          },
                                          icon: const Icon(Icons.restore),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
        ),
      ),
    );
  }

  calculateDistance({required LatLng start, required LatLng end}) {
    var _distanceInMeters = Geolocator.distanceBetween(
        start.latitude, start.longitude, end.latitude, end.longitude);
    totalDistance = _distanceInMeters / 1000;
    setState(() {});
  }

  calculateTime({required DateTime start, required DateTime end}) {
    var _totalTime = end.difference(start).inSeconds;

    totalTime = _totalTime.toDouble();
    setState(() {});
  }
}
