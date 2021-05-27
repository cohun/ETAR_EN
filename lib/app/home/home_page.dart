import 'package:etar_en/app/home/log_book.dart';
import 'package:etar_en/app/home/op_doc.dart';
import 'package:etar_en/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  _showOpDoc(BuildContext context, String uid) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => OpDoc(uid: uid),
    ),
    );
  }
  _showLogBook(BuildContext context, String uid) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LogBook(uid: uid),
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _signOut() async {
      try {
        await widget.auth.signOut();
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            'images/ETAR_EN_flat_small.png',
            height: 50,
          ),
          actions: [
            TextButton(
              onPressed: () => _showCupertinoDialog(context),
              child: Text('Logout'),
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Image.asset(
                  'images/LE_Doc.png',
                  height: 50,
                ),
                child: Text(
                  'Üzemviteli Dokumentáció',
                  style: TextStyle(fontSize: 7, color: Colors.blueAccent[700]),
                ),
              ),
              Tab(
                icon: Image.asset(
                  'images/logBookIcon.png',
                  height: 50,
                ),
                child: Text(
                  'Emelőgép Napló',
                  style: TextStyle(fontSize: 7, color: Colors.yellow[900]),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 1.1,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Views(
                        color: Colors.blueAccent[700],
                          text1: 'ÜZEMVITELI DOKUMENTÁCIÓ:',
                          text2:
                              'Gépi hajtású emelőgépek kísérő dokumentációja MSZ 9725 szerint.'
                              'Gépi hajtású targoncáknál MSZ 16226 szerint',
                          text3:
                              'Emelőgépek üzembehelyezésekor emelőgépenként, egyedileg kezelhető kisérő dokumentációt kell lefektetni. '
                              'Meg kell adni a főbb műszaki jellemzőket és az üzemvitellel kapcsolatos adatokat. '
                              'Nyilván kell tartani az időszakos vizsgálatokat, javításokat, fődarab cseréket és működési időt'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                    InkWell(
                      child: Image.asset('images/image.jpg'),
                      onTap: () => _showOpDoc(context, widget.auth.currentUser.uid),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 1.1,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Views(
                        color: Colors.yellow[900],
                          text1: 'EMELŐGÉP NAPLÓ:',
                          text2:
                              'Teher emeléséhez használt munkaeszközhöz naplót kell rendszeresíteni: 10/2016. (IV.5) NGM rendelet ',
                          text3:
                              'Az emelőgép napló az emelőgéppel kapcsolatos üzemeltetői tapasztalatok és üzembiztonsággal kapcsolatos események '
                              'rögzítésére valamint e feljegyzések megőrzésére szolgál. '),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                    InkWell(
                      child: Image.asset('images/image.jpg'),
                      onTap: () => _showLogBook(context, widget.auth.currentUser.uid),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Views extends StatelessWidget {
  const Views({
    Key key,
    this.text1,
    this.text2,
    this.text3,
    this.color,
  }) : super(key: key);
  final String text1;
  final String text2;
  final String text3;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        Text(
          'ETAR_EN®️ bejegyzések',
          style: TextStyle(color: Colors.teal),
        ),
        SizedBox(
          height: 10.0,
        ),
        Divider(
          height: 20.0,
        ),
        Text(
          text1,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: color),
        ),
        Divider(
          height: 20.0,
        ),
        SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Text(
            text2,
            style: TextStyle(
              fontSize: 15.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, right: 4.0),
          child: Text(
            text3,
            style: TextStyle(
              fontSize: 15.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
