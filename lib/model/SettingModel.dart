import 'package:hive/hive.dart';

part 'SettingModel.g.dart';
// flutter pub run build_runner build

@HiveType(typeId: 4)
class SettingModel extends HiveObject {
  // Hive 초기 데이터 세팅용
  @HiveField(0)
  bool isFirstVisit = false;

  // 튜토리얼 필요해지면 따로 듣게 변수로 관리
  @HiveField(1)
  bool isTutorialNeeded = false;

  @HiveField(2)  // 아마 실제로 쓰이지는 않을 예정
  String ttsEngine;

  @HiveField(3)
  String ttsLanguage;

  @HiveField(4)
  int ttsVoiceType;
  
  @HiveField(5)
  double ttsVolume;

  @HiveField(6)
  double ttsPitch;

  @HiveField(7)
  double ttsRate;

  SettingModel({
    required this.isFirstVisit,
    required this.isTutorialNeeded,
    required this.ttsEngine,
    required this.ttsLanguage,
    required this.ttsVoiceType,
    required this.ttsVolume,
    required this.ttsPitch,
    required this.ttsRate
  });

  SettingModel copyWith({
    bool? isFirstVisit,
    bool? isTutorialNeeded,
    String? ttsEngine,
    String? ttsLanguage,
    int? ttsVoiceType,
    double? ttsVolume,
    double? ttsPitch,
    double? ttsRate,
  }) {
    return SettingModel(
      isFirstVisit: isFirstVisit ?? this.isFirstVisit,
      isTutorialNeeded: isTutorialNeeded ?? this.isTutorialNeeded,
      ttsEngine: ttsEngine ?? this.ttsEngine,
      ttsLanguage: ttsLanguage ?? this.ttsLanguage,
      ttsVoiceType: ttsVoiceType ?? this.ttsVoiceType,
      ttsVolume: ttsVolume ?? this.ttsVolume,
      ttsPitch: ttsPitch ?? this.ttsPitch,
      ttsRate: ttsRate ?? this.ttsRate,
    );
  }
}