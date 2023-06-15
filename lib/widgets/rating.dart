import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:travelult/backend/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

RateMyApp rateMyApp = RateMyApp(
  preferencesPrefix: 'Travel Ult',
  minDays: 0,
  minLaunches: 0,
  remindDays: 0,
  remindLaunches: 0,
  googlePlayIdentifier: 'com.codewithbishal.travelult',
);

Future<bool> showRating(BuildContext context, Image logo) async {
  await rateMyApp.init();
  if (kDebugMode) {
    rateMyApp.reset();
  }
  if (rateMyApp.shouldOpenDialog && context.mounted) {
    await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => RatingDialog(
        enableComment: false,
        title: const Text(
          'Enjoying our App ?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        force: false,
        starSize: 30,
        onCancelled: () {},
        showCloseButton: true,
        message: const Text(
          'Please take a moment to rate Travel Ult',
        ),
        image: logo,
        onSubmitted: (response) async {
          if (response.rating == 5 || response.rating == 4) {
            LaunchUrl.openLink(
              url:
                  "https://play.google.com/store/apps/details?id=com.codewithbishal.travelult",
              context: context,
              launchMode: LaunchMode.externalApplication,
            );
            rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
            return true;
          } else if (response.rating == 3 ||
              response.rating == 2 ||
              response.rating == 1) {
            LaunchUrl.openLink(
              url: "https://codewithbishal.com/contact-us?platform=travel_ult",
              context: context,
              launchMode: LaunchMode.externalApplication,
            );
            rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
            return true;
          }
        },
        submitButtonText: 'Submit',
      ),
    );
  } else {
    return true;
  }
  return false;
}
