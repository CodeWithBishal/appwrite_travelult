import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:travelult/hive_boxes.dart';
import 'package:travelult/models/alltrip.dart';
import 'package:travelult/screens/loggedin_screens/list_trip.dart';
import 'package:travelult/widgets/appbar.dart';
import 'package:travelult/widgets/loading.dart';
import 'package:travelult/widgets/no_trip.dart';
import 'package:travelult/widgets/notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    NotificationApi.init(initScheduled: true);
    NotificationApi().requestPermissions();
    NotificationApi().isAndroidPermissionGranted();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width < 768
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 2;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: commonAppBar(
        title: "Travel Ult",
        elevation: 5,
        centerTitle: true,
        context: context,
        forceDisableBack: true,
      ),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const LoadingWidget()
          : ValueListenableBuilder(
              valueListenable: Hive.box<Trip>(HiveBoxes.trip).listenable(),
              builder: (context, Box<Trip> box, _) {
                if (box.values.isEmpty) {
                  return const NoTripAsktoAdd();
                }
                return ListView(
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          MediaQuery.of(context).size.width < 768
                              ? const SizedBox(
                                  height: 0,
                                  width: 0,
                                )
                              : SizedBox(
                                  height: height / 20,
                                ),
                          SizedBox(
                            width: width,
                            child: const ListAllTrip(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}
