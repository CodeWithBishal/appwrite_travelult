import 'package:flutter/foundation.dart';
import '../models/alltrip.dart';
import 'package:flutter/material.dart';
import '../widgets/notification.dart';

//1
deleteTrip(Trip trip, BuildContext context) {
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
        title: const Text("Delete Trip"),
        content: const Text(
          "Are you sure you want to delete this Trip? This is an irreversible action.",
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
            onPressed: () async {
              trip.delete().whenComplete(() => Navigator.pop(context));
              if (!kIsWeb) {
                if (trip.isAlarmActive) {
                  NotificationApi.cancel(trip.id);
                }
              }
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
