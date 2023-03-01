import 'package:hive/hive.dart';

part 'Category.g.dart';
// flutter pub run build_runner build

@HiveType(typeId: 0)
class Category extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<Text> texts;

  Category({required this.name, required this.texts});
}

@HiveType(typeId: 1)
class Text extends HiveObject {
  @HiveField(0)
  String content;

  Text({required this.content});
}