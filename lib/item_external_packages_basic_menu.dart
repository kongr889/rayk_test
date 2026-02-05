// import 'package:flutter/material.dart';
// import 'dart:developer' as developer;
import 'menu_base.dart';

List<ItemDef> _menuDef = [
  ItemDef.withoutFunction('something something', ItemType.subTitle),
  ItemDef.withoutFunction('*** End ***', ItemType.subTitle),
];

class ItemExternalPackagesBasicMenu extends ItemMenuBase {
  ItemExternalPackagesBasicMenu({super.key, required super.functionalTitle})
    : super(menuDef: _menuDef);
}
