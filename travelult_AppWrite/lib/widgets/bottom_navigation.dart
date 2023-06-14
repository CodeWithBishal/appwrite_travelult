import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:travelult/screens/loggedin_screens/add_trip.dart';
import 'package:travelult/screens/loggedin_screens/book_a_trip.dart';
import 'package:travelult/screens/loggedin_screens/home_screen.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:travelult/screens/loggedin_screens/my_account.dart';
import 'package:travelult/widgets/rating.dart';
import 'package:travelult/widgets/snacbar.dart';

class ButtomNavigationScreens extends StatefulWidget {
  const ButtomNavigationScreens({Key? key}) : super(key: key);

  @override
  State<ButtomNavigationScreens> createState() =>
      _ButtomNavigationScreensState();
}

class _ButtomNavigationScreensState extends State<ButtomNavigationScreens> {
  int _selectedIndex = 0;
  DateTime time = DateTime.now();
  late Image logo;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    BookATrip(),
    MyAccounts(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String> init() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  @override
  void initState() {
    logo = Image.asset(
      "assets/logos/main-logo.png",
      height: 200,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(time);
        final exitWarning = difference >= const Duration(seconds: 2);
        time = DateTime.now();
        if (exitWarning) {
          flutterToast("Press back again to exit");
          showRating(context, logo);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        extendBody: true,
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddATrip(),
              ),
            );
          },
          enableFeedback: false,
          tooltip: "Add a Trip",
          backgroundColor: Colors.blue.shade100,
          splashColor: Colors.blue.shade50,
          elevation: 4.0,
          child: const Icon(
            Icons.add,
            color: Colors.black,
            size: 40,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: BottomNavyBar(
            items: <BottomNavyBarItem>[
              BottomNavyBarItem(
                icon: const Icon(
                  Icons.home,
                  // color: Colors.black,
                ),
                title: const Text(
                  "Home",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                inactiveColor: Colors.grey.shade700,
                activeColor: Colors.blue.shade200,
              ),
              BottomNavyBarItem(
                icon: const Icon(
                  Icons.luggage_outlined,
                  // color: Colors.black,
                ),
                title: const Text(
                  "Book a trip",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                inactiveColor: Colors.grey.shade700,
                activeColor: Colors.blue.shade200,
              ),
              BottomNavyBarItem(
                icon: const Icon(
                  Icons.account_circle,
                  // color: Colors.black,
                ),
                title: const Text(
                  'My Account',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                inactiveColor: Colors.grey.shade700,
                activeColor: Colors.blue.shade200,
              ),
            ],
            selectedIndex: _selectedIndex,
            // backgroundColor: Colors.blue.shade100,
            onItemSelected: _onItemTapped,
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }
}
