import 'package:flutter/material.dart';
import 'menu_base.dart';
import 'dart:developer' as developer;
import 'package:geolocator/geolocator.dart';

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
      home: const SaMenuPage(title: 'SA Menu (22)... by Raymond Kong'),
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
  ItemDef('Geolocator demo (2)', ItemType.functional, (name) => MenuItemGeolocatorDemo(functionalTitle: name),),
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
class MenuItemGeolocatorDemo extends StatelessWidget {
  const MenuItemGeolocatorDemo({super.key, required this.functionalTitle});

  final String functionalTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarForStdFunctional(context, functionalTitle),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('todo 1111111111'),
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
