import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:travelult/hive_boxes.dart';
import 'package:travelult/models/alltrip.dart';
import 'package:travelult/screens/loggedin_screens/trip_view.dart';
import 'package:travelult/widgets/cached_network_image.dart';
import '../../backend/sync.dart';

class ListAllTrip extends StatefulWidget {
  const ListAllTrip({Key? key}) : super(key: key);

  @override
  State<ListAllTrip> createState() => _ListAllTripState();
}

class _ListAllTripState extends State<ListAllTrip> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width < 768
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 3;

    return ListView(
      shrinkWrap: true,
      primary: false,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: height / 30,
            ),
            SizedBox(
              height: height / 20,
              child: const Text(
                "Upcoming Trips",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            SizedBox(
              height: height / 30,
            ),
            ValueListenableBuilder(
              valueListenable: Hive.box<Trip>(HiveBoxes.trip).listenable(),
              builder: (context, Box<Trip> box, _) {
                return ListView.builder(
                  reverse: true,
                  primary: false,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: box.values
                          .where(
                            (element) => element.status == false,
                          )
                          .isEmpty
                      ? 1
                      : box.length,
                  itemBuilder: (context, index) {
                    Trip? res = box.getAt(index);
                    if (box.values
                        .where(
                          (element) => element.status == false,
                        )
                        .isNotEmpty) {
                      if (res!.status) {
                        return Container();
                      } else {
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ViewAllTrips(
                                  trip: res,
                                  index: index,
                                ),
                              ),
                            );
                          },
                          child: individualTrip(res, index, width, height),
                        );
                      }
                    } else {
                      return const Center(
                        child: Text(
                          "You Don't have any upcoming trips, You can book a new trip using 'Book a Trip' or Add an existing one.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Source Sans Pro',
                            fontSize: 24,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            SizedBox(
              height: height / 30,
            ),
            SizedBox(
              height: height / 20,
              child: const Text(
                "Completed Trips",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            SizedBox(
              height: height / 30,
            ),
            ValueListenableBuilder(
                valueListenable: Hive.box<Trip>(HiveBoxes.trip).listenable(),
                builder: (context, Box<Trip> box, _) {
                  return ListView.builder(
                    reverse: true,
                    primary: false,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: box.values
                            .where(
                              (element) => element.status == true,
                            )
                            .isEmpty
                        ? 1
                        : box.length,
                    itemBuilder: (context, index) {
                      Trip? res = box.getAt(index);
                      if (box.values
                          .where(
                            (element) => element.status == true,
                          )
                          .isNotEmpty) {
                        if (res!.status == true) {
                          return GestureDetector(
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewAllTrips(
                                    trip: res,
                                    index: index,
                                  ),
                                ),
                              );
                            },
                            child: individualTrip(res, index, width, height),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Center(
                          child: Column(
                            children: [
                              const Text(
                                "You can mark a Trip as completed once you've done it.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Source Sans Pro',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              SizedBox(
                                height: height / 4,
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                }),
          ],
        ),
      ],
    );
  }

  individualTrip(Trip trip, index, width, height) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 18,
      ),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(18),
        color: trip.status ? Colors.yellow[100] : Colors.blue[50],
        child: SizedBox(
          height: height / 2.5,
          width: width / 1.2,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: height / 4,
                    child: CachedImageNetworkimage(
                      url: trip.unsplashData[0],
                      width: width,
                      isBorder: true,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        onPressed: () {
                          deleteTrip(trip, context);
                        },
                        icon: const Icon(
                          Icons.delete,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height / 12,
                width: width / 1.2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trip.title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: height / 25,
                      width: width / 6,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: trip.status == false
                            ? BorderRadius.circular(10)
                            : BorderRadius.circular(0),
                        color: trip.status == false
                            ? Colors.white
                            : Colors.transparent,
                      ),
                      child: trip.status
                          ? const Icon(
                              Icons.verified,
                              color: Colors.greenAccent,
                            )
                          : const Text(
                              "Pending",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: width / 1.2,
                child: Row(
                  children: [
                    Text(
                      "${trip.date}, ${trip.time}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
