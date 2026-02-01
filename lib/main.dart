import 'package:flutter/material.dart';
import 'menu_base.dart';
// import 'dart:developer' as developer;

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
      theme: ThemeData(
        /* This is the theme of your application.
           TRY THIS: Try running your application with "flutter run". You'll see
           the application has a purple toolbar. Then, without quitting the app,
           try changing the seedColor in the colorScheme below to Colors.green
           and then invoke "hot reload" (save your changes or press the "hot
           reload" button in a Flutter-supported IDE, or press "r" if you used
           the command line to start the app).
        */
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SaMenuPage(title: 'SA Menu (21)... by Raymond Kong'),
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
  ItemDef('Geolocator demo (2)', ItemType.functional, (name) => MenuItemGeolocatorDemo(title: name),),
  ItemDef.withoutFunction('*** End ***', ItemType.subTitle),
];

/*
    Screen for GeolocationDemo.... todo: need to make further change.
*/
class MenuItemGeolocatorDemo extends StatelessWidget {
  const MenuItemGeolocatorDemo({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:
          'SA Menu - $title', // This is the application name on the mobile device system app list (not the Home Page icon name)
      theme: ThemeData(
        /* This is the theme of your application.
           TRY THIS: Try running your application with "flutter run". You'll see
           the application has a purple toolbar. Then, without quitting the app,
           try changing the seedColor in the colorScheme below to Colors.green
           and then invoke "hot reload" (save your changes or press the "hot
           reload" button in a Flutter-supported IDE, or press "r" if you used
           the command line to start the app).
        */
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SaMenuPage(title: 'SA Menu (xx)... by Raymond Kong'),
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
