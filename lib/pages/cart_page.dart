import 'package:flutter/material.dart';

import '../main.dart';
import '../models/food_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final foods = MainInheritedWidget.of(context).foods;

    return Scaffold(
      appBar: AppBar(title: const Text("Sipariş Tepsisi")),
      body: ValueListenableBuilder<List<FoodItem>>(
          valueListenable: foods,
          builder: (_, v, __) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (v.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text("Tepsideki yemeklerin toplam tutarı: "),
                          const Spacer(),
                          Text(
                            "${v.map((e) => e.price).reduce((v, e) => (v ?? 0) + (e ?? 0))?.toStringAsFixed(2)}",
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: v.isEmpty
                        ? const Center(child: Text("Sipariş Tepsisi Boş"))
                        : ListView(
                            children: [
                              for (final item in v)
                                Card(
                                  child: ListTile(
                                    leading: Image.asset(
                                      item.image,
                                      fit: BoxFit.cover,
                                    ),
                                    title: Text(item.name),
                                    subtitle: Row(
                                      children: [
                                        const Text("Fiyat: "),
                                        const Spacer(),
                                        Text("${item.price ?? 0}"
                                            .replaceAll('.', ',')),
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
                                          v.add(item);
                                        }
                                        foods.value = [...v];
                                      },
                                      color: v.contains(item)
                                          ? Colors.green
                                          : Colors.grey,
                                      icon: const Icon(Icons.add_shopping_cart),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
