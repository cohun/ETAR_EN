import 'package:etar_en/app/models/identifier_model.dart';
import 'package:etar_en/app/models/product_model.dart';
import 'package:etar_en/services/database.dart';
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

              final List<Widget> children = identifiers
                  .map((id) => Text(id.identifier.toString()))
                  .toList();
              return ListView.builder(
                  itemCount: identifiers.length,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future: _submit(identifiers[index].identifier),
                      builder: (BuildContext context, snapshot) {
                        if(snapshot.hasData){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }else{
                            return ListTile(
                               trailing: InkWell(
                                   child: Icon(Icons.delete, color: Colors.red,),
                                 onTap: () {print('delete ${identifiers[index].identifier}');},
                               ),
                               subtitle: Text('gyári szám: ${identifiers[index].identifier}',
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
                        }else if (snapshot.hasError){
                          return Text('no data');
                        }
                        return Container(height: 0,);
                      }
                    );
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
