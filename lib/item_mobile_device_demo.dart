import 'package:flutter/material.dart';
import 'menu_base.dart';

/*
  This file contain everything about the menu item of "MenuItemMobileDeviceDemo" screen
*/
class MenuItemMobileDeviceDemo extends StatelessWidget {
  const MenuItemMobileDeviceDemo({super.key, required this.functionalTitle});

  final String functionalTitle;

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: appBarForStdFunctional(context, functionalTitle),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text('''
device height: $deviceHeight
device width: $deviceWidth
device orientation ${MediaQuery.of(context).orientation.toString()}'''),
            ),
          ],
        ),
      ),
    );
  }
}
