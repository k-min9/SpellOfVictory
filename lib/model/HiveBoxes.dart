import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:spell_of_victory/model/CategoryModel.dart';
import 'package:spell_of_victory/model/ChoiceModel.dart';
import 'package:spell_of_victory/model/SettingModel.dart';
import 'package:spell_of_victory/model/VoiceModel.dart';

class HiveBoxes {
  static late Box categories;
  static late Box choices;
  static late Box settings;
  static late Box voices;

  static Future<void> init() async {
    await Hive.initFlutter();

    // hive 초기화
    // await Hive.deleteFromDisk();

    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(CategoryTextModelAdapter());
    Hive.registerAdapter(ChoiceModelAdapter());
    Hive.registerAdapter(ChoiceTextModelAdapter());
    Hive.registerAdapter(SettingModelAdapter());
    Hive.registerAdapter(VoiceModelAdapter());
    categories = await Hive.openBox<CategoryModel>('categories');
    choices = await Hive.openBox<ChoiceModel>('choice');
    settings = await Hive.openBox<SettingModel>('settings');
    voices = await Hive.openBox<VoiceModel>('voice');
  }

  // hive test용 초기 데이터
  static Future<void> setInitData() async {
    // Voice : 음성
    VoiceModel voice11 = VoiceModel.defaultValues();
    voice11.voiceName = "보통_구글";
    voices.add(voice11);

    VoiceModel voice12 = VoiceModel.defaultValues();
    voice12.voiceName = "느긋하게_구글";
    voice12.ttsRate = 0.3;
    voices.add(voice12);

    VoiceModel voice13 = VoiceModel.defaultValues();
    voice13.voiceName = "빠르게_구글";
    voice13.ttsRate = 0.7;
    voices.add(voice13);

    VoiceModel voice14 = VoiceModel.defaultValues();
    voice14.voiceName = "보통_영어_구글";
    voice14.ttsLocale = "en";
    voice14.ttsLanguage = "en-US";
    voices.add(voice14);

    VoiceModel voice21 = VoiceModel.defaultValues();
    voice21.voiceName = "보통_삼성";
    voice21.ttsEngine = "com.samsung.SMT";
    voices.add(voice21);

    VoiceModel voice22 = VoiceModel.defaultValues();
    voice22.voiceName = "느긋하게_삼성";
    voice22.ttsEngine = "com.samsung.SMT";
    voice22.ttsRate = 0.3;
    voices.add(voice22);

    VoiceModel voice23 = VoiceModel.defaultValues();
    voice23.voiceName = "빠르게_삼성";
    voice23.ttsEngine = "com.samsung.SMT";
    voice23.ttsRate = 0.7;
    voices.add(voice23);

    VoiceModel voice24 = VoiceModel.defaultValues();
    voice24.voiceName = "보통_영어_삼성";
    voice23.ttsEngine = "com.samsung.SMT";
    voice24.ttsLocale = "en";
    voice24.ttsLanguage = "en-US";
    voices.add(voice24);

    // Choice : 주문
    late ChoiceModel newChoice;
    newChoice = ChoiceModel(name:'다짐', texts:[], isSelected: false);
    newChoice.texts.add(ChoiceTextModel(content: '나는 할 수 있다', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '내가 못 할 이유가 없다', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '여기서 해야 한다', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '조금 더 힘내자', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '나는 잘하고 있다', isChoiceSelected: false));
    choices.add(newChoice);

    newChoice = ChoiceModel(name:'용기', texts:[], isSelected: false);
    newChoice.texts.add(ChoiceTextModel(content: '안될게 뭐야', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '내가 못할게 뭐 있나', isChoiceSelected: false));
    choices.add(newChoice);

    newChoice = ChoiceModel(name:'응원', texts:[], isSelected: false);
    newChoice.texts.add(ChoiceTextModel(content: '힘내라', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '너는 최고야', isChoiceSelected: false));
    choices.add(newChoice);

    newChoice = ChoiceModel(name:'믿음', texts:[], isSelected: false);
    newChoice.texts.add(ChoiceTextModel(content: '역시 자네야', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '너 아니고 누가 하겠어', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '너라면 할 수 있어', isChoiceSelected: false));
    choices.add(newChoice);

    newChoice = ChoiceModel(name:'사랑', texts:[], isSelected: false);
    newChoice.texts.add(ChoiceTextModel(content: '사랑해', isChoiceSelected: false));
    choices.add(newChoice);

    newChoice = ChoiceModel(name:'기도', texts:[], isSelected: false);
    newChoice.texts.add(ChoiceTextModel(content: '주를 찬양하라', isChoiceSelected: false));
    choices.add(newChoice);

    newChoice = ChoiceModel(name:'칭찬', texts:[], isSelected: false);
    newChoice.texts.add(ChoiceTextModel(content: '잘했어', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '이대로만 가자', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '너라면 래낼 줄 알았어', isChoiceSelected: false));
    choices.add(newChoice);

    newChoice = ChoiceModel(name:'불경', texts:[], isSelected: false);
    newChoice.texts.add(ChoiceTextModel(content: '원아진생무별염 아미타불독상수 심심상계옥호광 염염불이금색상 아집염부법계관 '
        '허공위승무불관 평등사나무하처 관구서방아미타나무서방대교주 무량수 여래불 나무아미타불', isChoiceSelected: false));
    choices.add(newChoice);

    newChoice = ChoiceModel(name:'위로', texts:[], isSelected: false);
    newChoice.texts.add(ChoiceTextModel(content: '다음에는 더 잘할 수 있어', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '다시 해보자', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '다시 도전하는 패자만이 승자가 될 수 있다', isChoiceSelected: false));
    newChoice.texts.add(ChoiceTextModel(content: '기회는 어려움속에서 태어난다', isChoiceSelected: false));
    choices.add(newChoice);

    newChoice = ChoiceModel(name:'시작', texts:[], isSelected: false);
    newChoice.texts.add(ChoiceTextModel(content: '오늘도 좋은 하루가 될거야', isChoiceSelected: false));
    choices.add(newChoice);

    // Category : 주문서
    final group1 = CategoryModel(name:'응원의 주문', texts:[], isSelected: false);
    group1.texts.add(CategoryTextModel(content: '다시 해보자', isContentSelected: false, voiceName: 'NA', watingTime: 0));
    group1.texts.add(CategoryTextModel(content: '좋은 하루가 될거야', isContentSelected: false, voiceName: '보통_구글', watingTime: 0));
    group1.texts.add(CategoryTextModel(content: '힘내', isContentSelected: false, voiceName: '느긋하게_삼성', watingTime: 0));
    group1.texts.add(CategoryTextModel(content: '너를 사랑해', isContentSelected: false, voiceName: '빠르게_구글', watingTime: 0));
    group1.texts.add(CategoryTextModel(content: '이대로만 가자', isContentSelected: false, voiceName: '보통_삼성', watingTime: 0));
    group1.texts.add(CategoryTextModel(content: '너를 믿어', isContentSelected: false, voiceName: '잘못된입력', watingTime: 0));
    group1.texts.add(CategoryTextModel(content: '너가 자랑스러워', isContentSelected: false, voiceName: 'NA', watingTime: 0));
    categories.add(group1);

    final group2 = CategoryModel(name:'영어 한글 주문', texts:[], isSelected: false);
    group2.texts.add(CategoryTextModel(content: 'hello World', isContentSelected: false, voiceName: '보통_영어_삼성', watingTime: 0));
    group2.texts.add(CategoryTextModel(content: 'hello World', isContentSelected: false, voiceName: '보통_영어_구글', watingTime: 0));
    group2.texts.add(CategoryTextModel(content: 'Have a good day', isContentSelected: false, voiceName: '보통_영어_삼성', watingTime: 0));
    group2.texts.add(CategoryTextModel(content: 'Have a nice day', isContentSelected: false, voiceName: '보통_영어_구글', watingTime: 0.5));
    categories.add(group2);



  }
}