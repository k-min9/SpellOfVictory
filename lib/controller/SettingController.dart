import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:spell_of_victory/model/SettingModel.dart';

class SettingController extends GetxController {
  late Box<SettingModel> _settingsBox;
  final FlutterTts _flutterTts = Get.find<FlutterTts>();


  @override
  void onInit() {
    super.onInit();
    _settingsBox = Hive.box<SettingModel>('settings');
    if (_settingsBox.isEmpty) {
      _settingsBox.add(SettingModel(
        isFirstVisit: true,
        isTutorialNeeded: true,
        ttsEngine: 'flutterTts',
        ttsLanguage: 'en-US',
        ttsVoiceType: 0,
        ttsVolume: 1,
        ttsPitch: 1,
        ttsRate: 1,
      ));
    }
  }

  // GetX에서 사용할 초기값 (main.dart와 동일)
  final settings = SettingModel(
    isFirstVisit: true,
    isTutorialNeeded: true,
    ttsEngine: 'default',
    ttsLanguage: 'en-US',
    ttsVoiceType: 0,
    ttsVolume: 0.5,
    ttsPitch: 1.0,
    ttsRate: 1.0,
  ).obs;

  void updateIsFirstVisit(bool value) {
    final updatedSettings = settings.value.copyWith(isFirstVisit: value);
    _settingsBox.put(0, updatedSettings);
    settings.value = updatedSettings;
  }

  void updateIsTutorialNeeded(bool value) {
    final updatedSettings = settings.value.copyWith(isTutorialNeeded: value);
    _settingsBox.put(0, updatedSettings);
    settings.value = updatedSettings;
  }

  void updateTtsSettings({
    String? engine,
    String? language,
    int? voiceType,
    double? volume,
    double? pitch,
    double? rate,
  }) {
    final updatedSettings = settings.value.copyWith(
      ttsEngine: engine ?? settings.value.ttsEngine,
      ttsLanguage: language ?? settings.value.ttsLanguage,
      ttsVoiceType: voiceType ?? settings.value.ttsVoiceType,
      ttsVolume: volume ?? settings.value.ttsVolume,
      ttsPitch: pitch ?? settings.value.ttsPitch,
      ttsRate: rate ?? settings.value.ttsRate,
    );
    _flutterTts.setLanguage(updatedSettings.ttsLanguage);
    _flutterTts.setVolume(updatedSettings.ttsVolume);
    _flutterTts.setPitch(updatedSettings.ttsPitch);
    _flutterTts.setSpeechRate(updatedSettings.ttsRate);
    _settingsBox.put(0, updatedSettings);
    settings.value = updatedSettings;
  }
}
