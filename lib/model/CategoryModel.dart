import 'package:hive/hive.dart';

part 'CategoryModel.g.dart';
// flutter pub run build_runner build

@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<TextModel> texts;

  CategoryModel({required this.name, required this.texts});
}

@HiveType(typeId: 1)
class TextModel extends HiveObject {
  @HiveField(0)
  String content;

  TextModel({required this.content});
}