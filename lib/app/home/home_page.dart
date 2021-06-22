import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/home/log_book.dart';
import 'package:etar_en/app/home/op_doc.dart';
import 'package:etar_en/app/home/operands/add_ops_page.dart';
import 'package:etar_en/app/home/operands/show_operands_companies.dart';
import 'package:etar_en/app/home/users/users_page.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/app/models/user_model.dart';
import 'package:etar_en/services/auth.dart';
import 'package:etar_en/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../dialogs/show_alert_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _showOpDoc(BuildContext context, String uid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OpDoc(uid: uid),
      ),
    );
  }

  _showLogBook(BuildContext context, String uid) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LogBook(uid: uid),
      ),
    );
  }

  int _selectedIndex = 1;
  String _selectedCompany = 'Cég';

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSelectCompany(String selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
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

    final database = Provider.of<Database>(context, listen: false);
    var _isEmpty = true;
    Operand operands;
    UserModel user;

    return DefaultTabController(
      length: 2,
      child: _buildOperands(
          database, _isEmpty, operands, _showCupertinoDialog, user),
    );
  }

  FutureBuilder<DocumentSnapshot<Object>> _buildOperands(
      Database database,
      bool _isEmpty,
      Operand operands,
      Null _showCupertinoDialog(BuildContext context),
      UserModel user
      ) {
    database.getUser(widget.auth.currentUser.uid).then((value) {
      if (value.exists)
        user = UserModel.fromMap(value.data());
      if (user != null)
      print('hey ${user.approvedRole}');
    });

    return FutureBuilder<DocumentSnapshot>(
      future: database.getOperand(widget.auth.currentUser.uid),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          _isEmpty = true;
        }

        if (snapshot.connectionState == ConnectionState.done) {
          final Map<String, dynamic> operand = snapshot.data.data();
          operands = Operand.fromMap(operand);
          operands != null ? _isEmpty = false : _isEmpty = true;

          return Scaffold(
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
              bottom: _selectedIndex == 1
                  ? TabBar(
                      tabs: [
                        Tab(
                          icon: Image.asset(
                            'images/LE_Doc.png',
                            height: 50,
                          ),
                          child: Text(
                            'Üzemviteli Dokumentáció',
                            style: TextStyle(
                                fontSize: 7, color: Colors.blueAccent[700]),
                          ),
                        ),
                        Tab(
                          icon: Image.asset(
                            'images/logBookIcon.png',
                            height: 50,
                          ),
                          child: Text(
                            'Emelőgép Napló',
                            style: TextStyle(
                                fontSize: 7, color: Colors.yellow[900]),
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            body: _selectedIndex == 1
                ? TabBarView(
                    children: [
                      SingleChildScrollView(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 1.1,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
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
                                height:
                                    MediaQuery.of(context).size.height * .04,
                              ),
                              InkWell(
                                child: Image.asset('images/image.jpg'),
                                onTap: () => _showOpDoc(
                                    context, widget.auth.currentUser.uid),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .04,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
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
                                height:
                                    MediaQuery.of(context).size.height * .04,
                              ),
                              InkWell(
                                child: Image.asset('images/image.jpg'),
                                onTap: () => _showLogBook(
                                    context, widget.auth.currentUser.uid),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .04,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : user != null ?
            UsersPage(company: user.company, database: database,):
            ShowOperandsCompanies(
                    operand: operands,
                    onSelect: _onSelectCompany,
                    database: database,
                  ),
            bottomNavigationBar: _buildNavigationBar(context, _isEmpty,
                operands, _selectedIndex, _onItemTapped, _selectedCompany, user),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: _isEmpty
                ? FloatingActionButton(
                    onPressed: () => AddOpPage.show(context),
                    backgroundColor: Colors.red[600],
                    child: Icon(Icons.add),
                  )
                : null,
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

Widget _buildNavigationBar(BuildContext context, bool isEmpty, Operand operands,
    int _selectedIndex, Function _onItemTapped, String _selectedCompany, UserModel user) {
  if (isEmpty) {
    return BottomAppBar(
      color: Colors.indigo[700],
      shape: CircularNotchedRectangle(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 18, 0, 18),
        child: Text(
          "              Bejegyzésre jogosult nevének\n            és bizonyítványainak megadása",
          textAlign: TextAlign.justify,
          style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  } else {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '${operands.name}',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.help),
          label: _selectedCompany == 'Cég' ? '' : 'Dokumentáció',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: user == null ?_selectedCompany : user.approvedRole,
        ),
      ],
      selectedItemColor: Colors.amber[800],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}

Future<void> _createOp(BuildContext context, String uid) async {
  try {
    final database = Provider.of<Database>(context, listen: false);
    await database.createOperand(
      Operand(
        name: 'Attila',
        certificates: [
          {'nr': 'SS2345/99', 'description': 'Nehézgép kezelő'},
          {'nr': 'DAB 234/2001', 'description': 'Emelőgép ügyintéző'}
        ],
        companies: ['first', 'second', 'third'],
        uid: uid,
      ),
    );
  } on FirebaseException catch (e) {
    showAlertDialog(context,
        title: 'Operation failed',
        content: e.toString(),
        defaultActionText: 'OK');
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
              fontWeight: FontWeight.bold, fontSize: 18.0, color: color),
        ),
        Divider(
          height: 20.0,
        ),
        SizedBox(
          height: 15.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: Text(
            text2,
            style: TextStyle(
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: Text(
            text3,
            style: TextStyle(
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
