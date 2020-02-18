import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:metube/screens/home.screen.dart';


GetIt getIt = GetIt.instance;


void main() {
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