import 'package:flutter/material.dart';
import 'dart:developer' as developer;

enum ItemType { subTitle, functional }

class ItemDef {
  final String name;
  final ItemType type;
  final Widget Function(String name)? widgetBuilder;

  // The primary, unnamed constructor
  ItemDef(this.name, this.type, this.widgetBuilder);

  // A named constructor for items that don't correspond to another functional screen/ widget.
  ItemDef.withoutFunction(this.name, this.type) : widgetBuilder = null;
}

ThemeData appTheme = ThemeData(
  // This is the default theme used by all screens in this application
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
);

Scaffold makeMenu(BuildContext context, String title, List<ItemDef> menuDef) {
  List<Widget> items = [];

  for (var aItem in menuDef) {
    Widget aWidget; // this will hold either the Botton widget or Text widget.

    if (aItem.type == ItemType.functional) {
      aWidget = ElevatedButton(
        onPressed: () {
          final Widget widgetToPush = aItem.widgetBuilder!(aItem.name);
          developer.log('switching to a new functional screen for <${aItem.name}>');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => widgetToPush),
          );
        },
        child: Text(aItem.name),
      );
    } else {
      aWidget = Text(
        aItem.name,
        style: TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );
    }
    items.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: aWidget,
      ),
    );
  }
  developer.log('item count in items is <${items.length}>');

  Widget mainWidget = Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: items,
    ),
  );

  return Scaffold(
    appBar: AppBar(
      // Here we take the value from the SaMenuPage object that was created by
      // the App.build method, and use it to set our appbar title.
      title: Text(title),
    ),
    body: Container(
      margin: EdgeInsets.all(20),
      child: mainWidget,
      ),
  );
}

abstract class ItemMenuBase extends StatelessWidget {

  const ItemMenuBase({
    super.key,
    required this.functionalTitle,
    required this.menuDef
  });

  final String functionalTitle;
  final List<ItemDef> menuDef;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called
    return makeMenu(context, functionalTitle, menuDef);
  }
}

class MenuBase {
  final String title;
  final List<ItemDef> _items = []; // A growable list of items.

  MenuBase({required this.title});

  void setSubTitle(String subTitle) {
    _items.add(ItemDef.withoutFunction(subTitle, ItemType.subTitle));
    developer.log('SubTitle: $subTitle', name: 'com.example.myapp.MenuBase');
  }

  // Method to add a new item to the list
  void addItem(String itemName, Widget Function(String name) widgetBuilder) {
    final newItem = ItemDef(itemName, ItemType.functional, widgetBuilder);
    _items.add(newItem);
    developer.log(
      'Added item: ${newItem.name} of type ${newItem.type}',
      name: 'com.example.myapp.MenuBase',
    );
  }
}
