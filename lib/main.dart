import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:geolocator/geolocator.dart';
import 'menu_base.dart';
// only import related items involved in this menu
import 'item_external_packages_basic_menu.dart';

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
      home: const SaMenuPage(title: 'SA Menu (24)... by Raymond Kong'),
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
  ItemDef(
    'External Packages Basic Demos',
    ItemType.functional,
    (name) => ItemExternalPackagesBasicMenu(functionalTitle: name),
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

class _SaMenuPageState extends State<SaMenuPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return makeMenu(context, widget.title, _menuDef);
  }
}
