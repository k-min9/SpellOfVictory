import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';
import 'package:spell_of_victory/model/ChoiceModel.dart';

class HiveBoxes {
  static late Box categories;
  static late Box choices;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(CategoryTextModelAdapter());
    Hive.registerAdapter(ChoiceModelAdapter());
    categories = await Hive.openBox('categories');
    choices = await Hive.openBox('choices');

    // hive 테스트용 (Category)
    final group1 = CategoryModel(name:'group1', texts:[CategoryTextModel(content: '선택', isContentSelected: false)], isSelected: false);
    group1.texts.add(CategoryTextModel(content: '좋은 하루가 될거야', isContentSelected: false));
    final group2 = CategoryModel(name:'group2', texts:[], isSelected: false);
    group2.texts.add(CategoryTextModel(content: 'hello World', isContentSelected: false));
    categories.add(group1);
    categories.add(group2);

    // hive 테스트용 (Choice)
    final choiceGroup1 = ChoiceModel(name:'용기', texts:['훌륭해', '멋져', '대단해']);
    final choiceGroup2 = ChoiceModel(name:'사랑', texts:['사랑해', '내가 보고 있어']);

    choices.add(group1);
    choices.add(group2);

  }
}