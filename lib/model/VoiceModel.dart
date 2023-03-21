import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'VoiceModel.g.dart';
// flutter pub run build_runner build

@HiveType(typeId: 5)
class VoiceModel extends HiveObject {
  @HiveField(0)
  String voiceName = 'default';

  @HiveField(1)
  String ttsEngine = 'com.google.android.tts';

  @HiveField(2)
  String ttsLanguage = 'ko-KR';

  @HiveField(3)
  int ttsVoiceType = 1;

  @HiveField(4)
  double ttsVolume = 0.5;

  @HiveField(5)
  double ttsPitch = 1;

  @HiveField(6)
  double ttsRate = 1;

  @HiveField(7)
  String ttsLocale = 'ko';

  VoiceModel({
    required this.voiceName,
    required this.ttsEngine,
    required this.ttsLanguage,
    required this.ttsVoiceType,
    required this.ttsVolume,
    required this.ttsPitch,
    required this.ttsRate,
    required this.ttsLocale
  });

  VoiceModel.defaultValues();

}
