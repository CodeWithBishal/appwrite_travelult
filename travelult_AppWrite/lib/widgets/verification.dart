import 'package:flutter/material.dart';

Future verificationDialogue(context) async {
  return await showDialog(
    context: context,
    builder: (_) => Dialog(
      backgroundColor: const Color.fromRGBO(241, 242, 246, 0.8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: Container(
        alignment: FractionalOffset.center,
        width: MediaQuery.of(context).size.width < 768
            ? MediaQuery.of(context).size.width
            : MediaQuery.of(context).size.width / 3,
        height: MediaQuery.of(context).size.height / 1.7,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
              child: const Icon(
                Icons.mail,
                size: 90,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Verification link has been sent your Email ID.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Source Sans Pro',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 70,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 7,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "You’ll Shortly receive an email with link to verify your email.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Source Sans Pro',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 15,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ButtonStyle(
                  enableFeedback: false,
                  backgroundColor: MaterialStateProperty.all(Colors.black),
                  overlayColor: MaterialStateProperty.all(Colors.white12),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
                child: const Text(
                  "Done",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
