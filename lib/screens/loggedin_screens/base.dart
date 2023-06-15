import 'package:flutter/material.dart';
import 'package:travelult/widgets/bottom_navigation.dart';

class BaseScreens extends StatefulWidget {
  const BaseScreens({Key? key}) : super(key: key);

  @override
  State<BaseScreens> createState() => _BaseScreensState();
}

class _BaseScreensState extends State<BaseScreens> {
  @override
  Widget build(BuildContext context) {
    return const ButtomNavigationScreens();
  }
}
