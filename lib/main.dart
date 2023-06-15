import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:travelult/backend/authentication.dart';
import 'package:travelult/hive_boxes.dart';
import 'package:travelult/models/alltrip.dart';
import 'package:travelult/screens/continue_screen.dart';
import 'package:travelult/screens/loggedin_screens/base.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TripAdapter());
  await Hive.openBox<Trip>(HiveBoxes.trip);
  runApp(
    ChangeNotifierProvider(
      create: ((create) => AuthAPI()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authStatus = context.watch<AuthAPI>().status;
    return MaterialApp(
      title: 'Travel Ult',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: authStatus == AuthStatus.authenticated
          ? const BaseScreens()
          : const ContinuePage(),
    );
  }
}
