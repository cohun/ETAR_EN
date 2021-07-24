import 'package:etar_en/app/home/logs/classification_periodical_controlling.dart';
import 'package:etar_en/app/home/logs/operation_data_page.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'op_doc_second_page.dart';

class OpDoc extends StatefulWidget {
  const OpDoc({
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
  _OpDocState createState() => _OpDocState();
}

class _OpDocState extends State<OpDoc> {
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
        backgroundColor: Colors.blue[900],
        title: Text(
          'Üzemviteli dokumentáció',
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
                                  iconEnabledColor: Colors.amber,
                                    value: _value,
                                    items: [
                                      DropdownMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(Icons.person_add_sharp, color: Colors.amber,),
                                            SizedBox(width: 16,),
                                            Text(
                                              'Bejegyzésre jogosultak',
                                              style: TextStyle(color: Colors.amber),
                                            ),
                                          ],
                                        ),
                                        value: 1,
                                      ),
                                      DropdownMenuItem(
                                        child: Row(
                                          children: [
                                            Icon(Icons.approval, color: Colors.amber,),
                                            SizedBox(width: 16,),
                                            Text("Vizsgálati csoportszám",
                                                style: TextStyle(color: Colors.amber),
                                            ),
                                          ],
                                        ),
                                        value: 2,
                                      ),
                                      DropdownMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(Icons.article_outlined, color: Colors.amber,),
                                              SizedBox(width: 16,),
                                              Text("Üzemeltetésre vonatkozó adatok",
                                                style: TextStyle(color: Colors.amber),
                                              ),
                                            ],
                                          ), value: 3),
                                      DropdownMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(Icons.six_ft_apart_outlined, color: Colors.amber,),
                                              SizedBox(width: 16,),
                                              Text("Cserélt fő darabok. részegységek",
                                                style: TextStyle(color: Colors.amber),
                                              ),
                                            ],
                                          ), value: 4),
                                      DropdownMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(Icons.bolt, color: Colors.amber,),
                                              SizedBox(width: 16,),
                                              Text("Érintésvédelem",
                                                style: TextStyle(color: Colors.amber),
                                              ),
                                            ],
                                          ), value: 5),
                                      DropdownMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(Icons.assignment_turned_in_outlined, color: Colors.amber,),
                                              SizedBox(width: 16,),
                                              Text("Időszakos vizsgálatok",
                                                style: TextStyle(color: Colors.amber),
                                              ),
                                            ],
                                          ), value: 6),
                                      DropdownMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(Icons.monitor_weight, color: Colors.amber,),
                                              SizedBox(width: 16,),
                                              Text("Terhelési próba",
                                                style: TextStyle(color: Colors.amber),
                                              ),
                                            ],
                                          ), value: 7),
                                      DropdownMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(Icons.view_stream_sharp, color: Colors.amber,),
                                              SizedBox(width: 16,),
                                              Text("Egyenértékű biztonság igazolása",
                                                style: TextStyle(color: Colors.amber),
                                              ),
                                            ],
                                          ), value: 8),
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
                                color: Colors.amber,
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
                              color: Colors.blue[900],
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
                              color: Colors.teal[800],
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
                Classification(
                  controller: _controller,
                  snapshot: snapshot,
                  name: widget.name,
                  company: widget.company,
                  productId: widget.productId,
                  database: widget.database,
                ),
                Operation(
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
