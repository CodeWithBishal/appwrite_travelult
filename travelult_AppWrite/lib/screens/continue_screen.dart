import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelult/screens/login_screen.dart';
import 'package:travelult/screens/signup_screen.dart';
import 'package:travelult/widgets/loading.dart';
import 'package:travelult/widgets/responsive_widget.dart';
import 'package:travelult/widgets/snacbar.dart';

import '../backend/authentication.dart';

class ContinuePage extends StatefulWidget {
  const ContinuePage({Key? key}) : super(key: key);

  @override
  State<ContinuePage> createState() => _ContinuePageState();
}

class _ContinuePageState extends State<ContinuePage> {
  late Image googlePicture;

  late bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      googlePicture = Image.asset(
        "assets/g-logo/g-logo.png",
      );
    }
  }

  @override
  void didChangeDependencies() {
    precacheImage(googlePicture.image, context);
    super.didChangeDependencies();
  }

  signInWithProvider(String provider) {
    try {
      setState(() {
        _isLoading = true;
      });
      context.read<AuthAPI>().googleSignInProvider(provider);
      setState(() {
        _isLoading = false;
      });
    } on AppwriteException catch (e) {
      flutterToast(e.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const LoadingWidget()
          : SafeArea(
              child: Container(
                color: const Color.fromRGBO(255, 255, 255, 1),
                child: ResponsiveWidget(
                  mobile: _continueScreenforAndroid(context),
                  desktop: _continueScreenforWeb(context),
                ),
              ),
            ),
    );
  }

// For large display or desktop website
  Widget _continueScreenforWeb(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width / 2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: width,
          child: Image.asset(
            "assets/logos/main-logo.png",
            width: width,
          ), //TODOO
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'The Ultimate Travel', //TODOO
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Source Sans Pro',
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Management app', //TODOO
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontFamily: 'Source Sans Pro',
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Manage all of your trips in one place.", //TODOO
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Source Sans Pro',
                fontSize: 24,
                fontWeight: FontWeight.w100,
              ),
            ),
            SizedBox(
              height: height / 10,
            ),
            SizedBox(
              width: width / 1.5,
              height: height / 12,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignupPage(),
                    ),
                  );
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
                  "Sign Up with Email ID",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 100,
            ),
            SizedBox(
              width: width / 1.5,
              height: height / 12,
              child: TextButton.icon(
                icon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: googlePicture,
                ),
                onPressed: () {
                  signInWithProvider("google");
                },
                style: ButtonStyle(
                  enableFeedback: false,
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  overlayColor: MaterialStateProperty.all(Colors.black12),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                label: const Text(
                  "Continue with Google",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height / 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an Account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontFamily: 'Source Sans Pro',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    enableFeedback: false,
                  ),
                  child: const Text(
                    "Sign in",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Source Sans Pro',
                    ),
                  ),
                ),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _continueScreenforAndroid(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: height / 50,
        ),
        SizedBox(
          width: width,
          height: height / 2.5,
          child: Image.asset(
            "assets/logos/main-logo.png",
            width: width / 2,
          ), //TODOO
        ),
        const Text(
          'The Ultimate Travel Management app', //TODOO
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromRGBO(0, 0, 0, 1),
            fontFamily: 'Source Sans Pro',
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          "Manage all of your trips in one place.", //TODOO
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Source Sans Pro',
            fontSize: 24,
            fontWeight: FontWeight.w100,
          ),
        ),
        SizedBox(
          height: height / 10,
        ),
        SizedBox(
          width: width - width / 15,
          height: height / 15,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignupPage(),
                ),
              );
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
              "Sign Up with Email ID",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        SizedBox(
          height: height / 100,
        ),
        SizedBox(
          width: width - width / 15,
          height: height / 15,
          child: TextButton.icon(
            icon: Image.asset(
              "assets/g-logo/g-logo.png",
            ),
            onPressed: () {
              signInWithProvider("google");
            },
            style: ButtonStyle(
              enableFeedback: false,
              backgroundColor: MaterialStateProperty.all(Colors.white),
              overlayColor: MaterialStateProperty.all(Colors.black12),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                  side: const BorderSide(color: Colors.black),
                ),
              ),
            ),
            label: const Text(
              "Continue with Google",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
        SizedBox(
          height: height / 50,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Already have an Account?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontFamily: 'Source Sans Pro',
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                enableFeedback: false,
              ),
              child: const Text(
                "Sign in",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Source Sans Pro',
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
