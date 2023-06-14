import 'dart:convert';
import 'package:appwrite/appwrite.dart';
import '../models/alltrip.dart';
import '../widgets/constant.dart';
import '../widgets/snacbar.dart';
import 'authentication.dart';

Future uploadFiletoFirebeaseStorage(
    id,
    titleTextEditingController,
    fromTextEditingController,
    toTextEditingController,
    dateTextEditingController,
    timeTextEditingController,
    documentPath,
    ticketPath,
    isAlarm,
    unsplashData,
    formattedAddr,
    pointOfInterest,
    otherData,
    notes,
    AuthAPI user) async {
  final listObj = {
    "$id": {
      'id': id,
      'title': titleTextEditingController,
      'from': fromTextEditingController,
      'to': toTextEditingController,
      'date': dateTextEditingController,
      'time': timeTextEditingController,
      'status': false,
      'documents': documentPath,
      'tickets': ticketPath,
      'isAlarmActive': isAlarm,
      'unsplashData': unsplashData,
      'otherData': otherData,
      'notes': notes,
      'formattedAddr': formattedAddr,
      'pointOfInterest': pointOfInterest,
    }
  };
  final jsonData = json.encode(listObj);
  try {
    Client client = Client();
    client
        .setEndpoint("https://cloud.appwrite.io/v1")
        .setProject("64750a688256f3697ab1")
        .setSelfSigned(status: false);
    InputFile file = InputFile.fromBytes(
        bytes: jsonData.codeUnits,
        filename: "${user.userID}-${id.toString()}.json",
        contentType: "application/json");
    Storage storage = Storage(client);
    await storage.createFile(
      bucketId: bucketID,
      file: file,
      fileId: "${user.userID}-${id.toString()}",
    );
  } catch (e) {
    flutterToast(e.toString());
  }
}

Future addLocalTrip(
  tripBox,
  id,
  titleTextEditingController,
  fromTextEditingController,
  toTextEditingController,
  dateTextEditingController,
  timeTextEditingController,
  documentPath,
  ticketPath,
  isAlarm,
  unsplashData,
  formattedAddr,
  pointOfInterest,
  otherData,
  notes,
) async {
  tripBox.add(
    Trip(
      id: id,
      title: titleTextEditingController,
      from: fromTextEditingController,
      to: toTextEditingController,
      date: dateTextEditingController,
      time: timeTextEditingController,
      status: false,
      documents: documentPath,
      tickets: ticketPath,
      isAlarmActive: isAlarm,
      unsplashData: unsplashData,
      otherData: otherData,
      notes: notes,
      formattedAddr: formattedAddr,
      pointOfInterest: pointOfInterest,
    ),
  );
}
