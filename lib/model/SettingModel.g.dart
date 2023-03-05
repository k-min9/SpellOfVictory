// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SettingModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingModelAdapter extends TypeAdapter<SettingModel> {
  @override
  final int typeId = 4;

  @override
  SettingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingModel(
      isFirstVisit: fields[0] as bool,
      isTutorialNeeded: fields[1] as bool,
      ttsEngine: fields[2] as String,
      ttsLanguage: fields[3] as String,
      ttsVoiceType: fields[4] as int,
      ttsVolume: fields[5] as double,
      ttsPitch: fields[6] as double,
      ttsRate: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, SettingModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.isFirstVisit)
      ..writeByte(1)
      ..write(obj.isTutorialNeeded)
      ..writeByte(2)
      ..write(obj.ttsEngine)
      ..writeByte(3)
      ..write(obj.ttsLanguage)
      ..writeByte(4)
      ..write(obj.ttsVoiceType)
      ..writeByte(5)
      ..write(obj.ttsVolume)
      ..writeByte(6)
      ..write(obj.ttsPitch)
      ..writeByte(7)
      ..write(obj.ttsRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
