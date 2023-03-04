import 'package:hive/hive.dart';

part 'ChoiceModel.g.dart';
// flutter pub run build_runner build

@HiveType(typeId: 1)
class ChoiceModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<ChoiceTextModel> texts;

  @HiveField(2)
  bool isSelected = false;

  ChoiceModel({required this.name, required this.texts, required this.isSelected});
}

@HiveType(typeId: 3)
class ChoiceTextModel extends HiveObject {
  @HiveField(0)
  String content;

  @HiveField(1)
  bool isChoiceSelected = false;

  ChoiceTextModel({required this.content, required this.isChoiceSelected});
}