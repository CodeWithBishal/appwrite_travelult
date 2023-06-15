import 'dart:io';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:travelult/backend/external_api/get_image_link.dart';
import 'package:travelult/backend/external_api/places_api.dart';
import 'package:travelult/hive_boxes.dart';
import 'package:travelult/models/alltrip.dart';
import 'package:travelult/widgets/appbar.dart';
import 'package:travelult/widgets/check_internet.dart';
import 'package:travelult/widgets/loading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travelult/widgets/notification.dart';
import 'package:intl/intl.dart';
import 'package:travelult/widgets/snacbar.dart';
import '../../backend/authentication.dart';
import '../../backend/handle_trip.dart';

class AddATrip extends StatefulWidget {
  final bool? isUpdate;
  final Trip? trip;
  final int? index;
  const AddATrip({
    Key? key,
    this.isUpdate,
    this.trip,
    this.index,
  }) : super(key: key);

  @override
  State<AddATrip> createState() => _AddATripState();
}

class _AddATripState extends State<AddATrip> {
  final _tripData = Hive.box<Trip>(HiveBoxes.trip);
  _updateTrip() async {
    final AuthAPI user = context.read<AuthAPI>();
    Trip? res = _tripData.getAt(widget.index!);
    res!.title = titleTextEditingController.text;
    res.from = fromTextEditingController.text;
    res.to = toTextEditingController.text;
    res.date = dateTextEditingController.text;
    res.time = timeTextEditingController.text;
    res.tickets = ticketPath;
    res.documents = documentPath;
    res.isAlarmActive = _isAlarm;
    res.save();

    await uploadFiletoFirebeaseStorage(
      res.id,
      res.title,
      res.from,
      res.to,
      res.date,
      res.time,
      res.documents,
      res.tickets,
      res.isAlarmActive,
      res.unsplashData,
      res.formattedAddr,
      res.pointOfInterest,
      res.otherData,
      res.notes,
      user,
    );
  }

  @override
  void initState() {
    NotificationApi.init(initScheduled: true);
    if (widget.isUpdate == true) {
      titleTextEditingController.text = widget.trip!.title;
      fromTextEditingController.text = widget.trip!.from;
      toTextEditingController.text = widget.trip!.to;
      dateTextEditingController.text = widget.trip!.date;
      timeTextEditingController.text = widget.trip!.time;
      ticketPath = widget.trip!.tickets;
      documentPath = widget.trip!.documents;
      _isAlarm = widget.trip!.isAlarmActive;
    }
    super.initState();
  }

  @override
  void dispose() {
    titleTextEditingController.dispose();
    fromTextEditingController.dispose();
    toTextEditingController.dispose();
    dateTextEditingController.dispose();
    timeTextEditingController.dispose();
    super.dispose();
  }

  String ltrim(String str) {
    return str.replaceFirst(RegExp(r"^\s+"), "");
  }

  String rtrim(String str) {
    return str.replaceFirst(RegExp(r"\s+$"), "");
  }

  Future<bool> verifyDateTime(int id) async {
    DateTime enteredDateTime = DateTime.parse(
        "${dateTextEditingController.text} ${timeTextEditingController.text}");
    DateTime now = DateTime.now();
    if (enteredDateTime.isAfter(now.add(const Duration(minutes: 119)))) {
      setState(() {
        _isAlarm = true;
      });
      NotificationApi.showNotification(
        id: id,
        title: titleTextEditingController.text,
        body:
            "You trip from ${fromTextEditingController.text} to ${toTextEditingController.text} is about to start in 2 hours. Click to dismiss",
        scheduledDate: DateTime.parse(
                "${dateTextEditingController.text} ${timeTextEditingController.text}")
            .subtract(const Duration(hours: 2)),
      );
      return true;
    } else {
      flutterToast(
        "Notification won't show up as the trip starts in less than 2 hours.",
      );
      setState(() {
        _isAlarm = false;
      });
      return false;
    }
  }

  void createTrip() async {
    Box<Trip> tripBox = Hive.box<Trip>(HiveBoxes.trip);
    int id = Random().nextInt(30);
    await verifyDateTime(id);
    await addLocalTrip(
      tripBox,
      id,
      titleTextEditingController.text,
      fromTextEditingController.text,
      toTextEditingController.text,
      dateTextEditingController.text,
      timeTextEditingController.text,
      documentPath,
      ticketPath,
      _isAlarm,
      unsplashData,
      formattedAddr,
      pointOfInterest,
      [],
      [],
    );
  }

  late bool _isLoading = false;
  late bool _isTicketPath = false;
  late bool _isDocumentPath = false;
  late bool _isAlarm = kIsWeb ? false : true;
  late List unsplashData = [];
  final _formKey = GlobalKey<FormState>();
  final titleTextEditingController = TextEditingController();
  final fromTextEditingController = TextEditingController();
  final toTextEditingController = TextEditingController();
  final dateTextEditingController = TextEditingController();
  final timeTextEditingController = TextEditingController();
  late String ticketPath = "";
  late String documentPath = "";
  late String formattedAddr = "";
  late List pointOfInterest = [
    {"name": "None Found", "formatted_address": "None Found"}
  ];

  @override
  Widget build(BuildContext context) {
    final texttitleField = TextFormField(
      autofocus: false,
      controller: titleTextEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please type in your departure location.");
        }
        return null;
      },
      keyboardType: TextInputType.text,
      onSaved: (value) {
        titleTextEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        fontFamily: 'Source Sans Pro',
      ),
      decoration: const InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Title   ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        filled: true,
        focusColor: Colors.black,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: Color.fromRGBO(194, 202, 223, 0.32),
      ),
    );
    final textfromField = TextFormField(
      autofocus: false,
      controller: fromTextEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please type in your departure location.");
        }
        return null;
      },
      keyboardType: TextInputType.text,
      onSaved: (value) {
        fromTextEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        fontFamily: 'Source Sans Pro',
      ),
      decoration: const InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "From   ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        filled: true,
        focusColor: Colors.black,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: Color.fromRGBO(194, 202, 223, 0.32),
      ),
    );
    final texttoField = TextFormField(
      readOnly: widget.isUpdate ?? false,
      autofocus: false,
      controller: toTextEditingController,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please type in your desired destination.");
        }
        return null;
      },
      keyboardType: TextInputType.text,
      onSaved: (value) {
        toTextEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        fontFamily: 'Source Sans Pro',
      ),
      decoration: const InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "To   ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        filled: true,
        focusColor: Colors.black,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: Color.fromRGBO(194, 202, 223, 0.32),
      ),
    );
    final textdateField = TextFormField(
      autofocus: false,
      controller: dateTextEditingController,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please specify the start dates of your journey");
        }
        return null;
      },
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final DateTime? dateTime = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(
            const Duration(days: 730),
          ),
        );
        if (dateTime != null) {
          setState(() {
            final dateFormatter = DateFormat(
              'yyyy-MM-dd',
            );
            final dateString = dateFormatter.format(
              dateTime,
            );
            dateTextEditingController.text = dateString;
          });
        } else {
          return;
        }
      },
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        fontFamily: 'Source Sans Pro',
      ),
      decoration: const InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Date   ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        filled: true,
        focusColor: Colors.black,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: Color.fromRGBO(194, 202, 223, 0.32),
      ),
    );

    final textTimeField = TextFormField(
      autofocus: false,
      controller: timeTextEditingController,
      keyboardType: TextInputType.datetime,
      readOnly: true,
      validator: (value) {
        if (value!.isEmpty) {
          return ("Please specify the start time of your journey.");
        }
        return null;
      },
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        final TimeOfDay? timeOfDay = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(
            DateTime.now().add(
              const Duration(minutes: 121),
            ),
          ),
        );
        if (timeOfDay != null) {
          final timeFormatter = DateFormat(
            'kk:mm',
          );
          final timeString = timeFormatter.parse(
            "${timeOfDay.hour + 1}:${timeOfDay.minute}",
          );
          final time = timeFormatter.format(timeString);
          timeTextEditingController.text = time;
        } else {
          return;
        }
      },
      textInputAction: TextInputAction.next,
      cursorColor: Colors.black,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        fontFamily: 'Source Sans Pro',
      ),
      decoration: const InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Time   ",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
        filled: true,
        focusColor: Colors.black,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        fillColor: Color.fromRGBO(194, 202, 223, 0.32),
      ),
    );
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width < 768
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 3;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isLoading
          ? null
          : commonAppBar(
              title: "Plan a new Trip",
              elevation: 0,
              centerTitle: true,
              context: context,
            ),
      body: _isLoading
          ? const LoadingWidget()
          : Center(
              child: ListView(
                primary: false,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: [
                  Container(
                    color: Colors.white,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: height / 20,
                          ),
                          SizedBox(
                            width: width - width / 15,
                            child: texttitleField,
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          SizedBox(
                            width: width - width / 15,
                            child: textfromField,
                          ),
                          SizedBox(
                            height: height / 40,
                          ),
                          widget.isUpdate == true
                              ? ColorFiltered(
                                  colorFilter: const ColorFilter.mode(
                                    Color.fromRGBO(194, 202, 223, 0.42),
                                    BlendMode.modulate,
                                  ),
                                  child: SizedBox(
                                    width: width - width / 15,
                                    child: texttoField,
                                  ),
                                )
                              : SizedBox(
                                  width: width - width / 15,
                                  child: texttoField,
                                ),
                          SizedBox(
                            height: height / 30,
                          ),
                          SizedBox(
                            width: width - width / 15,
                            child: textdateField,
                          ),
                          SizedBox(
                            height: height / 30,
                          ),
                          SizedBox(
                            width: width - width / 15,
                            child: textTimeField,
                          ),
                          SizedBox(
                            height: height / 60,
                          ),
                          kIsWeb
                              ? Container()
                              : SizedBox(
                                  width: width / 1.1,
                                  child: radioButton(),
                                ),
                          kIsWeb
                              ? Container()
                              : SizedBox(
                                  width: width - width / 15,
                                  child: const Text(
                                    "The notification will popup 2 hours prior to departure.",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(84, 84, 84, 1),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Source Sans Pro',
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: height / 60,
                          ),
                          kIsWeb
                              ? const SizedBox(
                                  height: 0,
                                )
                              : SizedBox(
                                  width: width,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles(
                                            allowMultiple: false,
                                            type: FileType.custom,
                                            allowedExtensions: ['pdf'],
                                          );
                                          if (result == null) return;
                                          final file = result.files.first;
                                          final newFile =
                                              await saveFilePermanently(file);
                                          setState(() {
                                            ticketPath = newFile.path;
                                            _isTicketPath = true;
                                          });
                                        },
                                        style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent,
                                          ),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          height: 100,
                                          width: width / 3,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                              194,
                                              202,
                                              223,
                                              0.32,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.add_a_photo,
                                                ),
                                                _isTicketPath
                                                    ? const Text(
                                                        "Tickets Added.",
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                    : const Text(
                                                        "Please upload your travel tickets.",
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final result = await FilePicker
                                              .platform
                                              .pickFiles(
                                            allowMultiple: false,
                                            type: FileType.custom,
                                            allowedExtensions: ['pdf'],
                                          );
                                          if (result == null) return;
                                          final file = result.files.first;
                                          final newFile =
                                              await saveFilePermanently(file);
                                          setState(() {
                                            documentPath = newFile.path;
                                            _isDocumentPath = true;
                                          });
                                        },
                                        style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent,
                                          ),
                                        ),
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          height: 100,
                                          width: width / 3,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                              194,
                                              202,
                                              223,
                                              0.32,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              const Icon(Icons.add_a_photo),
                                              _isDocumentPath
                                                  ? const Text(
                                                      "Documents Added.",
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                                  : const Text(
                                                      "Please upload Documents(e.g. Passport).",
                                                      textAlign:
                                                          TextAlign.center,
                                                    )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: height / 60,
                          ),
                          kIsWeb
                              ? const SizedBox(
                                  height: 0,
                                )
                              : SizedBox(
                                  width: width - width / 15,
                                  child: const Text(
                                    "Please note that these documents are not saved on our servers.",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromRGBO(84, 84, 84, 1),
                                      fontWeight: FontWeight.normal,
                                      fontFamily: 'Source Sans Pro',
                                    ),
                                  ),
                                ),
                          SizedBox(
                            height: height / 30,
                          ),
                          SizedBox(
                            width: width - width / 15,
                            height: height / 15,
                            child: TextButton(
                              onPressed: widget.isUpdate == true
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          if (!kIsWeb && _isAlarm) {
                                            verifyDateTime(widget.trip!.id)
                                                .then((value) {
                                              if (value == false) {
                                                NotificationApi.cancel(
                                                  widget.trip!.id,
                                                );
                                              }
                                            });
                                          } else {
                                            NotificationApi.cancel(
                                              widget.trip!.id,
                                            );
                                          }
                                          _updateTrip();
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
                                          flutterToast(
                                            "Trip has been successfully updated!",
                                          );
                                        });
                                      }
                                    }
                                  : () {
                                      CheckForInternet.checkForInternet(context)
                                          .then(
                                        (value) => {
                                          if (value == true)
                                            {
                                              if (_formKey.currentState!
                                                  .validate())
                                                {
                                                  setState(() {
                                                    _isLoading = true;
                                                  }),
                                                  RetriveLink.retriveLink(
                                                    toTextEditingController.text
                                                        .trimLeft()
                                                        .trimRight(),
                                                    unsplashData,
                                                  ).then((value) {
                                                    setState(() {
                                                      unsplashData = value;
                                                      RetriveDataFromGoogleMaps
                                                          .retriveDataFromGoogleMaps(
                                                        toTextEditingController
                                                            .text,
                                                        formattedAddr,
                                                      ).then((value) {
                                                        setState(() {
                                                          formattedAddr = value;
                                                          RetriveDataFromGoogleMaps
                                                              .retrivePointOfInterest(
                                                            toTextEditingController
                                                                .text,
                                                            pointOfInterest,
                                                          ).then((value) {
                                                            setState(() {
                                                              pointOfInterest =
                                                                  value;
                                                              createTrip();
                                                              Navigator.pop(
                                                                  context);
                                                            });
                                                          }).catchError((error,
                                                              stackTrace) {
                                                            flutterToast(
                                                                "Something went terribly wrong. Please try again later");
                                                            setState(() {
                                                              _isLoading =
                                                                  false;
                                                            });
                                                          });
                                                        });
                                                      }).catchError(
                                                          (error, stackTrace) {
                                                        flutterToast(
                                                            "Something went terribly wrong. Please try again later");
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                      });
                                                    });
                                                  }).catchError(
                                                      (error, stackTrace) {
                                                    flutterToast(
                                                        "Something went terribly wrong. Please try again later");
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  }),
                                                }
                                            }
                                          else
                                            {
                                              CheckForInternet.checkForInternet(
                                                context,
                                              ),
                                            }
                                        },
                                      );
                                    },
                              style: ButtonStyle(
                                enableFeedback: false,
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.blue.shade100,
                                ),
                                overlayColor:
                                    MaterialStateProperty.all(Colors.white12),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                              ),
                              child: const Text(
                                "Add Trip",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height / 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget radioButton() {
    return Row(
      children: [
        const Text(
          "Notification Status:",
          style: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(84, 84, 84, 1),
            fontWeight: FontWeight.normal,
            fontFamily: 'Source Sans Pro',
          ),
        ),
        Radio(
          value: true,
          groupValue: _isAlarm,
          onChanged: (isAlarm) => setState(() {
            _isAlarm = true;
          }),
        ),
        const Text(
          "On",
          style: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(84, 84, 84, 1),
            fontWeight: FontWeight.normal,
            fontFamily: 'Source Sans Pro',
          ),
        ),
        Radio(
          value: false,
          groupValue: _isAlarm,
          onChanged: (isAlarm) => setState(() {
            _isAlarm = false;
          }),
        ),
        const Text(
          "Off",
          style: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(84, 84, 84, 1),
            fontWeight: FontWeight.normal,
            fontFamily: 'Source Sans Pro',
          ),
        ),
      ],
    );
  }

  Future<File> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newfile = File("${appStorage.path}/${file.name}");

    return File(file.path!).copy(newfile.path);
  }
}
