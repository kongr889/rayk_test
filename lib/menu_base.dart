import 'package:flutter/material.dart';
import 'dart:developer' as developer;

enum ItemType { subTitle, function }

class ItemDef {
  final String name;
  final ItemType type;
  final Function? func;

  // The primary, unnamed constructor
  ItemDef(this.name, this.type, this.func);

  // A named constructor for items that don't have a function
  ItemDef.withoutFunction(this.name, this.type) : func = null;
}

Scaffold makeMenu(BuildContext context, String title, List<ItemDef> menuDef) {
  List<Widget> items = [];

  for (var aItem in menuDef) {
    Widget aButton = ElevatedButton(
      onPressed: () {
        // todo: need to add more logic to complete the work.
/*
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailScreen()),
        );
*/
      },
      child: Text(aItem.name),
    );
    Widget aSubTitle = Text(
      aItem.name,
      style: TextStyle(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
    items.add(
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: (aItem.type == ItemType.subTitle) ? aSubTitle : aButton,
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
      // TRY THIS: Try changing the color here to a specific color (to
      // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
      // change color while the other colors stay the same.
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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

class MenuBase {
  final String title;
  final List<ItemDef> _items = []; // A growable list of items.

  MenuBase({required this.title});

  void setSubTitle(String subTitle) {
    _items.add(ItemDef.withoutFunction(subTitle, ItemType.subTitle));
    developer.log('SubTitle: $subTitle', name: 'com.example.myapp.MenuBase');
  }

  // Method to add a new item to the list
  void addItem(String itemName, Function func) {
    final newItem = ItemDef(itemName, ItemType.function, func);
    _items.add(newItem);
    developer.log(
      'Added item: ${newItem.name} of type ${newItem.type}',
      name: 'com.example.myapp.MenuBase',
    );
  }
}
