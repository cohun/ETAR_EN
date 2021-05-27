import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogBook extends StatelessWidget {
  const LogBook({Key key, @required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text('Emelőgép Napló'),
      ),
      body: Center(
        child: Text(uid),
      ),
    );
  }
}
