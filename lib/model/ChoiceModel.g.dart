// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChoiceModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChoiceModelAdapter extends TypeAdapter<ChoiceModel> {
  @override
  final int typeId = 1;

  @override
  ChoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChoiceModel(
      name: fields[0] as String,
      texts: (fields[1] as List).cast<ChoiceTextModel>(),
      isSelected: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChoiceModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.texts)
      ..writeByte(2)
      ..write(obj.isSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChoiceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChoiceTextModelAdapter extends TypeAdapter<ChoiceTextModel> {
  @override
  final int typeId = 3;

  @override
  ChoiceTextModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChoiceTextModel(
      content: fields[0] as String,
      isChoiceSelected: fields[1] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ChoiceTextModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.content)
      ..writeByte(1)
      ..write(obj.isChoiceSelected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChoiceTextModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
