import 'package:etar_en/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  Widget build(BuildContext context) {
    Future<void> _signOut() async {
      try {
        await auth.signOut();
      } catch (e) {
        print(e.toString());
      }
    }

    _showCupertinoDialog(BuildContext context) {
      showDialog(
          context: context,
          builder: (_) => new CupertinoAlertDialog(
                title: new Text("Kijelentkezés"),
                content: new Text(
                    "A program funkciói csak bejelentkezett állapotban érhetőek el!"),
                actions: <Widget>[
                  TextButton(
                    child: Text('Mégsem!'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Kijelentkezés!'),
                    onPressed: () {
                      _signOut();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Napló bejegyzések'),
        actions: [
          TextButton(
            onPressed: () => _showCupertinoDialog(context),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}
