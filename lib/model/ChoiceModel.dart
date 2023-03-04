import 'package:hive/hive.dart';

part 'ChoiceModel.g.dart';
// flutter pub run build_runner build

@HiveType(typeId: 1)
class ChoiceModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  List<String> texts;

  ChoiceModel({required this.name, required this.texts});
}