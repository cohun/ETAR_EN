import 'package:etar_en/app/home/logs/shift_inspection_page.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'op_doc_second_page.dart';

class LogBook extends StatefulWidget {
  const LogBook({
    Key key,
    @required this.uid,
    this.name,
    this.productId,
    this.company,
    this.database,
    this.role,
  }) : super(key: key);
  final String uid;
  final String name;
  final String productId;
  final String company;
  final Database database;
  final String role;

  @override
  _LogBookState createState() => _LogBookState();
}

class _LogBookState extends State<LogBook> {
  int _value = 1;
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
        backgroundColor: Colors.deepOrange[900],
        title: Text(
          'Emelőgép Napló',
          style: TextStyle(color: Colors.white70, fontSize: 19),
        ),
      ),
      body: FutureBuilder(
        future: widget.database
            .retrieveProductFromId(widget.company, widget.productId),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            return PageView(
              controller: _controller,
              children: [
                SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {
                                _controller.jumpToPage(1);
                              },
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                child: DropdownButton(
                                    iconEnabledColor: Colors.deepOrange[300],
                                    value: _value,
                                    items: [
                                      DropdownMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.person_add_sharp,
                                              color: _value == 1
                                                  ? Colors.deepOrange[300]
                                                  : null,
                                            ),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            Text(
                                              'Bejegyzésre jogosultak',
                                              style: _value == 1
                                                  ? TextStyle(
                                                      color: Colors
                                                          .deepOrange[300])
                                                  : null,
                                            ),
                                          ],
                                        ),
                                        value: 1,
                                      ),
                                      DropdownMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.message,
                                              color: _value == 2
                                                  ? Colors.deepOrange[300]
                                                  : null,
                                            ),
                                            SizedBox(
                                              width: 16,
                                            ),
                                            Text(
                                              "Napló bejegyzések",
                                              style: _value == 2
                                                  ? TextStyle(
                                                      color: Colors
                                                          .deepOrange[300])
                                                  : null,
                                            ),
                                          ],
                                        ),
                                        value: 2,
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value;
                                      });
                                    }),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _controller.jumpToPage(_value);
                              },
                              icon: Icon(
                                Icons.arrow_forward,
                                size: 30,
                                color: Colors.deepOrange[300],
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Text(
                          'Üzemeltetői adatok:',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.18,
                          child: SingleChildScrollView(
                            child: Card(
                              color: Colors.deepOrange[900],
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
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
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'Emelőgép fö műszaki adatai:',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: SingleChildScrollView(
                            child: Card(
                              color: Colors.teal[900],
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
                                      SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SecondPage(
                  controller: _controller,
                  snapshot: snapshot,
                  company: widget.company,
                  productId: widget.productId,
                  database: widget.database,
                ),
                ShiftInspection(
                  controller: _controller,
                  snapshot: snapshot,
                  name: widget.name,
                  company: widget.company,
                  productId: widget.productId,
                  database: widget.database,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
