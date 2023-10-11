import 'package:flutter/services.dart';
import 'package:location/location.dart';

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<LocationData> determinePosition() async {
  Location location = new Location();

  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;

  try {
    _serviceEnabled = await location.serviceEnabled();
  } on PlatformException catch (err) {
    print("Platform exception calling serviceEnabled(): $err");
    _serviceEnabled = false;

    // location service is still not created

    determinePosition();
  }
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return Future.error("error");
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return Future.error("error");
    }
  }

  _locationData = await location.getLocation();
  return _locationData;
}
