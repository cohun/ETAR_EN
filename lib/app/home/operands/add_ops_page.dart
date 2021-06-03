import 'package:flutter/material.dart';

class AddOpPage extends StatefulWidget {
  const AddOpPage({Key key}) : super(key: key);

  static Future<void> show(BuildContext context) async {}

  @override
  _AddOpPageState createState() => _AddOpPageState();
}

class _AddOpPageState extends State<AddOpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text('Adatok felvitele'),
      ),
    );
  }
}
