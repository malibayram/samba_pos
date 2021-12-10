import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

import './food_item.dart';
import '../pages/food_list_page.dart';

class MainSubMenu {
  late String caption;
  late String image;
  late List<FoodItem> items;

  MainSubMenu.fromYaml(YamlMap yaml) {
    caption = yaml['caption'];
    image = "assets/" + yaml['image'];
    items = (yaml['items'] as List)
        .map((e) => FoodItem.fromYaml(e))
        .toList()
        .cast<FoodItem>();
  }

  void onPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FoodListPage(
          foodList: items,
          caption: caption,
        ),
      ),
    );
  }
}
