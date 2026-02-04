import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:geolocator/geolocator.dart';
import 'menu_base.dart';

void main() {
  runApp(const SaMenuStatelessApp());
}

class SaMenuStatelessApp extends StatelessWidget {
  const SaMenuStatelessApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'SA Menu', // This is the application name on the mobile device system app list (not the Home Page icon name)
      // theme: appTheme,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const SaMenuPage(title: 'SA Menu (23)... by Raymond Kong'),
    );
  }
}

class SaMenuPage extends StatefulWidget {
  const SaMenuPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SaMenuPage> createState() => _SaMenuPageState();
}

List<ItemDef> _menuDef = [
  ItemDef.withoutFunction('External Packages basic tests', ItemType.subTitle),
  ItemDef(
    'Geolocator demo (2)',
    ItemType.functional,
    (name) => MenuItemGeolocatorDemo(functionalTitle: name),
  ),
  ItemDef.withoutFunction('*** End ***', ItemType.subTitle),
];

AppBar appBarForStdFunctional(BuildContext context, String functionalTitle) {
  return AppBar(
    title: Text(functionalTitle),
    // backgroundColor: Theme.of(context).colorScheme.surface,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context); // Goes back to the previous screen
      },
    ),
    // The 'actions' list appears on the right
    actions: [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () {
          developer.log("todo: need further work to go settings.");
        },
      ),
    ],
  );
}

/*
    Screen for GeolocatorDemo.... todo: need to make further change.
*/
class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);
}

class MenuItemGeolocatorDemo extends StatelessWidget {
  const MenuItemGeolocatorDemo({super.key, required this.functionalTitle});

  final String functionalTitle;

  /*   not working, but contains
  Future({Position? position, String? errorString}) getLocation() async {
    try {
      // Define LocationSettings
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy
            .low, // Use the accuracy enum within LocationSettings
        distanceFilter: 100, // Optional: specify a distance filter
      );

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
      developer.log('Info: (todo) current position is <$position>');
      return (position: position, errorString: null);
    } catch (e) {
      String errorString =
          'Error: (todo) unable to get current location. Exception: $e';
      developer.log(errorString);
      return (position: null, errorSting: errorString);
    }
  }
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

  @override
  Widget build(BuildContext context) {
    //    final (Position position?, String errorString?) = getLocation();
    const String charToRepeat = '1'; // todo: aaaaaaaaaaaaaaaa

    var pos = _determinePosition();
    developer.log('Info: (todo) current position is <$pos>');

    return Scaffold(
      appBar: appBarForStdFunctional(context, functionalTitle),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('todo 20260203 ${charToRepeat * 10}'),
            ),
          ],
        ),
        //        child: mainWidget,
      ),
    );
  }
}

class _SaMenuPageState extends State<SaMenuPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return makeMenu(context, widget.title, _menuDef);
  }
}
