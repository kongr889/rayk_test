import 'menu_base.dart';
import 'item_geo_locator_demo.dart';

List<ItemDef> _menuDef = [
  ItemDef.withoutFunction('Simple Packages', ItemType.subTitle),
  ItemDef(
    'Geolocator demo (2)',
    ItemType.functional,
    (name) => MenuItemGeolocatorDemo(functionalTitle: name),
  ),
  ItemDef.withoutFunction('*** End ***', ItemType.subTitle),
];

class ItemExternalPackagesBasicMenu extends ItemMenuBase {
  ItemExternalPackagesBasicMenu({super.key, required super.functionalTitle})
    : super(menuDef: _menuDef);
}
