import 'package:flutter/material.dart';
import 'package:samba_pos/pages/food_list_page.dart';
import 'package:yaml/yaml.dart';

import '../main.dart';

class FoodItem {
  late String name;
  double? price;
  late String image;
  final List<FoodItem> subMenus = [];

  FoodItem.fromYaml(YamlMap yaml) {
    name = yaml['name'] ?? "";
    image = "assets/" + yaml['image'];

    if (yaml['price'] != null) {
      price = double.parse(yaml['price'] is int
          ? "${yaml['price']}"
          : yaml['price'].replaceAll(',', '.'));
    }

    if (yaml['subMenus'] != null) {
      subMenus.clear();
      for (String subKey in (yaml['subMenus'] as YamlList).toList()) {
        final yamlMap = yamlList
            .toList()
            .firstWhere((e) => (e as YamlMap).containsValue(subKey));

        subMenus.addAll(
            (yamlMap['items'] as List).map((e) => FoodItem.fromYaml(e)));
      }
    }
  }

  // burada recursive yapı kullanarak alt listeyi teorik olarak sonsuza kadar uzatma imkanı oluşturuyorum.
  // alt menü dallanmanın sayısının belli olmadığı durumlarda recursive yapı kullanmak dışındaki hiçbir çözüm sağlıklı değil
  // sayının belli olduğu durumlarda recursive kullanmadan her dal için yeni bir sayfa oluşturulabilir ya da yine tek bir sayfa
  // recursive sayesinde yapı oluşturulabilir.
  void onPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FoodListPage(caption: "Alt Menü Yemekleri", foodList: subMenus),
      ),
    );
  }
}
