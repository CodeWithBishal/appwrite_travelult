import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:travelult/backend/url_launcher.dart';
import 'package:travelult/hive_boxes.dart';
import 'package:travelult/models/alltrip.dart';
import 'package:travelult/screens/loggedin_screens/add_trip.dart';
import 'package:travelult/widgets/cached_network_image.dart';
import 'package:travelult/widgets/notification.dart';
import 'package:travelult/widgets/snacbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../backend/authentication.dart';
import '../../backend/handle_trip.dart';
import '../../widgets/loading.dart';
import 'pdf_viewer.dart';

class ViewAllTrips extends StatefulWidget {
  final Trip trip;
  final int index;
  const ViewAllTrips({
    Key? key,
    required this.trip,
    required this.index,
  }) : super(key: key);

  @override
  State<ViewAllTrips> createState() => _ViewAllTripsState();
}

class _ViewAllTripsState extends State<ViewAllTrips>
    with TickerProviderStateMixin {
  late final bool _isLoading = false;
  var isDialOpen = ValueNotifier<bool>(false);
  List unsplashData = [];
  late String formattedAddr = "";
  late String ticketPath;
  late String documentPath;
  final notesTextEditingController = TextEditingController();
  late TabController tabController;
  final _tripData = Hive.box<Trip>(HiveBoxes.trip);
  late List pointOfInterest = (widget.trip.pointOfInterest);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    NotificationApi.init(initScheduled: true);
    ticketPath = widget.trip.tickets;
    documentPath = widget.trip.documents;
    unsplashData = widget.trip.unsplashData;
    formattedAddr = widget.trip.formattedAddr;
    tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  _save() {
    final AuthAPI user = context.read<AuthAPI>();
    Trip? res = _tripData.getAt(widget.index);
    res!.save();

    uploadFiletoFirebeaseStorage(
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

  Widget faB() {
    return ValueListenableBuilder(
      valueListenable: isDialOpen,
      builder: (BuildContext context, value, Widget? child) {
        return TextButton(
          onPressed: () => {isDialOpen.value = !isDialOpen.value},
          child: SpeedDial(
            openCloseDial: isDialOpen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.blue.shade200,
            spacing: 5,
            spaceBetweenChildren: 5,
            buttonSize: const Size(65, 65),
            childrenButtonSize: const Size(60, 60),
            closeManually: true,
            animatedIcon: AnimatedIcons.menu_close,
            children: [
              SpeedDialChild(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onTap: () {
                  isDialOpen.value = !isDialOpen.value;
                  setState(
                    () {
                      flutterToast("Coming Soon");
                    },
                  );
                },
                elevation: 4,
                child: const FaIcon(
                  FontAwesomeIcons.share,
                  size: 30,
                  color: Colors.white,
                ),
                label: "Share",
                backgroundColor: Colors.blue.shade100,
                foregroundColor: Colors.blue.shade50,
              ),
              SpeedDialChild(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onTap: () {
                  isDialOpen.value = !isDialOpen.value;
                  setState(
                    () {
                      flutterToast("Coming Soon");
                    },
                  );
                },
                elevation: 4,
                child: const Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 30,
                ),
                label: "Download",
                backgroundColor: Colors.blue.shade100,
                foregroundColor: Colors.blue.shade50,
              ),
              SpeedDialChild(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                onTap: () {
                  isDialOpen.value = !isDialOpen.value;
                  widget.trip.status = !widget.trip.status;
                  _save();
                  setState(() {
                    flutterToast(
                      widget.trip.status
                          ? "The Trip has been marked as completed"
                          : "The Trip has been marked as not completed",
                    );
                    Navigator.pop(context, widget.trip);
                    if (!kIsWeb) {
                      NotificationApi.cancel(widget.trip.id);
                    }
                  });
                },
                label: widget.trip.status
                    ? "Mark as not Completed"
                    : "Mark as Completed",
                child: FaIcon(
                  widget.trip.status
                      ? FontAwesomeIcons.pause
                      : FontAwesomeIcons.check,
                  size: 30,
                  color: Colors.white,
                ),
                foregroundColor: Colors.blue.shade50,
                backgroundColor: Colors.blue.shade100,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width < 768
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 3;
    final bool showFab = MediaQuery.of(context).viewInsets.bottom == 0.0;
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        }
        return true;
      },
      child: Scaffold(
        floatingActionButton: showFab ? faB() : null,
        backgroundColor: Colors.white,
        appBar: _isLoading
            ? null
            : AppBar(
                elevation: 5,
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                title: Text(
                  widget.trip.title,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context, widget.trip);
                    });
                  },
                  enableFeedback: false,
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                ),
                centerTitle: true,
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) => AddATrip(
                                isUpdate: true,
                                trip: widget.trip,
                                index: widget.index,
                              )),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                    ),
                    label: const Text("Edit"),
                    style: ButtonStyle(
                      overlayColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white,
                      ),
                      foregroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.black,
                      ),
                      enableFeedback: false,
                    ),
                  )
                ],
              ),
        body: _isLoading
            ? const LoadingWidget()
            : showTripData(
                width,
                height,
              ),
      ),
    );
  }

  Widget showTripData(width, height) {
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: false,
      primary: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Stack(
          children: <Widget>[
            SizedBox(
              height: height / 3,
              width: width,
              child: Stack(
                children: [
                  SizedBox(
                    width: width,
                    height: height / 5,
                    child: CachedImageNetworkimage(
                      url: unsplashData[0],
                      width: width,
                      isBorder: false,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 3,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Photo By ',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                          TextSpan(
                            text: unsplashData[1],
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                isDialOpen.value = !isDialOpen.value;
                                LaunchUrl.openLink(
                                  url:
                                      "https://unsplash.com/@${unsplashData[1]}?utm_source=travel_ult&utm_medium=referral",
                                  context: context,
                                  launchMode: LaunchMode.externalApplication,
                                );
                              },
                          ),
                          const TextSpan(
                            text: ' on ',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                          TextSpan(
                            text: 'Unsplash',
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                isDialOpen.value = !isDialOpen.value;
                                LaunchUrl.openLink(
                                  url:
                                      "https://unsplash.com/?utm_source=travel_ult&utm_medium=referral",
                                  context: context,
                                  launchMode: LaunchMode.externalApplication,
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    right: 50,
                    bottom: 25,
                    child: Material(
                      color: Colors.transparent,
                      elevation: 10,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            width: width - (width / 3),
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.6),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Trip from ${widget.trip.from} to ${widget.trip.to}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: height / 30,
                                ),
                                Text(
                                  "${widget.trip.date} : ${widget.trip.time}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GFSegmentTabs(
            height: 40,
            indicatorColor: Colors.blue[200],
            border: Border.all(color: Colors.blue[200]!),
            unselectedLabelColor: Colors.blue[200],
            tabController: tabController,
            length: 3,
            tabs: const <Widget>[
              Text(
                "Overview",
              ),
              Text(
                "Documents",
              ),
              Text(
                "Notes",
              ),
            ],
          ),
        ),
        SizedBox(
          height: (height + height) / 3,
          child: GFTabBarView(
            controller: tabController,
            height: height < 768 ? height : height / 1.5,
            children: [
              home(
                width,
                height,
              ),
              document(
                width,
                height,
              ),
              notes(
                width,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget notes(width) {
    return ListView(
      primary: true,
      scrollDirection: Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        SizedBox(
          width: width,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      maxLength: 60,
                      autofocus: false,
                      controller: notesTextEditingController,
                      keyboardType: TextInputType.text,
                      onSaved: (value) {
                        notesTextEditingController.text = value!;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter a valid Note");
                        }
                        return null;
                      },
                      cursorColor: Colors.black,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Source Sans Pro',
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Add Notes',
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      widget.trip.notes += [notesTextEditingController.text];
                      _save();
                      notesTextEditingController.clear();
                    });
                  }
                },
                enableFeedback: false,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        ListView.builder(
          reverse: true,
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.trip.notes.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      height: 120,
                      child: Center(
                        child: ListTile(
                          tileColor: Colors.white12,
                          title: Text(
                            (widget.trip.notes[index]).toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                delete(index);
                              });
                            },
                            enableFeedback: false,
                            tooltip: "Delete",
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget document(width, height) {
    return ListView(
      primary: true,
      scrollDirection: Axis.vertical,
      physics: const AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        TextButton(
          onPressed: ticketPath == ""
              ? () {
                  flutterToast("To update Tickets, please enable editing.");
                }
              : () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerPage(
                        pdf: File(ticketPath),
                      ),
                    ),
                  );
                },
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith(
              (states) => Colors.transparent,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 200,
            width: width - 15,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(
                194,
                202,
                223,
                0.32,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: ticketPath == ""
                    ? const [
                        Icon(Icons.add_a_photo),
                        Text(
                          "Please upload your Travel Tickets.",
                          textAlign: TextAlign.center,
                        )
                      ]
                    : const [
                        Icon(Icons.open_in_new),
                        Text(
                          "Open Tickets",
                          textAlign: TextAlign.center,
                        )
                      ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: height / 50,
        ),
        TextButton(
          onPressed: documentPath == ""
              ? () {
                  flutterToast("To update Document, please enable editing.");
                }
              : () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerPage(
                        pdf: File(documentPath),
                      ),
                    ),
                  );
                },
          style: ButtonStyle(
            overlayColor: MaterialStateColor.resolveWith(
              (states) => Colors.transparent,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            height: 200,
            width: width - 15,
            decoration: BoxDecoration(
              color: const Color.fromRGBO(
                194,
                202,
                223,
                0.32,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: documentPath == ""
                  ? const [
                      Icon(Icons.add_a_photo),
                      Text(
                        "Please upload Documents(e.g. Passport)",
                        textAlign: TextAlign.center,
                      )
                    ]
                  : const [
                      Icon(Icons.open_in_new),
                      Text(
                        "Open Documents",
                        textAlign: TextAlign.center,
                      )
                    ],
            ),
          ),
        ),
        SizedBox(
          height: height / 4,
        )
      ],
    );
  }

  Widget home(width, height) {
    return ListView(
      primary: false,
      children: [
        GFAccordion(
          showAccordion: true,
          title: 'Address',
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            fontSize: 20,
          ),
          contentChild: Row(
            children: [
              Expanded(
                flex: 5,
                child: Text(
                  formattedAddr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Source Sans Pro',
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: TextButton(
                  onPressed: () {
                    LaunchUrl.openLink(
                      url:
                          "https://www.google.com/maps/place/${widget.trip.to}",
                      context: context,
                      launchMode: LaunchMode.externalApplication,
                    );
                  },
                  style: const ButtonStyle(
                    enableFeedback: false,
                  ),
                  child: const Text(
                    "Open in Maps",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        GFAccordion(
          showAccordion: true,
          title: 'Point of Interests',
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat',
            fontSize: 20,
          ),
          contentChild: CarouselSlider.builder(
            itemCount: pointOfInterest.length,
            itemBuilder: (BuildContext context, int index, int pageViewIndex) {
              return GestureDetector(
                onTap: () {
                  var link =
                      "https://www.google.com/maps/search/${pointOfInterest[index]["name"]}";
                  var encoded = Uri.encodeFull(link);
                  LaunchUrl.openLink(
                    url: encoded,
                    context: context,
                    launchMode: LaunchMode.externalApplication,
                  );
                },
                child: Card(
                  elevation: 5,
                  child: Center(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[200],
                        child: const Icon(
                          Icons.pin_drop,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        pointOfInterest[index]["name"],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.0,
                        ),
                      ),
                      subtitle: Text(
                        pointOfInterest[index]["formatted_address"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                          fontSize: 17.0,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              height: height / 6.5,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  delete(int index) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromRGBO(241, 242, 246, 0.9),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          title: const Text("Delete Note?"),
          content: const Text(
            "Are you sure?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                enableFeedback: false,
                backgroundColor: MaterialStateProperty.all(Colors.white),
                overlayColor: MaterialStateProperty.all(Colors.white12),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  widget.trip.notes.removeAt(index);
                  _save();
                });
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                enableFeedback: false,
                backgroundColor: MaterialStateProperty.all(Colors.white),
                overlayColor: MaterialStateProperty.all(Colors.white12),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              child: const Text(
                "Delete",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
