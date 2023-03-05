import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';
import 'package:spell_of_victory/model/ChoiceModel.dart';
import 'package:spell_of_victory/model/SettingModel.dart';

class HiveBoxes {
  static late Box categories;
  static late Box choices;
  static late Box settings;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(CategoryTextModelAdapter());
    Hive.registerAdapter(ChoiceModelAdapter());
    Hive.registerAdapter(ChoiceTextModelAdapter());
    Hive.registerAdapter(SettingModelAdapter());
    categories = await Hive.openBox<CategoryModel>('categories');
    choices = await Hive.openBox<ChoiceModel>('choice');
    settings = await Hive.openBox<SettingModel>('settings');

    // // hive 테스트용 (Category)
    // final group1 = CategoryModel(name:'group1', texts:[CategoryTextModel(content: '선택', isContentSelected: false)], isSelected: false);
    // group1.texts.add(CategoryTextModel(content: '좋은 하루가 될거야', isContentSelected: false));
    // final group2 = CategoryModel(name:'group2', texts:[], isSelected: false);
    // group2.texts.add(CategoryTextModel(content: 'hello World', isContentSelected: false));
    // categories.add(group1);
    // categories.add(group2);
    //
    // // hive 테스트용 (Choice)
    // final choiceGroup1 = ChoiceModel(name:'용기', texts:[ChoiceTextModel(content: '너는 잘하고 있어', isChoiceSelected: false)], isSelected: false);
    // choiceGroup1.texts.add(ChoiceTextModel(content: '훌륭한 선택이야', isChoiceSelected: false));
    // final choiceGroup2 = ChoiceModel(name:'사랑', texts:[], isSelected: false);
    // choiceGroup2.texts.add(ChoiceTextModel(content: 'hello World', isChoiceSelected: false));
    // choices.add(choiceGroup1);
    // choices.add(choiceGroup2);

  }
}