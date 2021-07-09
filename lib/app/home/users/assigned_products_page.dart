import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etar_en/app/models/identifier_model.dart';
import 'package:etar_en/app/models/product_model.dart';
import 'package:etar_en/dialogs/show_alert_dialog.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AssignedProductsPage extends StatefulWidget {
  const AssignedProductsPage({Key key, this.database, this.company, this.uid})
      : super(key: key);
  final Database database;
  final String company;
  final String uid;

  @override
  _AssignedProductsPageState createState() => _AssignedProductsPageState();
}

class _AssignedProductsPageState extends State<AssignedProductsPage> {
  List<ProductModel> productResult = [];

  Future<List<ProductModel>> _submit(String productId) async {
    try {
      ProductModel product;
      await widget.database
          .retrieveProductFromId(widget.company, productId)
          .then((value) => product = value);
      if (product != null) {
        productResult.add(product);
        return productResult;
      }
    } on PlatformException catch (e) {
      print(e);
    }
    return null;
  }

  _showCupertinoDialog(
      BuildContext context, String id, String company, String uid) {
    showDialog(
      context: context,
      builder: (_) => new CupertinoAlertDialog(
        title: new Text("Kijelölt tétel törlése"),
        content:
            new Text("Törlés után adott felhasználó hozzáférése megszűnik"),
        actions: <Widget>[
          TextButton(
            child: Text('Mégsem!'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Törlés!'),
            onPressed: () {
              _deleteId(context, id, company, uid);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _deleteId(
      BuildContext context, String id, String company, String uid) async {
    try {
      await widget.database.deleteId(
        id,
        company,
        uid,
      );
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      showAlertDialog(context,
          title: 'Operation failed',
          content: e.toString(),
          defaultActionText: 'OK');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 2000,
        child: StreamBuilder<List<Identifier>>(
          stream: widget.database.identifiersStream(widget.uid, widget.company),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final identifiers = snapshot.data;
              identifiers.map((id) => Text(id.identifier.toString())).toList();
              return ListView.builder(
                  itemCount: identifiers.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                        future: _submit(identifiers[index].identifier),
                        builder: (BuildContext context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ListTile(
                                trailing: InkWell(
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onTap: () {
                                    _showCupertinoDialog(
                                        context,
                                        identifiers[index].identifier,
                                        widget.company,
                                        widget.uid);
                                  },
                                ),
                                subtitle: Text(
                                  'gyári szám: ${identifiers[index].identifier}',
                                  style: TextStyle(color: Colors.indigo[900]),
                                ),
                                title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    '${productResult[index].type}  ${productResult[index].length}  ${productResult[index].description}',
                                    style: TextStyle(color: Colors.indigo[900]),
                                  ),
                                ),
                              );
                            }
                          } else if (snapshot.hasError) {
                            return Text('no data');
                          }
                          return Container(
                            height: 0,
                          );
                        });
                  });
              // return ListView(children: children,);
            }
            print('2');
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
