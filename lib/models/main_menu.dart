import 'package:yaml/yaml.dart';

import 'main_sub_menu.dart';

class MainMenu {
  late String key;
  late String description;
  late List<MainSubMenu> items;

  MainMenu.fromYaml(YamlMap yaml) {
    key = yaml['key'];
    description = yaml['description'];
    items = (yaml['items'] as List)
        .map((e) => MainSubMenu.fromYaml(e))
        .toList()
        .cast<MainSubMenu>();
  }
}
