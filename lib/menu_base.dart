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
        // Your action here
      },
      child: Text('$aItem.name'),
    );
    items.add(aButton);
  }
  developer.log('item count in items is <${items.length}>');

  Widget mainWidget = Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: items),
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
    body: Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: mainWidget,
      /* Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        //
        // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
        // action in the IDE, or press "p" in the console), to see the
        // wireframe for each widget.
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('You have pushed the button this many times:'),
          Text('< todo >', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ), */
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
