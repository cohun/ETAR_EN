import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpDoc extends StatelessWidget {
  const OpDoc({Key key, @required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.blueAccent[700],
        title: Text('Üzemviteli dokumentáció', style: TextStyle(color: Colors.black87),),
      ),
      body: Center(
        child: Text(uid),
      ),
    );
  }
}
