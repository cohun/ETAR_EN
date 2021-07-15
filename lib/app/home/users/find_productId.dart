import 'package:etar_en/app/home/users/assigned_products_page.dart';
import 'package:etar_en/services/database.dart';
import 'package:flutter/material.dart';

import 'find_product_page.dart';

class FindProductId extends StatefulWidget {
  FindProductId(
      {Key key,
      this.operandsName,
      this.company,
      this.role,
      this.database,
      this.uid})
      : super(key: key);
  final String operandsName;
  final String uid;
  final String company;
  final String role;
  final Database database;

  @override
  _FindProductIdState createState() => _FindProductIdState();
}

class _FindProductIdState extends State<FindProductId> {
  String _role;
  bool _showList = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        title: !_showList
            ? Text('További emelőgép hozzáadása')
            : Text('Emelőgép lista'),
        centerTitle: true,
        elevation: 10.0,
        backgroundColor: Colors.teal[800],
      ),
      body: _buildContents(context),
      floatingActionButton: _showList
          ? FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              onPressed: () {
                setState(() {
                  _showList = false;
                });
              },
            )
          : null,
    );
  }

  _buildContents(BuildContext context) {
    _convertRole(widget.role);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.company} ',
                style: TextStyle(color: Colors.teal[900]),
                textAlign: TextAlign.center,
              ),
              Text(
                ' ${widget.operandsName} ',
                style: TextStyle(color: Colors.red[900]),
                textAlign: TextAlign.center,
              ),
              Text(
                ' részére',
                style: TextStyle(color: Colors.teal[900]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Text(
            'az alábbi emelőgépekhez biztosít hozzáférést',
            style: TextStyle(color: Colors.teal[900]),
            textAlign: TextAlign.center,
          ),
          Text(
            'mint $_role:',
            style: TextStyle(color: Colors.teal[900]),
            textAlign: TextAlign.center,
          ),
          Divider(
            height: 8,
          ),
          _showList
              ? AssignedProductsPage(
                  database: widget.database,
                  company: widget.company,
                  uid: widget.uid,
                )
              : FindProduct(
                  database: widget.database,
                  company: widget.company,
                  uid: widget.uid,
                  operandsName: widget.operandsName,
                  role: widget.role,
                ),
        ],
      ),
    );
  }

  _convertRole(String role) {
    switch (role) {
      case 'inspector':
        {
          _role = 'vizsgáló';
        }
        break;
      case 'operator':
        {
          _role = 'gépkezelő';
        }
        break;
      case 'service':
        {
          _role = 'szervíz';
        }
        break;
      default:
        {
          _role = 'gépkezelő';
        }
        break;
    }
  }
}
