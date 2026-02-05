import 'package:flutter/material.dart';
// import 'dart:developer' as developer;
import 'package:geolocator/geolocator.dart';
import 'menu_base.dart';

/*
  This file contain everything about the menu item of "MenuItemGeolocatorDemo" screen
*/
// Determine the current position of the device.
Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

class MenuItemGeolocatorDemo extends StatelessWidget {
  const MenuItemGeolocatorDemo({super.key, required this.functionalTitle});

  final String functionalTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarForStdFunctional(context, functionalTitle),
      body: Container(
        margin: EdgeInsets.all(20),
        child: FutureBuilder<Position>(
          future: _determinePosition(),
          builder: (context, snapshot) {
            // 3. Handle the "Loading" state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            // 4. Hanbdle errors
            else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('''
snapshot classname is <${snapshot.data.runtimeType.toString()}>
latitude: ${(snapshot.data as Position).latitude}
longitude: ${(snapshot.data as Position).longitude}'''),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
