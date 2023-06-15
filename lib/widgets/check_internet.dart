import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:travelult/widgets/snacbar.dart';

class CheckForInternet {
  static Future checkForInternet(BuildContext context) async {
    final Connectivity connectivity = Connectivity();
    final ConnectivityResult result;
    try {
      result = await connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        if (context.mounted) {
          customSnacBar(
            context,
            "No Internet Connection Found",
            SnackBarAction(
              label: "Retry",
              onPressed: () {
                checkForInternet(context);
              },
            ),
          );
        }
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
