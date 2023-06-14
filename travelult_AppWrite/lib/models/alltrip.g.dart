// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alltrip.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 0;

  @override
  Trip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trip(
      id: fields[0] as int,
      title: fields[1] as String,
      from: fields[2] as String,
      to: fields[3] as String,
      date: fields[4] as String,
      time: fields[5] as String,
      status: fields[6] as bool,
      tickets: fields[7] as String,
      documents: fields[8] as String,
      isAlarmActive: fields[9] as bool,
      unsplashData: (fields[10] as List).cast<dynamic>(),
      otherData: (fields[11] as List).cast<dynamic>(),
      notes: (fields[12] as List).cast<dynamic>(),
      formattedAddr: fields[13] as String,
      pointOfInterest: (fields[14] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.from)
      ..writeByte(3)
      ..write(obj.to)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.time)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.tickets)
      ..writeByte(8)
      ..write(obj.documents)
      ..writeByte(9)
      ..write(obj.isAlarmActive)
      ..writeByte(10)
      ..write(obj.unsplashData)
      ..writeByte(11)
      ..write(obj.otherData)
      ..writeByte(12)
      ..write(obj.notes)
      ..writeByte(13)
      ..write(obj.formattedAddr)
      ..writeByte(14)
      ..write(obj.pointOfInterest);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
