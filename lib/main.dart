import 'package:flutter/material.dart';
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
  ItemDef.withoutFunction('Top Level Menu', ItemType.subTitle),
  ItemDef(
    'External Packages Basic Demos',
    ItemType.functional,
    (name) => ItemExternalPackagesBasicMenu(functionalTitle: name),
  ),
  ItemDef.withoutFunction('*** End ***', ItemType.subTitle),
];

class _SaMenuPageState extends State<SaMenuPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return makeMenu(context, widget.title, _menuDef);
  }
}
