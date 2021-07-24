import 'package:flutter/material.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
    this.title = 'Nincs még bejegyzés',
    this.message = 'Nyomj a + gombra új bejegyzés indításához',
  }) : super(key: key);
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 32.0, color: Colors.white70),
          ),
          Text(
            message,
            style: TextStyle(fontSize: 16.0, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
