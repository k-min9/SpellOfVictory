// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VoiceModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VoiceModelAdapter extends TypeAdapter<VoiceModel> {
  @override
  final int typeId = 5;

  @override
  VoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VoiceModel(
      voiceName: fields[0] as String,
      ttsEngine: fields[1] as String,
      ttsLanguage: fields[2] as String,
      ttsVoiceType: fields[3] as int,
      ttsVolume: fields[4] as double,
      ttsPitch: fields[5] as double,
      ttsRate: fields[6] as double,
      ttsLocale: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VoiceModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.voiceName)
      ..writeByte(1)
      ..write(obj.ttsEngine)
      ..writeByte(2)
      ..write(obj.ttsLanguage)
      ..writeByte(3)
      ..write(obj.ttsVoiceType)
      ..writeByte(4)
      ..write(obj.ttsVolume)
      ..writeByte(5)
      ..write(obj.ttsPitch)
      ..writeByte(6)
      ..write(obj.ttsRate)
      ..writeByte(7)
      ..write(obj.ttsLocale);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VoiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
