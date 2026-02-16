import 'menu_base.dart';
import 'item_pop_until_first.dart';
import 'item_geo_locator_demo.dart';
import 'item_path_provider_demo.dart';
import 'item_list_under_directory.dart';
import 'item_sqflite_demo.dart';

List<ItemDef> _menuDef = [
  ItemDef.withoutFunction('Simple Packages', ItemType.subTitle),
  ItemDef(
    'Geolocator demo',
    ItemType.functional,
    (name) => MenuItemGeolocatorDemo(functionalTitle: name),
  ),
  ItemDef(
    'Path Provider demo',
    ItemType.functional,
    (name) => MenuItemPathProviderDemo(functionalTitle: name),
  ),
  ItemDef(
    'Show directory content',
    ItemType.functional,
    (name) => MenuItemListUnderDirectory(functionalTitle: name),
  ),
  ItemDef(
    'Sqflite demo with items_database.db',
    ItemType.functional,
    (name) => MenuItemSqfliteDemo(functionalTitle: name),
  ),
  ItemDef(
    'Jump to top menu',
    ItemType.functional,
    (name) => MenuItemPopUntilFirst(functionalTitle: name),
  ),
  ItemDef.withoutFunction('*** End ***', ItemType.subTitle),
];

class ItemExternalPackagesBasicMenu extends ItemMenuBase {
  ItemExternalPackagesBasicMenu({super.key, required super.functionalTitle})
    : super(menuDef: _menuDef);
}
