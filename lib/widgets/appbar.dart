import 'package:flutter/material.dart';
import 'package:travelult/widgets/snacbar.dart';

AppBar commonAppBar({
  required String title,
  required double elevation,
  required bool centerTitle,
  List<Widget>? actions,
  bool? forceDisableBack = false,
  required BuildContext context,
}) {
  return AppBar(
    elevation: elevation,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    title: Text(
      title,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
        fontSize: 20,
      ),
    ),
    centerTitle: centerTitle,
    leading: Navigator.canPop(context) && forceDisableBack! == false
        ? IconButton(
            enableFeedback: false,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          )
        : null,
    actions: actions ??
        [
          TextButton.icon(
            onPressed: () {
              flutterToast("Coming Soon!");
            },
            label: const Icon(
              Icons.whatshot_outlined,
              size: 30,
              color: Color(0xFFF1D00A),
            ),
            icon: const Text(
              "Pro",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: Color(0xFFF1D00A),
              ),
            ),
            style: ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith(
                (states) => Colors.white,
              ),
              enableFeedback: false,
            ),
          )
        ],
  );
}
