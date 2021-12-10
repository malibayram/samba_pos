import 'package:flutter/material.dart';

import '../main.dart';
import '../models/food_item.dart';
import './cart_page.dart';

class FoodListPage extends StatelessWidget {
  final String caption;
  final List<FoodItem> foodList;
  const FoodListPage({
    Key? key,
    required this.caption,
    required this.foodList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final foods = MainInheritedWidget.of(context).foods;

    return Scaffold(
      appBar: AppBar(
        title: Text(caption),
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
        child: ListView(
          children: [
            for (final item in foodList)
              Card(
                child: ValueListenableBuilder<List<FoodItem>>(
                  valueListenable: foods,
                  builder: (_, v, __) {
                    return ListTile(
                      leading: Image.asset(
                        item.image,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.name),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              const Text("Fiyat: "),
                              const Spacer(),
                              Text("${item.price ?? 0}".replaceAll('.', ',')),
                            ],
                          ),
                          // ana yemeği seçmeden alt menü yemeklerini seçemeyeceği için
                          // ana yemek seçili olduğunda ve alt menu listesi boş olmadığında
                          // alt menüye yönlenebileceği butonu gösteriyorum.
                          if (v.contains(item) && item.subMenus.isNotEmpty)
                            InkWell(
                              onTap: () => item.onPressed(context),
                              child: const Text(
                                "Seçtiğin menüye çok uygun fiyatlarla ekleyebileceğin ek yemeklerden birini seçmek için buraya tıklayarak listeye ulaşabilirsin",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          if (v.contains(item)) {
                            v.remove(item);
                            // ana bir yemek sipariş listesinden çıkarıldığı zaman onun tüm alt menü
                            // yemeklerini de listeden çıkarıyorum.
                            for (final subItem in item.subMenus) {
                              v.remove(subItem);
                            }
                          } else {
                            // sadece 1 alt yemek seçme işlemini burada garanti edebiliriz.
                            // birden fazla alt yemek seçebilmesini istersek alttaki if bloğunu kaldırabiliriz.
                            if (caption == "Alt Menü Yemekleri") {
                              v.removeWhere((e) => foodList.contains(e));
                            }
                            v.add(item);
                          }
                          foods.value = [...v];
                        },
                        color: v.contains(item) ? Colors.green : Colors.grey,
                        icon: const Icon(Icons.add_shopping_cart),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
