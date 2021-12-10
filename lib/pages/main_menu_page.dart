import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';

import './cart_page.dart';
import '../main.dart';
import '../models/main_menu.dart';

class MainMenuPage extends StatelessWidget {
  MainMenuPage({Key? key}) : super(key: key);

  // main dosyasında
  final mainMenu = MainMenu.fromYaml(yamlList
      .toList()
      .firstWhere((e) => (e as YamlMap).containsValue('main')));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mainMenu.description),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (c) => const CartPage()),
              );
            },
            icon: const Icon(Icons.shopping_bag),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          children: [
            for (final mainSubMenu in mainMenu.items)
              Card(
                clipBehavior: Clip.antiAlias,
                child: MaterialButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => mainSubMenu.onPressed(context),
                  child: Column(
                    children: [
                      Expanded(
                        child: Image.asset(
                          mainSubMenu.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          mainSubMenu.caption,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
