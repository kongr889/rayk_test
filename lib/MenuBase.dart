import 'package:flutter/material.dart';

class ItemClass {

}

class MenuBase {
  final String title;

  const MenuBase({
    required this.title,
  });

  void setSubTitle(String subTitle) {
    print('SubTitle: $subTitle');
  }
}
