import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/home/logs/empty_content.dart';
import 'package:etar_en/app/home/logs/log_book.dart';
import 'package:etar_en/app/home/logs/op_doc.dart';
import 'package:etar_en/app/home/operands/add_ops_page.dart';
import 'package:etar_en/app/home/operands/show_operands_companies.dart';
import 'package:etar_en/app/home/persons/persons_page.dart';
import 'package:etar_en/app/home/users/assignees_products.dart';
import 'package:etar_en/app/home/users/users_page.dart';
import 'package:etar_en/app/models/operand_model.dart';
import 'package:etar_en/app/models/user_model.dart';
import 'package:etar_en/services/auth.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _showOpDoc(BuildContext context, String uid, Operand operands) {
    final database = Provider.of<Database>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _id == ''
            ? Scaffold(
                appBar: AppBar(),
                body: EmptyContent(
                  title: 'nincs emelőgép kiválasztva',
                  message: 'Válassz ki előbb egy emelőgépet',
                ),
              )
            : OpDoc(
                uid: uid,
                name: _user != null ? _user.name : operands.name,
                productId: _id,
                database: database,
                company: _user != null ? _user.company : _selectedCompany,
                role: _role,
              ),
      ),
    );
  }

  _showLogBook(BuildContext context, String uid, Operand operands) {
    final database = Provider.of<Database>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _id == ''
            ? Scaffold(
                appBar: AppBar(),
                body: EmptyContent(
                  title: 'nincs emelőgép kiválasztva',
                  message: 'Válassz ki előbb egy emelőgépet',
                ),
              )
            : LogBook(
                uid: uid,
                name: _user != null ? _user.name : operands.name,
                productId: _id,
                database: database,
                company: _user != null ? _user.company : _selectedCompany,
                role: _role,
              ),
      ),
    );
  }

  int _selectedIndex = 1;
  String _selectedCompany = 'Cég';
  String _role = 'függőben';
  String _selectedType = '';
  String _id = "";
  UserModel _user;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onSelectCompany(String selectedCompany, String role) {
    setState(() {
      _selectedCompany = selectedCompany;
      _role = role;
    });
  }

  void _onSelectItem(String type, String id) {
    setState(() {
      _selectedType = type;
      _id = id;
      _selectedIndex = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    final database = Provider.of<Database>(context, listen: false);
    database.getUser(widget.auth.currentUser.uid).then((value) {
      if (value.exists) _user = UserModel.fromMap(value.data());
      if (_user != null) {
        _role = 'admin';
      }
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

    return DefaultTabController(
      length: 2,
      child: _buildOperands(database, _isEmpty, operands, _showCupertinoDialog),
    );
  }

  FutureBuilder<DocumentSnapshot<Object>> _buildOperands(
    Database database,
    bool _isEmpty,
    Operand operands,
    Null _showCupertinoDialog(BuildContext context),
  ) {
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
          if (_user != null) _isEmpty = true;

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
            body: _selectedIndex == 0
                ? PersonsPage(
                    database: database,
                    uid: _user != null ? _user.uid : operands.uid,
                    admin: _user != null ? true : false,
                  )
                : _selectedIndex == 1
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
                                        color: Colors.blue,
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
                                    height: MediaQuery.of(context).size.height *
                                        .04,
                                  ),
                                  InkWell(
                                    child: Image.asset('images/image.jpg'),
                                    onTap: () => _showOpDoc(context,
                                        widget.auth.currentUser.uid, operands),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .04,
                                  ),
                                  _user != null
                                      ? ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.blue[800]),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AssigneesProducts(
                                                        database: database,
                                                        company: _user.company,
                                                        onSelect: _onSelectItem,
                                                      )),
                                            );
                                          },
                                          child: Text('Emelőgép kiválasztása'),
                                        )
                                      : Container(
                                          height: 0,
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
                                        color: Colors.orange[800],
                                        text1: 'EMELŐGÉP NAPLÓ:',
                                        text2:
                                            'Teher emeléséhez használt munkaeszközhöz naplót kell rendszeresíteni: 10/2016. (IV.5) NGM rendelet ',
                                        text3:
                                            'Az emelőgép napló az emelőgéppel kapcsolatos üzemeltetői tapasztalatok és üzembiztonsággal kapcsolatos események '
                                            'rögzítésére valamint e feljegyzések megőrzésére szolgál. '),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .04,
                                  ),
                                  InkWell(
                                    child: Image.asset('images/image.jpg'),
                                    onTap: () => _showLogBook(context,
                                        widget.auth.currentUser.uid, operands),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .04,
                                  ),
                                  _user != null
                                      ? ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AssigneesProducts(
                                                        database: database,
                                                        company: _user.company,
                                                        onSelect: _onSelectItem,
                                                      )),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.orange[900]),
                                          child: Text(
                                            'Emelőgép kiválasztása',
                                          ),
                                        )
                                      : Container(
                                          height: 0,
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    : _user != null
                        ? UsersPage(
                            company: _user.company,
                            database: database,
                          )
                        : ShowOperandsCompanies(
                            operand: operands,
                            onSelect: _onSelectCompany,
                            database: database,
                            selectedCompany: _selectedCompany,
                            onItemSelect: _onSelectItem,
                          ),
            bottomNavigationBar: _buildNavigationBar(
                context,
                _isEmpty,
                operands,
                _selectedIndex,
                _onItemTapped,
                _selectedCompany,
                _role,
                _user),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: _isEmpty && _role == 'függőben'
                ? FloatingActionButton(
                    onPressed: () => AddOpPage.show(
                            context, widget.auth.currentUser.uid, database)
                        .then((value) => setState(() {})),
                    backgroundColor: Colors.red[600],
                    child: Icon(Icons.add),
                  )
                : null,
            bottomSheet: _role == 'függőben'
                ? null
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Típus:',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        ' $_selectedType, ',
                        style: TextStyle(color: Colors.green, fontSize: 11),
                      ),
                      Text(
                        'gy.sz.:',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        ' $_id',
                        style: TextStyle(color: Colors.green, fontSize: 11),
                      ),
                    ],
                  ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

Widget _buildNavigationBar(
    BuildContext context,
    bool isEmpty,
    Operand operands,
    int _selectedIndex,
    Function _onItemTapped,
    String _selectedCompany,
    String _role,
    UserModel _user) {
  if (isEmpty && _role == 'függőben') {
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
          label: _user == null ? '${operands.name}' : _user.name,
        ),
        BottomNavigationBarItem(
          icon: _role == 'függőben'
              ? Icon(Icons.help)
              : Icon(Icons.assignment_turned_in_outlined),
          label: _selectedCompany == 'Cég'
              ? _user != null
                  ? _user.company
                  : ''
              : operands.name == null
                  ? 'Dokumentáció'
                  : _role,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.business),
          label: _user == null ? _selectedCompany : _role,
        ),
      ],
      selectedItemColor: _role == 'függőben' ? Colors.red : Colors.green,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
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
