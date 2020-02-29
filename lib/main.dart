import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:metube/screens/home.screen.dart';
import 'package:metube/utils/service_locator.dart';

GetIt getIt = GetIt.instance;

void main() {
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MeTube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}
