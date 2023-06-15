import 'package:flutter/material.dart';
import 'package:travelult/backend/url_launcher.dart';
import 'package:travelult/widgets/appbar.dart';
import 'package:travelult/widgets/buses.dart';
import 'package:travelult/widgets/railway.dart';
import 'package:travelult/widgets/flight.dart';
import 'package:travelult/widgets/hotels.dart';
import 'package:travelult/widgets/loading.dart';
import 'package:url_launcher/url_launcher.dart';

class BookATrip extends StatefulWidget {
  const BookATrip({Key? key}) : super(key: key);

  @override
  State<BookATrip> createState() => _BookATripState();
}

class _BookATripState extends State<BookATrip> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    Hotels(),
    Flight(),
    Railway(),
    Buses()
  ];

  String dropdownValue = 'Hotel';
  final _formKey = GlobalKey<FormState>();

  final bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width < 768
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 3;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isLoading
          ? null
          : commonAppBar(
              title: "Book a Trip",
              elevation: 5,
              centerTitle: true,
              context: context,
            ),
      body: _isLoading
          ? const LoadingWidget()
          : ListView(
              reverse: true,
              primary: false,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: [
                Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: width,
                            child: _widgetOptions.elementAt(_selectedIndex)),
                        SizedBox(
                          width: width - width / 7,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: dropdownValue,
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                  if (dropdownValue == 'Hotel') {
                                    _selectedIndex = 0;
                                  }
                                  if (dropdownValue == 'Flight') {
                                    _selectedIndex = 1;
                                  }
                                  if (dropdownValue == 'Railway') {
                                    _selectedIndex = 2;
                                  }
                                  if (dropdownValue == 'Buses') {
                                    _selectedIndex = 3;
                                  }
                                });
                              },
                              items: <String>[
                                'Hotel',
                                'Flight',
                                'Railway',
                                'Buses',
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: height / 60,
                        ),
                        SizedBox(
                          width: width - width / 15,
                          height: height / 15,
                          child: TextButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                LaunchUrl.openLink(
                                  url: "https://www.makemytrip.com/",
                                  context: context,
                                  launchMode: LaunchMode.externalApplication,
                                );
                              }
                            },
                            style: ButtonStyle(
                              enableFeedback: false,
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.white12),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(9),
                                ),
                              ),
                            ),
                            child: const Text(
                              "Search",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
