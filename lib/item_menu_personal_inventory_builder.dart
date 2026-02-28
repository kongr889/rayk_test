import 'menu_base.dart';
import 'item_pop_until_first.dart';
import 'item_geo_locator_demo.dart';

List<ItemDef> _menuDef = [
  ItemDef.withoutFunction('Simple Packages', ItemType.subTitle),
  ItemDef(
    'Geolocator demo',
    ItemType.functional,
    (name) => MenuItemGeolocatorDemo(functionalTitle: name),
  ),
  ItemDef(
    'Jump to top menu',
    ItemType.functional,
    (name) => MenuItemPopUntilFirst(functionalTitle: name),
  ),
  ItemDef.withoutFunction('*** End ***', ItemType.subTitle),
];

class ItemPersonalInventoryBuilderMenu extends ItemMenuBase {
  ItemPersonalInventoryBuilderMenu({super.key, required super.functionalTitle})
    : super(menuDef: _menuDef);
}
