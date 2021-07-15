import 'package:etar_en/app/home/users/assigned_products_page.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OpDoc extends StatefulWidget {
  const OpDoc({
    Key key,
    @required this.uid,
    this.productId,
    this.company,
    this.database,
    this.role,
  }) : super(key: key);
  final String uid;
  final String productId;
  final String company;
  final Database database;
  final String role;

  @override
  _OpDocState createState() => _OpDocState();
}

class _OpDocState extends State<OpDoc> {
  PageController _controller = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        backgroundColor: Colors.blueAccent[700],
        title: Text(
          'Üzemviteli dokumentáció',
          style: TextStyle(color: Colors.black87),
        ),
      ),
      body: widget.role == 'admin'
          ? Container(
              child: AssignedProductsPage(
                company: widget.company,
                uid: widget.uid,
                database: widget.database,
              ),
            )
          : FutureBuilder(
              future: widget.database
                  .retrieveProductFromId(widget.company, widget.productId),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return PageView(
                    controller: _controller,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Emelőgép fö műszaki adatai:',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            SizedBox(
                              height: 24,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: Card(
                                color: Colors.teal,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    'Besorolás : ${snapshot.data.productGroup}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Típus : ${snapshot.data.type}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Megnevezés : ${snapshot.data.description}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Teherbírás : ${snapshot.data.capacity}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Hossz : ${snapshot.data.length}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Gyártó : ${snapshot.data.manufacturer}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Gyáriszám : ${snapshot.data.identifier}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Gyártási év : ${snapshot.data.productionDate}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Extra azonosító : ${snapshot.data.extraNr}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'NFC kód : ${snapshot.data.nfc}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                          'Üzemeltető : ${snapshot.data.company}',
                                          textAlign: TextAlign.center,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        Text(
                                          'Üzemeltetési helyszín : ${snapshot.data.site}',
                                          textAlign: TextAlign.center,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        Text(
                                          'Megbízott felelős : ${snapshot.data.person}',
                                          textAlign: TextAlign.center,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 32,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _controller.jumpToPage(1);
                                          },
                                          icon: Icon(
                                            Icons.arrow_forward,
                                            size: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Emelőgép fö műszaki adatai:',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Card(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    'Besorolás : ${snapshot.data.productGroup}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Típus : ${snapshot.data.type}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Megnevezés : ${snapshot.data.description}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Teherbírás : ${snapshot.data.capacity}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Hossz : ${snapshot.data.length}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Gyártó : ${snapshot.data.manufacturer}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Gyáriszám : ${snapshot.data.identifier}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Gyártási év : ${snapshot.data.productionDate}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'Extra azonosító : ${snapshot.data.extraNr}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                    'NFC kód : ${snapshot.data.nfc}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Divider(
                                    thickness: 2,
                                  ),
                                  Text(
                                          'Üzemeltető : ${snapshot.data.company}',
                                          textAlign: TextAlign.center,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        Text(
                                          'Üzemeltetési helyszín : ${snapshot.data.site}',
                                          textAlign: TextAlign.center,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        Text(
                                          'Megbízott felelős : ${snapshot.data.person}',
                                          textAlign: TextAlign.center,
                                        ),
                                        Divider(
                                          thickness: 2,
                                        ),
                                        SizedBox(
                                          height: 32,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                _controller.jumpToPage(0);
                                              },
                                              icon: Icon(
                                                Icons.arrow_back,
                                                size: 50,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _controller.jumpToPage(1);
                                              },
                                              icon: Icon(
                                                Icons.arrow_forward,
                                                size: 50,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
