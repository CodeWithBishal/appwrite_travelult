import 'package:hive/hive.dart';

part 'alltrip.g.dart';

@HiveType(typeId: 0)
class Trip extends HiveObject {
  @HiveField(0)
  late int id;
  @HiveField(1)
  late String title;
  @HiveField(2)
  late String from;
  @HiveField(3)
  late String to;
  @HiveField(4)
  late String date;
  @HiveField(5)
  late String time;
  @HiveField(6)
  late bool status;
  @HiveField(7)
  late String tickets;
  @HiveField(8)
  late String documents;
  @HiveField(9)
  late bool isAlarmActive;
  @HiveField(10)
  late List unsplashData;
  @HiveField(11)
  late List otherData;
  @HiveField(12)
  late List notes;
  @HiveField(13)
  late String formattedAddr = "null";
  @HiveField(14)
  late List pointOfInterest = [
    {"name": "None Found", "formatted_address": "None Found"}
  ];

  Trip({
    required this.id,
    required this.title,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.status,
    required this.tickets,
    required this.documents,
    required this.isAlarmActive,
    required this.unsplashData,
    required this.otherData,
    required this.notes,
    required this.formattedAddr,
    required this.pointOfInterest,
  });

  toJson() {
    return {
      "id": id,
      "title": title,
      "from": from,
      "to": to,
      "date": date,
      "time": time,
      "status": status,
      "tickets": tickets,
      "documents": documents,
      "isAlarmActive": isAlarmActive,
      "unsplashData": unsplashData,
      "otherData": otherData,
      "notes": notes,
      "formattedAddr": formattedAddr,
      "pointOfInterest": pointOfInterest,
    };
  }

  static Trip fromJson(jsonData) {
    return Trip(
      id: jsonData['id'],
      title: jsonData['title'],
      from: jsonData['from'],
      to: jsonData['to'],
      date: jsonData['date'],
      time: jsonData['time'],
      status: jsonData['status'],
      tickets: jsonData['tickets'],
      documents: jsonData['documents'],
      isAlarmActive: jsonData['isAlarmActive'],
      unsplashData: jsonData['unsplashData'],
      otherData: jsonData['otherData'],
      notes: jsonData['notes'],
      formattedAddr: jsonData['formattedAddr'],
      pointOfInterest: jsonData['pointOfInterest'],
    );
  }
}
