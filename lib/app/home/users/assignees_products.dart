import 'package:etar_en/app/models/assignees_model.dart';
import 'package:etar_en/app/models/product_model.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

class AssigneesProducts extends StatefulWidget {
  const AssigneesProducts({Key key, this.database, this.company, this.onSelect})
      : super(key: key);

  final Database database;
  final String company;
  final Function onSelect;

  @override
  _AssigneesProductsState createState() => _AssigneesProductsState();
}

class _AssigneesProductsState extends State<AssigneesProducts> {
  List<Assignees> assignees = [];
  List<ProductModel> products = [];
  bool isR = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: Text('Emelőgép lista'),
        centerTitle: true,
        elevation: 10.0,
        backgroundColor: Colors.teal[800],
      ),
      body: _buildContents(context),
    );
  }

  _buildContents(BuildContext context) {
    return _buildProductsStream();
  }

  StreamBuilder<List<ProductModel>> _buildProductsStream() {
    return StreamBuilder(
      stream: widget.database.productStream(widget.company),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          products = snapshot.data;
          return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildAssigneesStream(index);
              });
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Nem sikerült!'),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  StreamBuilder<List<Assignees>> _buildAssigneesStream(int index) {
    return StreamBuilder(
      stream: widget.database
          .assigneesStream(widget.company, products[index].identifier),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data.isEmpty)
              return Container(
                height: 0,
              );

            return ListTile(
              onTap: () {
                Navigator.of(context).pop();
                return widget.onSelect(
                    products[index].type, products[index].identifier);
              },
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: snapshot.data.isNotEmpty
                    ? Text(
                        '${products[index].type} ${products[index].length} ${products[index].capacity}'
                        ' ${products[index].description}',
                        style: TextStyle(color: Colors.indigo[900]),
                      )
                    : Text(''),
              ),
              subtitle: Text(
                'gy.sz.: ${products[index].identifier}',
                style: TextStyle(color: Colors.indigo[900]),
              ),
            );
          }
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Nem sikerült!'),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
