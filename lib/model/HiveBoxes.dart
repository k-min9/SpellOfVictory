import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spell_of_victory/model/Category.dart';

class HiveBoxes {
  static late Box categories;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryAdapter());
    Hive.registerAdapter(TextAdapter());
    categories = await Hive.openBox('categories');
  }
}