import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:yaml/yaml.dart';

import './pages/main_menu_page.dart';
import 'models/food_item.dart';

// uygulamamanın birçok farklı yerinde ihtiyacım olacağı için yaml dosyamdaki veriyi global bir değişkende tuturyorum.
// verinin dışardan gelme veya çok büyük olma durumlarında local değişkenlerde parça parça tutmak daha iyi olacaktır.
late final YamlList yamlList;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // uygulamam açılır açılmaz öncelikle yaml dosyamı string olarak okuyorum.
  final yamlString = await rootBundle.loadString('assets/menu.yaml');
  // sonrasında dökümanın yapısına uygun olarak YamlMap şeklindeki halinden liste olarak tüm menüleri alıhyorum.
  final yamlDoc = loadYaml(yamlString);
  yamlList = yamlDoc['menus'];

  runApp(MainInheritedWidget(child: const MyApp()));
}

class MainInheritedWidget extends InheritedWidget {
  // Sipariş tepsisini burada inherited widget ile tutuyorum.
  // bir çok senaryo için bunu hive gibi hafif bir yapı ile
  // kalıcı olarak hafızada tutmak da iyi bir yaklaşım olabilir
  // inherited widget tüm alt ağacı yenilemesi yerine value notifier ile sadece
  // ihtiyaç duyduğum yeri yeniliyorum.
  // inherited widget kullanmamın tek amacı burada değişkeni tüm ağaçta ulaşılabilir yapmak
  // bunu da bu test senaryosunda global değişkende tutmak da hızlı bir çözüm olabilirdi.
  final foods = ValueNotifier(<FoodItem>[]);

  MainInheritedWidget({Key? key, required Widget child})
      : super(key: key, child: child);

  static MainInheritedWidget of(BuildContext context) {
    final MainInheritedWidget? result =
        context.dependOnInheritedWidgetOfExactType<MainInheritedWidget>();
    assert(result != null, 'No MainInheritedWidget found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant MainInheritedWidget oldWidget) => false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenuPage(),
    );
  }
}
