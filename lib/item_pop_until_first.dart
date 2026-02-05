import 'package:flutter/material.dart';
// import 'menu_base.dart';

class MenuItemPopUntilFirst extends StatelessWidget {
  const MenuItemPopUntilFirst({super.key, required this.functionalTitle});

  final String functionalTitle;

  @override
  Widget build(BuildContext context) {
    Navigator.popUntil(context, (route) => route.isFirst);
    return const Scaffold();
  }
}
