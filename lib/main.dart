import 'package:etar_en/app/landing_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emelőgép üzemvitel',
      theme: ThemeData.dark(),
      home: LandingPage(),
    );
  }
}
