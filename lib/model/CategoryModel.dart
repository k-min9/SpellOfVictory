import 'package:hive/hive.dart';

part 'CategoryModel.g.dart';
// flutter pub run build_runner build

@HiveType(typeId: 0)
class CategoryModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<CategoryTextModel> texts;

  @HiveField(2)
  bool isSelected;

  CategoryModel({required this.name, required this.texts, required this.isSelected});
}

@HiveType(typeId: 2)
class CategoryTextModel extends HiveObject {
  @HiveField(0)
  String content;

  @HiveField(1)
  bool isContentSelected;

  CategoryTextModel({required this.content, required this.isContentSelected});
}