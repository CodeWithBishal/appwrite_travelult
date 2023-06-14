import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:travelult/backend/authentication.dart';
import 'package:travelult/backend/url_launcher.dart';
import 'package:travelult/screens/loggedin_screens/myacc_profile.dart';
import 'package:travelult/widgets/appbar.dart';
import 'package:travelult/widgets/snacbar.dart';
import 'package:url_launcher/url_launcher.dart';

class MyAccounts extends StatefulWidget {
  const MyAccounts({Key? key}) : super(key: key);

  @override
  State<MyAccounts> createState() => _MyAccountsState();
}

class _MyAccountsState extends State<MyAccounts> {
  late String appVersion = "";
  Future<String> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (!mounted) return "";
    return packageInfo.version;
  }

  @override
  void initState() {
    super.initState();
    init().then((value) {
      setState(() {
        appVersion = value;
      });
    });
  }

  signOut(AuthAPI user) {
    user.logOut();
  }

  @override
  Widget build(BuildContext context) {
    late AuthAPI user = context.read<AuthAPI>();
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width < 768
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 2.5;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: commonAppBar(
        title: "Travel Ult",
        elevation: 5,
        centerTitle: true,
        context: context,
      ),
      body: Center(
        child: RefreshIndicator(
          color: Colors.black,
          onRefresh: () async {
            setState(() {
              user = context.read<AuthAPI>();
            });
          },
          child: ListView(
            children: [
              Container(
                color: Colors.white,
                width: width,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: height / 30,
                    ),
                    Center(
                      child: SizedBox(
                        height: height / 6,
                        width: width / 4,
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFFF6F2D4),
                          radius: 45,
                          child: ClipOval(
                            child: Icon(
                              Icons.person,
                              size: 80,
                              color: Colors.blue.shade200,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 10,
                      child: Text(
                        user.userName!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          fontSize: 30,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        flutterToast("Coming Soon!");
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        enableFeedback: false,
                      ),
                      child: SizedBox(
                        height: height / 10,
                        child: ListTile(
                          leading: Container(
                            color: Colors.grey.shade100,
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.whatshot_outlined,
                                size: 30,
                                color: Color(0xFFF1D00A),
                              ),
                            ),
                          ),
                          title: const Text(
                            "Buy Pro",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyAccProfile(),
                          ),
                        ).then((_) => setState(() {
                              user = context.read<AuthAPI>();
                            }));
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        enableFeedback: false,
                      ),
                      child: SizedBox(
                        height: height / 10,
                        child: ListTile(
                          leading: Container(
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.person,
                                color: Colors.blue.shade200,
                                size: 30,
                              ),
                            ),
                          ),
                          title: const Text(
                            "Profile",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        LaunchUrl.openLink(
                          url:
                              "https://play.google.com/store/apps/dev?id=7467024670640010287",
                          context: context,
                          launchMode: LaunchMode.externalApplication,
                        );
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        enableFeedback: false,
                      ),
                      child: SizedBox(
                        height: height / 10,
                        child: ListTile(
                          leading: Container(
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.more_horiz,
                                color: Colors.blue.shade200,
                                size: 30,
                              ),
                            ),
                          ),
                          title: const Text(
                            "More Apps",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        LaunchUrl.openLink(
                          url:
                              "https://play.google.com/store/apps/details?id=com.codewithbishal.travelult",
                          context: context,
                          launchMode: LaunchMode.externalApplication,
                        );
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        enableFeedback: false,
                      ),
                      child: SizedBox(
                        height: height / 10,
                        child: ListTile(
                          leading: Container(
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.rate_review_outlined,
                                color: Colors.blue.shade200,
                                size: 30,
                              ),
                            ),
                          ),
                          title: const Text(
                            "Rate App",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        LaunchUrl.openLink(
                          url:
                              "https://api.whatsapp.com/send?text=Download%20TravelUlt%20App%20From%20PlayStore%20and%20Start%20Managing%20all%20Your%20Trips%20from%20One%20Place:https://travelult.page.link/app",
                          context: context,
                          launchMode: LaunchMode.externalApplication,
                        );
                        if (!kIsWeb) {
                          Clipboard.setData(
                            const ClipboardData(
                              text: "https://travelult.page.link/app",
                            ),
                          );
                          flutterToast(
                              "The installation URL of the app has been copied to the clipboard.");
                        }
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        enableFeedback: false,
                      ),
                      child: SizedBox(
                        height: height / 10,
                        child: ListTile(
                          leading: Container(
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.share,
                                color: Colors.blue.shade200,
                                size: 30,
                              ),
                            ),
                          ),
                          title: const Text(
                            "Share App",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        LaunchUrl.openLink(
                          url: "https://travelult.com/about",
                          context: context,
                          launchMode: LaunchMode.externalApplication,
                        );
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        enableFeedback: false,
                      ),
                      child: SizedBox(
                        height: height / 10,
                        child: ListTile(
                          leading: Container(
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.info_outline,
                                color: Colors.blue.shade200,
                                size: 30,
                              ),
                            ),
                          ),
                          title: const Text(
                            "About",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        LaunchUrl.openLink(
                          url:
                              "https://codewithbishal.com/contact-us?platform=travel_ult&fullemail=${user.email}&fullname=${user.userName!}",
                          context: context,
                          launchMode: LaunchMode.externalApplication,
                        );
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        enableFeedback: false,
                      ),
                      child: SizedBox(
                        height: height / 10,
                        child: ListTile(
                          leading: Container(
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.contact_support_outlined,
                                color: Colors.blue.shade200,
                                size: 30,
                              ),
                            ),
                          ),
                          title: const Text(
                            "Contact",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        signOut(user);
                      },
                      style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        enableFeedback: false,
                      ),
                      child: SizedBox(
                        height: height / 10,
                        child: ListTile(
                          leading: Container(
                            color: Colors.grey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.logout_outlined,
                                color: Colors.blue.shade200,
                                size: 30,
                              ),
                            ),
                          ),
                          title: const Text(
                            "Log Out",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    // hide if not auth
                    SizedBox(
                      height: appVersion != "" ? height / 30 : 0,
                      child: Center(
                        child: Text(
                          kDebugMode
                              ? "DEV - $appVersion"
                              : "PROD - $appVersion",
                          semanticsLabel: kDebugMode
                              ? "DEV - $appVersion"
                              : "PROD - $appVersion",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: appVersion != "" ? height / 40 : 0,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
