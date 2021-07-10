import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogBook extends StatelessWidget {
  const LogBook({Key key, @required this.uid, this.productId = ''})
      : super(key: key);
  final String uid;
  final String productId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[900],
        title: Text('Emelőgép Napló'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(uid),
            Text(productId),
          ],
        ),
      ),
    );
  }
}
