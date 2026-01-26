import 'dart:developer' as developer;
import 'package:flutter/material.dart';

enum ItemType {
  subTitle,
  function,
  }

class ItemClass {
  final String name;
  final ItemType type;

  ItemClass(this.type, this.name);
}

class MenuBase {
  final String title;
  final List<ItemClass> _items = []; // A growable list of items.

  MenuBase({
    required this.title,
  });

  void setSubTitle(String subTitle) {
    _items.add(ItemClass(ItemType.subTitle, subTitle));
    developer.log('SubTitle: $subTitle', name: 'com.example.myapp.MenuBase'); 
    print('SubTitle: $subTitle');
  }

  // Method to add a new item to the list
  void addItem(String itemName, ItemType itemType) {
    final newItem = ItemClass(itemType, itemName);
    _items.add(newItem);
    developer.log('Added item: ${newItem.name} of type ${newItem.type}', name: 'com.example.myapp.MenuBase');
    print('Added item: ${newItem.name} of type ${newItem.type}');
  }
}
